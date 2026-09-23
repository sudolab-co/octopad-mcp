#!/usr/bin/env python3
"""Validate the shared Octoplan package and native distribution metadata."""
import importlib.util
import json
from pathlib import Path
import re
import sys

sys.dont_write_bytecode = True
spec = importlib.util.spec_from_file_location('sync_octoplan', Path(__file__).with_name('sync-octoplan.py'))
sync = importlib.util.module_from_spec(spec)
spec.loader.exec_module(sync)


def validate(root=sync.ROOT):
    sync.synchronize(root, check=True)
    source = root / 'skills/octoplan'
    main = (source / 'SKILL.md').read_text()
    version = re.search(r'^Version: (\d+\.\d+\.\d+)$', main, re.M).group(1)
    assert re.search(r'^name: octoplan$', main, re.M), 'wrong skill identity'
    required = {'planning.md', 'supervision.md', 'recovery.md', 'multi-stream.md', 'codex-runtime.md', 'claude-runtime.md', 'continuation.md'}
    assert required <= {p.name for p in (source / 'references').glob('*.md')}, 'missing shared contract or runtime profile'
    assert all(f'references/{runtime}-runtime.md' in main for runtime in sync.RUNTIMES), 'entrypoint must route to both native profiles'
    foundations = re.findall(r'\*\*F(\d+),', main)
    assert foundations == [str(n) for n in range(1, 17)], 'shared foundation identity/order changed; review the contract'
    banners = re.findall(r'\*\*Octoplan · Step [^*]+\*\*', main)
    assert banners == [f'**Octoplan · Step {n} of 3 — {name}**' for n, name in enumerate(('Brief', 'Plan', 'Delivery'), 1)], 'visible program changed'
    readme = (root / 'README.md').read_text()
    changelog = (root / 'CHANGELOG.md').read_text()
    assert f'Octoplan {version}' in readme, 'README Octoplan version stale'
    for runtime in sync.RUNTIMES:
        # Octoplan ships inside each runtime's Octopad bundle; the bundle keeps its own version.
        name = f'octoplan-{runtime}'
        package = root / 'plugins' / f'octopad-{runtime}'
        manifest = json.loads((package / f'.{runtime}-plugin/plugin.json').read_text())
        assert manifest['name'] == 'octopad' and manifest['license'] == 'MIT', f'{runtime} bundle identity mismatch'
        section = changelog.split(f'## {name}\n', 1)[1].split('\n## ', 1)[0]
        releases = re.findall(r'^### (\d+\.\d+\.\d+) — \d{4}-\d{2}-\d{2}$', section, re.M)
        assert releases[0] == version and releases.count(version) == 1, f'{name} release entry mismatch'
        skill = package / 'skills/octoplan'
        assert set(p.name for p in skill.iterdir()) == ({'SKILL.md', 'references', 'agents'} if runtime == 'codex' else {'SKILL.md', 'references'}), f'{name} unexpected skill payload'
        if runtime == 'codex':
            assert {p.name for p in (skill / 'agents').iterdir()} == {'openai.yaml'}, 'unexpected Codex agent payload'
            agent = (skill / 'agents/openai.yaml').read_text()
            prompt = re.search(r'^  default_prompt: "([^"\n]+)"$', agent, re.M)
            assert prompt and len(prompt.group(1)) <= 128 and '$octoplan' in prompt.group(1) and 'allow_implicit_invocation: true' in agent, 'Codex agent metadata mismatch'
        for path in package.rglob('*'):
            assert not path.is_symlink(), f'package symlink: {path}'
            if path.is_file() and path.suffix in ('.md', '.yaml', '.json'):
                text = path.read_text().replace('support@octopad.ai', '')
                assert not re.search(r'/Users/|/home/|BEGIN (?:RSA |OPENSSH |EC )?PRIVATE KEY|[\w.%+-]+@[\w.-]+\.[A-Za-z]{2,}', text), f'private material: {path}'


if __name__ == '__main__':
    try:
        validate()
    except (AssertionError, ValueError, OSError, KeyError, IndexError, AttributeError) as error:
        sys.exit(f'FAIL: {error}')
    print('PASS: Octoplan shared source, offline packages and metadata')
