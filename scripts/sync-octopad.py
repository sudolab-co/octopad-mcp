#!/usr/bin/env python3
"""Copy pinned Octopad satellites, or verify both complete local Octopad packages."""
import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import re
import sys

sys.dont_write_bytecode = True
ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location('octoplan_sync', Path(__file__).with_name('sync-octoplan.py'))
shared = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(shared)
SATELLITES = {
    'octopad-knowledge-evidence', 'octopad-planning-and-work-design', 'octopad-notepad',
    'manage-activity-context', 'manage-market-intelligence', 'manage-product-documentation',
    'manage-product-marketing', 'pmm-check', 'technical-writing',
}
RUNTIMES = ('claude', 'codex')
CONNECTOR = {'mcpServers': {'octopad': {'type': 'http', 'url': 'https://mcp.octopad.app/mcp'}}}


def require(condition, message):
    if not condition:
        raise ValueError(message)


def safe_tree(root, path):
    for item in [path, *path.parents]:
        if item == root.parent:
            break
        require(not item.is_symlink(), f'symlink: {item}')
    if path.exists():
        for item in path.rglob('*'):
            require(not item.is_symlink(), f'symlink: {item}')


MANIFEST_KEYS = {
    'claude': {'name', 'version', 'description', 'author', 'homepage', 'repository', 'license', 'keywords', 'mcpServers'},
    'codex': {'name', 'version', 'description', 'author', 'homepage', 'repository', 'license', 'keywords', 'skills',
              'mcpServers', 'interface'},
}
# The only bootstrap lines allowed to differ between runtimes: how the client loads it, and other connections.
RUNTIME_LINES = ('Read this bootstrap before any Octopad tool call.', '1. Use the Octopad MCP connect')


def check_manifest(root, runtime, package, version):
    manifest = json.loads((package / f'.{runtime}-plugin/plugin.json').read_text())
    require(set(manifest) <= MANIFEST_KEYS[runtime], f'{runtime} manifest has unexpected keys (no hooks or extra components)')
    require(manifest['name'] == 'octopad' and manifest['version'] == version, f'{runtime} plugin identity/version drift')
    require(manifest['mcpServers'] == './.mcp.json', f'{runtime} component path drift')
    require(json.loads((package / '.mcp.json').read_text()) == CONNECTOR, f'{runtime} connector drift or extra connection configuration')
    if runtime == 'codex':
        require(manifest['skills'] == './skills/', 'codex component path drift')
        marketplace = json.loads((root / '.agents/plugins/marketplace.json').read_text())
        entries = [p for p in marketplace['plugins'] if p['name'] == 'octopad']
        require(len(entries) == 1, 'expected one Octopad marketplace entry per runtime')
        require(entries[0] == {'name': 'octopad', 'source': {'source': 'local', 'path': './plugins/octopad-codex'},
                              'policy': {'installation': 'AVAILABLE', 'authentication': 'ON_INSTALL'},
                              'category': 'Productivity'}, 'codex marketplace entry drift')
    else:
        marketplace = json.loads((root / '.claude-plugin/marketplace.json').read_text())
        entries = [p for p in marketplace['plugins'] if p['name'] == 'octopad']
        require(len(entries) == 1, 'expected one Octopad marketplace entry per runtime')
        require(entries[0]['source'] == './plugins/octopad-claude', 'claude marketplace entry drift')


def synchronize(root=ROOT, check=False):
    canon = root / 'config/shared-skills'
    safe_tree(root, canon)
    provenance = json.loads((root / 'docs/octopad/package-provenance.json').read_text())
    kernel = root / 'docs/octopad/kernel-r2.md'
    require(not kernel.exists(), 'kernel text must not be published in this repository')
    version = provenance['plugin_version']
    files = {}
    canonical_paths = set()
    for entry in provenance['entries']:
        relative = Path(entry['packaged'])
        require(len(relative.parts) >= 3 and relative.parts[0] == 'skills' and relative.parts[1] in SATELLITES
                and '..' not in relative.parts and relative.suffix == '.md', 'invalid satellite path')
        source_relative = Path('config/shared-skills').joinpath(*relative.parts[1:])
        require(str(source_relative) == entry['canonical'], 'invalid canonical path')
        require(relative.as_posix() not in files, 'duplicate satellite path')
        content = (root / source_relative).read_bytes()
        require(hashlib.sha256(content).hexdigest() == entry['sha256'], f'qualified source drift: {source_relative}')
        canonical_paths.add(source_relative)
        files[relative.as_posix()] = content
    require(len(files) == 17, 'expected 17 qualified satellite files')
    require({p.relative_to(root) for p in canon.rglob('*') if p.is_file()} == canonical_paths,
            'unexpected or missing canonical file')
    for name in SATELLITES:
        prefix = f'skills/{name}/'
        documents = {p[len(prefix):]: b for p, b in files.items() if p.startswith(prefix)}
        skill = documents['SKILL.md'].decode()
        require(re.search(rf'^name: {re.escape(name)}$', skill, re.M), f'skill name drift: {name}')
        require(skill.startswith('---\n') and '\n---\n' in skill, f'invalid skill header: {name}')
        require(re.search(r'^Version: \d+\.\d+\.\d+|^  version: "\d+\.\d+\.\d+"', skill, re.M), f'missing version: {name}')
        shared.validate_documents(canon / name, documents)
    # Octoplan is copied by sync-octoplan.py; here it only counts as an expected bundle member.
    octoplan = {f'skills/octoplan/{k}': v for k, v in shared.documents(root / 'skills/octoplan').items()}
    packages = {runtime: root / f'plugins/octopad-{runtime}' for runtime in RUNTIMES}
    bootstraps = {}
    # Validate every input of both packages before copying; never remove unexpected generated files.
    for runtime, package in packages.items():
        safe_tree(root, package)
        check_manifest(root, runtime, package, version)
        bootstrap_text = (package / 'skills/octopad-session/SKILL.md').read_text()
        require(f'Version: {version}\n' in bootstrap_text and 'Leave `methodology` unset.' in bootstrap_text
                and 'kernel@' not in bootstrap_text, f'{runtime} bootstrap version/session contract drift')
        require(set(re.findall(r'\]\(\.\./([^/]+)/SKILL.md\)', bootstrap_text)) == SATELLITES | {'octoplan'},
                f'{runtime} bootstrap routing drift')
        bootstraps[runtime] = bootstrap_text.encode()
    claude_lines, codex_lines = (bootstraps[r].decode().splitlines() for r in RUNTIMES)
    require(len(claude_lines) == len(codex_lines) and all(
        a == b or (a.startswith(RUNTIME_LINES) and b.startswith(RUNTIME_LINES) and a[:20] == b[:20])
        for a, b in zip(claude_lines, codex_lines)), 'bootstraps diverge beyond their runtime lines')
    octoplan_version = re.search(r'^Version: (\d+\.\d+\.\d+)$', octoplan['skills/octoplan/SKILL.md'].decode(), re.M).group(1)
    for runtime, package in packages.items():
        if not check:
            for relative, content in files.items():
                target = package / relative
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_bytes(content)
        native = {'skills/octoplan/agents/openai.yaml'} if runtime == 'codex' else set()
        actual = {p.relative_to(package).as_posix(): p.read_bytes() for p in (package / 'skills').rglob('*') if p.is_file()}
        expected = {**files, **octoplan, 'skills/octopad-session/SKILL.md': bootstraps[runtime]}
        require({k: v for k, v in actual.items() if k not in native} == expected and native <= set(actual),
                f'{runtime} distribution drift or unexpected skills; run python3 scripts/sync-octoplan.py and scripts/sync-octopad.py')
        require({p.relative_to(package).as_posix() for p in package.rglob('*') if p.is_file()} ==
                set(expected) | native | {f'.{runtime}-plugin/plugin.json', '.mcp.json'},
                f'unexpected {runtime} plugin file (kernel must remain server-owned)')
        shared.validate_documents(package, {k: v for k, v in actual.items() if k.endswith('.md')})
        require('modules/' not in '\n'.join(b.decode() for b in actual.values()), 'obsolete module path')
    section = (root / 'CHANGELOG.md').read_text().split('## octopad\n', 1)[1].split('\n## ', 1)[0]
    latest = re.search(r'^### (\d+\.\d+\.\d+) — \d{4}-\d{2}-\d{2}$', section, re.M)
    require(latest and latest.group(1) == version, 'missing release note: the latest octopad entry must be the bundle version')
    entry = section[latest.end():].split('\n### ', 1)[0]
    # A new Octoplan release changes what the bundle ships, so it needs a bundle release that names it.
    require(f'Octoplan {octoplan_version}' in entry, f'bundle release note must name the shipped Octoplan {octoplan_version}')

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    try:
        synchronize(check=args.check)
    except (ValueError, OSError, KeyError, IndexError) as error:
        parser.exit(1, f'FAIL: {error}\n')
    print('PASS: Octopad source pins, nine satellites, Octoplan, both bootstraps, connectors, marketplaces and package parity')
