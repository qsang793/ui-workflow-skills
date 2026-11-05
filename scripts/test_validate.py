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

EN_GUIDE = "docs/stakeholder-guide.md"
VI_GUIDE = "docs/stakeholder-guide.vi.md"


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
    (root / "docs").mkdir()
    (root / EN_GUIDE).write_text("# Guide\n")
    for rel, text in (files or {}).items():
        (root / rel).parent.mkdir(parents=True, exist_ok=True)
        (root / rel).write_text(text)


class ValidateTest(unittest.TestCase):
    def run_case(self, **kwargs):
        with tempfile.TemporaryDirectory() as tmp:
            make_repo(Path(tmp), **kwargs)
            return validate(tmp)

    def test_valid_repo_passes(self):
        self.assertEqual(self.run_case(), [])

    def test_eval_results_must_not_hold_a_home_path(self):
        files = {"evals/results/run/aggregate-result.json": '{"cwd": "/Users/someone/repo"}'}
        self.assertTrue(any("local home path" in e for e in self.run_case(files=files)))
        clean = {"evals/results/run/aggregate-result.json": '{"cwd": "~/repo"}'}
        self.assertEqual(self.run_case(files=clean), [])

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
            "docs/history/example-retrospective.md": "Wrote `LOVABLE_PROMPT.md`.\n",
            "README.md": "# Demo\n\n## Migrating from 0.x\n\n```bash\n# move it\nmv lovable-export .ui-workflow/export\n```\n\n"
                         "`/ingest-lovable-export` is gone.\n",
        })
        self.assertEqual(errors, [])

    def test_agent_worktrees_ignored(self):
        with tempfile.TemporaryDirectory() as tmp:
            make_repo(Path(tmp))
            stale = Path(tmp) / ".claude/worktrees/old/skills/x"
            stale.mkdir(parents=True)
            (stale / "SKILL.md").write_text("Run `/ui-translator`. [gone](./gone.md)\n")
            self.assertEqual(validate(tmp), [])

    def test_old_name_after_migration_section_reported(self):
        errors = self.run_case(files={
            "README.md": "## Migrating from 0.x\n\n`ui-translator` renamed.\n\n## Usage\n\nRun `/ui-translator`.\n",
        })
        self.assertTrue(any("README.md:7" in e and "ui-translator" in e for e in errors))

    def test_guide_naming_missing_command_reported(self):
        errors = self.run_case(files={EN_GUIDE: "Run `/demo:demo`, then `/demo:gone`.\n"})
        self.assertEqual(len(errors), 1)
        self.assertIn(f"{EN_GUIDE}:1", errors[0])
        self.assertIn("/demo:gone", errors[0])

    def test_guide_command_at_end_of_sentence_reported(self):
        errors = self.run_case(files={EN_GUIDE: "Then run /demo:gone.\n"})
        self.assertTrue(any("/demo:gone" in e for e in errors))

    def test_guide_command_with_capitals_reported(self):
        errors = self.run_case(files={EN_GUIDE: "Run `/demo:Demo`.\n"})
        self.assertTrue(any("/demo:Demo" in e for e in errors))

    def test_missing_guide_reported(self):
        with tempfile.TemporaryDirectory() as tmp:
            make_repo(Path(tmp))
            (Path(tmp) / EN_GUIDE).unlink()
            self.assertTrue(any("no Stakeholder guide" in e for e in validate(tmp)))

    def test_plugin_command_outside_guides_checked(self):
        errors = self.run_case(skill=SKILL + "Next: `/demo:gone`.\n", files={"README.md": "Run `/demo:gone`, then `/plugin` or `/demo`.\n"})
        self.assertEqual(len(errors), 2)
        self.assertTrue(all("/demo:gone" in e for e in errors))

    def test_plugin_command_in_history_ignored(self):
        self.assertEqual(self.run_case(files={"CHANGELOG.md": "## [1.0.0] — 2026-01-01\nRemoved `/demo:gone`.\n"}), [])

    def test_guide_command_without_plugin_name_reported(self):
        errors = self.run_case(files={EN_GUIDE: "Run `/demo`.\n"})
        self.assertTrue(any("/demo " in e for e in errors))

    def test_guide_paths_and_urls_are_not_commands(self):
        text = "Scenarios A/B read `.ui-workflow/state.md`, `/api/users` and https://example.com/docs. Run /demo:demo.\n"
        self.assertEqual(self.run_case(files={EN_GUIDE: text}), [])

    def test_guides_with_same_outline_pass(self):
        errors = self.run_case(files={
            EN_GUIDE: "# Guide\n\n## Start\n\nRun `/demo:demo`.\n",
            VI_GUIDE: "# Hướng dẫn\n\n## Bắt đầu\n\nChạy `/demo:demo`.\n",
        })
        self.assertEqual(errors, [])

    def test_guides_naming_different_commands_reported(self):
        errors = self.run_case(files={EN_GUIDE: "Run `/demo:demo`.\n", VI_GUIDE: "Chưa có lệnh.\n"})
        self.assertTrue(any(VI_GUIDE in e and "differs from" in e for e in errors))

    def test_guides_with_different_headings_reported(self):
        errors = self.run_case(files={EN_GUIDE: "## Start\n", VI_GUIDE: "### Bắt đầu\n"})
        self.assertTrue(any(VI_GUIDE in e and "differs from" in e for e in errors))


if __name__ == "__main__":
    unittest.main()
