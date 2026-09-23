#!/usr/bin/env python3
"""Mutation tests against the real copier and validator; no model or network calls."""
import importlib.util
import json
from pathlib import Path
import shutil
import sys
import tempfile
import unittest

sys.dont_write_bytecode = True
spec = importlib.util.spec_from_file_location('validate_octoplan', Path(__file__).with_name('validate-octoplan.py'))
validator = importlib.util.module_from_spec(spec)
spec.loader.exec_module(validator)
sync = validator.sync


class PackagingTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='octoplan-test-')
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.source = self.root / 'skills/octoplan'
        (self.source / 'references').mkdir(parents=True)
        (self.source / 'SKILL.md').write_text('---\nname: octoplan\n---\nVersion: 2.0.0\n[Phase](references/phase.md)\n')
        (self.source / 'references/phase.md').write_text('# Phase\n')
        self.codex = self.root / 'plugins/octopad-codex/skills/octoplan'
        (self.codex / 'agents').mkdir(parents=True)
        (self.codex / 'agents/openai.yaml').write_bytes(b'native metadata\n')
        sync.synchronize(self.root)

    def test_parity_and_metadata_preserved(self):
        sync.synchronize(self.root, check=True)
        sync.synchronize(self.root)
        self.assertEqual((self.codex / 'agents/openai.yaml').read_bytes(), b'native metadata\n')
        self.assertFalse((self.root / 'plugins/octopad-claude/skills/octoplan/agents').exists())

    def test_changed_and_added_source_documents(self):
        for relative in ('references/phase.md', 'references/new/nested.md'):
            path = self.source / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text('# Changed\n')
            with self.assertRaisesRegex(ValueError, 'drift'):
                sync.synchronize(self.root, check=True)
            sync.synchronize(self.root)
            sync.synchronize(self.root, check=True)

    def test_removed_source_document_remains_visible_as_drift(self):
        (self.source / 'references/phase.md').rename(self.root / 'retired.md')
        (self.source / 'SKILL.md').write_text('Version: 2.0.0\n')
        sync.synchronize(self.root)
        with self.assertRaisesRegex(ValueError, 'drift'):
            sync.synchronize(self.root, check=True)
        self.assertTrue((self.codex / 'references/phase.md').exists())

    def test_unexpected_copy_and_content_drift(self):
        (self.codex / 'references/extra.md').write_text('extra')
        with self.assertRaisesRegex(ValueError, 'drift'):
            sync.synchronize(self.root, check=True)

    def test_broken_and_escaping_links(self):
        for target in ('missing.md', '../../../retired.md'):
            (self.source / 'references/phase.md').write_text(f'[broken]({target})\n')
            with self.assertRaisesRegex(ValueError, 'link'):
                sync.synchronize(self.root)

    def test_private_material_rejected_before_copy(self):
        before = (self.codex / 'SKILL.md').read_bytes()
        (self.source / 'SKILL.md').write_text('Private /Users/example/secret\n')
        with self.assertRaisesRegex(ValueError, 'private material'):
            sync.synchronize(self.root)
        self.assertEqual((self.codex / 'SKILL.md').read_bytes(), before)

    def test_symlink_rejected_before_copy(self):
        (self.codex / 'references/link.md').symlink_to(self.source / 'SKILL.md')
        with self.assertRaisesRegex(ValueError, 'symlink'):
            sync.synchronize(self.root)

    def test_real_release_version_and_metadata_mutations(self):
        fixture = self.root / 'release'
        for relative in ('skills/octoplan', 'plugins/octopad-codex', 'plugins/octopad-claude'):
            shutil.copytree(sync.ROOT / relative, fixture / relative)
        for relative in ('README.md', 'CHANGELOG.md'):
            shutil.copyfile(sync.ROOT / relative, fixture / relative)
        validator.validate(fixture)
        manifest = fixture / 'plugins/octopad-codex/.codex-plugin/plugin.json'
        original = manifest.read_text()
        changed = json.loads(original)
        changed["name"] = "octoplan-codex"
        manifest.write_text(json.dumps(changed))
        with self.assertRaisesRegex(AssertionError, 'identity mismatch'):
            validator.validate(fixture)
        manifest.write_text(original)
        agent = fixture / 'plugins/octopad-codex/skills/octoplan/agents/openai.yaml'
        agent.write_text('interface: {}\n')
        with self.assertRaisesRegex(AssertionError, 'metadata mismatch'):
            validator.validate(fixture)


if __name__ == '__main__':
    unittest.main()
