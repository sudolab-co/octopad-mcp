#!/usr/bin/env python3
"""Copy pinned Octopad satellites, or verify the complete local Codex package."""
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


def synchronize(root=ROOT, check=False):
    package = root / 'plugins/octopad'
    canon = root / 'config/shared-skills'
    safe_tree(root, canon)
    safe_tree(root, package)
    provenance = json.loads((root / 'docs/octopad/package-provenance.json').read_text())
    kernel = root / 'docs/octopad/kernel-r2.md'
    require(not kernel.exists(), 'kernel text must not be published in this repository')
    manifest = json.loads((package / '.codex-plugin/plugin.json').read_text())
    version = provenance['plugin_version']
    require(manifest['name'] == 'octopad' and manifest['version'] == version, 'plugin identity/version drift')
    require(manifest['skills'] == './skills/' and manifest['mcpServers'] == './.mcp.json', 'component path drift')
    require(json.loads((package / '.mcp.json').read_text()) == {
        'mcpServers': {'octopad': {'type': 'http', 'url': 'https://mcp.octopad.app/mcp'}}
    }, 'connector drift or extra connection configuration')
    marketplace = json.loads((root / '.agents/plugins/marketplace.json').read_text())
    entries = [p for p in marketplace['plugins'] if p['name'] == 'octopad']
    require(len(entries) == 1, 'expected one Octopad marketplace entry')
    require(entries[0] == {'name': 'octopad', 'source': {'source': 'local', 'path': './plugins/octopad'},
                          'policy': {'installation': 'AVAILABLE', 'authentication': 'ON_INSTALL'},
                          'category': 'Productivity'}, 'marketplace entry drift')
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
    bootstrap = package / 'skills/octopad-session/SKILL.md'
    bootstrap_text = bootstrap.read_text()
    require(f'Version: {version}\n' in bootstrap_text and 'Leave `methodology` unset.' in bootstrap_text
            and 'kernel@' not in bootstrap_text, 'bootstrap version/session contract drift')
    require(set(re.findall(r'\]\(\.\./([^/]+)/SKILL.md\)', bootstrap_text)) == SATELLITES, 'bootstrap routing drift')
    # Validate all inputs before copying; never remove unexpected generated files.
    if not check:
        for relative, content in files.items():
            target = package / relative
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(content)
    actual = {p.relative_to(package).as_posix(): p.read_bytes() for p in (package / 'skills').rglob('*') if p.is_file()}
    expected = {**files, 'skills/octopad-session/SKILL.md': bootstrap.read_bytes()}
    require(actual == expected, 'distribution drift or unexpected skills; run python3 scripts/sync-octopad.py')
    require({p.relative_to(package).as_posix() for p in package.rglob('*') if p.is_file()} ==
            set(expected) | {'.codex-plugin/plugin.json', '.mcp.json'}, 'unexpected plugin file (kernel must remain server-owned)')
    shared.validate_documents(package, actual)
    require('modules/' not in '\n'.join(b.decode() for b in actual.values()), 'obsolete module path')
    require(f'### {version} — ' in (root / 'CHANGELOG.md').read_text().split('## octopad\n', 1)[1].split('\n## ', 1)[0], 'missing release note')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    try:
        synchronize(check=args.check)
    except (ValueError, OSError, KeyError, IndexError) as error:
        parser.exit(1, f'FAIL: {error}\n')
    print('PASS: Octopad source pins, nine satellites, bootstrap, connector, marketplace and package parity')
