#!/usr/bin/env python3
"""Exercise package corruption against the real validator, offline."""
import importlib.util
import json
from pathlib import Path
import shutil
import sys
import tempfile
import unittest
sys.dont_write_bytecode = True
spec = importlib.util.spec_from_file_location('octopad_sync', Path(__file__).with_name('sync-octopad.py'))
sync = importlib.util.module_from_spec(spec)
spec.loader.exec_module(sync)

class PackageTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='octopad-package-test-')
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        for relative in ('plugins/octopad', 'config/shared-skills', 'docs/octopad', '.agents/plugins'):
            shutil.copytree(sync.ROOT / relative, self.root / relative)
        shutil.copyfile(sync.ROOT / 'CHANGELOG.md', self.root / 'CHANGELOG.md')
        self.package = self.root / 'plugins/octopad'

    def test_current_package_and_repeat_copy(self):
        sync.synchronize(self.root, check=True)
        sync.synchronize(self.root)
        sync.synchronize(self.root, check=True)

    def test_source_drift_cannot_be_copied(self):
        target = self.root / 'config/shared-skills/octopad-notepad/SKILL.md'
        before = (self.package / 'skills/octopad-notepad/SKILL.md').read_bytes()
        target.write_text(target.read_text().replace('never rewrite', 'rewrite'))
        with self.assertRaisesRegex(ValueError, 'qualified source drift'):
            sync.synchronize(self.root)
        self.assertEqual((self.package / 'skills/octopad-notepad/SKILL.md').read_bytes(), before)

    def test_missing_reference_and_extra_skill(self):
        (self.package / 'skills/pmm-check/references/evidence-basis.md').rename(self.root / 'saved-reference.md')
        with self.assertRaisesRegex(ValueError, 'distribution drift'):
            sync.synchronize(self.root, check=True)
        sync.synchronize(self.root)
        extra = self.package / 'skills/extra/SKILL.md'
        extra.parent.mkdir()
        extra.write_text('unexpected')
        with self.assertRaisesRegex(ValueError, 'distribution drift'):
            sync.synchronize(self.root)
        self.assertTrue(extra.exists())

    def test_symlink_rejected_before_copy(self):
        target = self.package / 'skills/pmm-check/SKILL.md'
        target.rename(self.root / 'saved-skill.md')
        target.symlink_to(self.root / 'config/shared-skills/pmm-check/SKILL.md')
        with self.assertRaisesRegex(ValueError, 'symlink'):
            sync.synchronize(self.root)

    def test_wrong_endpoint(self):
        path = self.package / '.mcp.json'
        path.write_text(path.read_text().replace('mcp.octopad.app', 'mcp-staging.octopad.app'))
        with self.assertRaisesRegex(ValueError, 'connector drift'):
            sync.synchronize(self.root, check=True)

    def test_experimental_marker_forbidden(self):
        path = self.package / 'skills/octopad-session/SKILL.md'
        path.write_text(path.read_text() + '\nSend kernel@1.0.0\n')
        with self.assertRaisesRegex(ValueError, 'session contract drift'):
            sync.synchronize(self.root, check=True)

    def test_second_kernel_forbidden(self):
        (self.package / 'kernel.md').write_text('second kernel')
        with self.assertRaisesRegex(ValueError, 'kernel must remain server-owned'):
            sync.synchronize(self.root, check=True)

    def test_public_kernel_forbidden(self):
        path = self.root / 'docs/octopad/kernel-r2.md'
        path.write_text('unwanted kernel copy')
        with self.assertRaisesRegex(ValueError, 'kernel text must not be published'):
            sync.synchronize(self.root, check=True)

    def test_duplicate_marketplace_entry(self):
        path = self.root / '.agents/plugins/marketplace.json'
        data = json.loads(path.read_text())
        data['plugins'].append(next(p for p in data['plugins'] if p['name'] == 'octopad'))
        path.write_text(json.dumps(data))
        with self.assertRaisesRegex(ValueError, 'one Octopad marketplace'):
            sync.synchronize(self.root, check=True)

    def test_bootstrap_link_cannot_escape(self):
        path = self.package / 'skills/octopad-session/SKILL.md'
        path.write_text(path.read_text() + '\n[escape](../../../../CHANGELOG.md)\n')
        with self.assertRaisesRegex(ValueError, 'escaping local link'):
            sync.synchronize(self.root, check=True)

if __name__ == '__main__':
    unittest.main()
