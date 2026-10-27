import json
import tempfile
import unittest
from pathlib import Path

from validate import validate

SKILL = """---
name: demo
description: Use when testing.
---

Read `${CLAUDE_SKILL_DIR}/templates/base.md`. Replace `{{extra}}` with notes.
"""


def make_repo(root, skill=SKILL, base="{{block}}\n{{extra}}\n", version="1.0.0", files=None):
    skill_dir = root / "skills/demo"
    (skill_dir / "templates").mkdir(parents=True)
    (skill_dir / "SKILL.md").write_text(skill)
    (skill_dir / "templates/base.md").write_text(base)
    (skill_dir / "templates/block.md").write_text("block\n")
    (root / ".claude-plugin").mkdir()
    (root / ".claude-plugin/plugin.json").write_text(json.dumps({"name": "demo", "version": version}))
    (root / ".claude-plugin/marketplace.json").write_text(json.dumps({"plugins": [{"name": "demo"}]}))
    (root / "CHANGELOG.md").write_text("## [1.0.0] — 2026-01-01\n")
    (root / "README.md").write_text("[log](./CHANGELOG.md)\n")
    for rel, text in (files or {}).items():
        (root / rel).write_text(text)


class ValidateTest(unittest.TestCase):
    def run_case(self, **kwargs):
        with tempfile.TemporaryDirectory() as tmp:
            make_repo(Path(tmp), **kwargs)
            return validate(tmp)

    def test_valid_repo_passes(self):
        self.assertEqual(self.run_case(), [])

    def test_name_must_match_directory(self):
        errors = self.run_case(skill=SKILL.replace("name: demo", "name: other"))
        self.assertTrue(any("must match directory" in e for e in errors))

    def test_missing_bundled_template(self):
        errors = self.run_case(skill=SKILL.replace("base.md", "gone.md"))
        self.assertTrue(any("gone.md" in e for e in errors))

    def test_unexplained_placeholder(self):
        errors = self.run_case(base="{{block}}\n{{mystery}}\n")
        self.assertTrue(any("{{mystery}}" in e for e in errors))

    def test_version_must_match_changelog(self):
        errors = self.run_case(version="0.9.0")
        self.assertTrue(any("CHANGELOG" in e for e in errors))

    def test_old_name_in_skill_reported(self):
        errors = self.run_case(skill=SKILL + "Stage into `lovable-export/`.\n")
        self.assertTrue(any("lovable-export" in e and "SKILL.md" in e for e in errors))

    def test_old_name_allowed_in_history(self):
        errors = self.run_case(files={
            "CHANGELOG.md": "## [1.0.0] — 2026-01-01\nRenamed `ui-translator`.\n",
            "PILOT_RETROSPECTIVE.md": "Wrote `LOVABLE_PROMPT.md`.\n",
            "README.md": "# Demo\n\n## Migrating from 0.x\n\n```bash\n# move it\nmv lovable-export .ui-workflow/export\n```\n\n"
                         "`/ingest-lovable-export` is gone.\n",
        })
        self.assertEqual(errors, [])

    def test_old_name_after_migration_section_reported(self):
        errors = self.run_case(files={
            "README.md": "## Migrating from 0.x\n\n`ui-translator` renamed.\n\n## Usage\n\nRun `/ui-translator`.\n",
        })
        self.assertTrue(any("README.md:7" in e and "ui-translator" in e for e in errors))


if __name__ == "__main__":
    unittest.main()
