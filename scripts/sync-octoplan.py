#!/usr/bin/env python3
"""Copy canonical Octoplan documents, or check committed distribution parity."""
import argparse
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
RUNTIMES = ('claude', 'codex')


def documents(directory):
    if directory.is_symlink():
        raise ValueError(f'symlink is forbidden: {directory}')
    result = {}
    for relative in ('SKILL.md', 'references'):
        target = directory / relative
        if not target.exists():
            raise ValueError(f'missing canonical surface: {target}')
        for item in ([target] if target.is_file() else [target, *sorted(target.rglob('*'))]):
            if item.is_symlink():
                raise ValueError(f'symlink is forbidden: {item}')
            if item.is_file():
                if item.suffix != '.md':
                    raise ValueError(f'only Markdown belongs in the canonical tree: {item}')
                result[item.relative_to(directory).as_posix()] = item.read_bytes()
    return result


def validate_documents(directory, files):
    for relative, content in files.items():
        text = content.decode('utf-8')
        if re.search(r'/Users/|/home/|BEGIN (?:RSA |OPENSSH |EC )?PRIVATE KEY|[\w.%+-]+@[\w.-]+\.[A-Za-z]{2,}', text.replace('support@octopad.ai', '')):
            raise ValueError(f'private material in {directory / relative}')
        links = re.findall(r'\[[^\]]*\]\(([^)\s]+)(?:\s+"[^"]*")?\)', text)
        links += re.findall(r'^\s*\[[^\]]+\]:\s*(\S+)', text, re.M)
        for link in links:
            link = link.strip('<>')
            if re.match(r'https?://|mailto:', link) or link.startswith('#'):
                continue
            target = (directory / relative).parent / link.split('#')[0]
            if not target.resolve().is_relative_to(directory.resolve()) or not target.is_file():
                raise ValueError(f'broken or escaping local link in {relative}: {link}')


def synchronize(root=ROOT, check=False):
    source = root / 'skills/octoplan'
    if (root / 'skills').is_symlink():
        raise ValueError('canonical skills parent must not be a symlink')
    canonical = documents(source)
    validate_documents(source, canonical)
    destinations = [root / f'plugins/octoplan-{runtime}/skills/octoplan' for runtime in RUNTIMES]
    # Preflight both targets before writing; never follow a link out of a package.
    for destination in destinations:
        for item in [destination, *destination.parents]:
            if item == root.parent:
                break
            if item.is_symlink():
                raise ValueError(f'symlink is forbidden: {item}')
        if destination.exists():
            for item in destination.rglob('*'):
                if item.is_symlink():
                    raise ValueError(f'symlink is forbidden: {item}')
    for destination in destinations:
        if check:
            actual = documents(destination)
            if actual != canonical:
                changed = sorted(key for key in canonical.keys() | actual.keys() if canonical.get(key) != actual.get(key))
                raise ValueError(f'distribution drift in {destination}: {", ".join(changed)}; run python3 scripts/sync-octoplan.py')
            validate_documents(destination, actual)
        else:
            destination.mkdir(parents=True, exist_ok=True)
            for relative, content in canonical.items():
                target = destination / relative
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_bytes(content)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true', help='read-only parity, local-link and hygiene check')
    args = parser.parse_args()
    try:
        synchronize(check=args.check)
    except (ValueError, OSError) as error:
        parser.exit(1, f'FAIL: {error}\n')
    print('PASS: Octoplan canonical distribution parity' if args.check else 'Synced both Octoplan distributions')
