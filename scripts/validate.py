#!/usr/bin/env python3
"""Static checks for the skill bundle. Run from anywhere: python3 scripts/validate.py"""
import json
import re
import sys
from pathlib import Path

NAME_RE = re.compile(r"^[a-z0-9]+(-[a-z0-9]+)*$")
PLACEHOLDER_RE = re.compile(r"\{\{([a-z0-9-]+)\}\}")
# Backticked path to a bundled file, e.g. `templates/brand-block.md`.
BUNDLED_PATH_RE = re.compile(r"`(?:\$\{CLAUDE_SKILL_DIR\}/)?(templates/[\w./-]+)`")
MD_LINK_RE = re.compile(r"\]\((?!https?://|mailto:|#)([^)#\s]+)")
CHANGELOG_VERSION_RE = re.compile(r"^## \[(\d+\.\d+\.\d+)\]", re.M)


def parse_frontmatter(text):
    if not text.startswith("---\n"):
        return None
    end = text.find("\n---", 4)
    if end == -1:
        return None
    fields = {}
    for line in text[4:end].splitlines():
        key, sep, value = line.partition(":")
        if sep:
            fields[key.strip()] = value.strip()
    return fields


def check_skill(skill_dir):
    errors = []
    skill_md = skill_dir / "SKILL.md"
    if not skill_md.is_file():
        return [f"{skill_dir}: missing SKILL.md"]
    text = skill_md.read_text(encoding="utf-8")
    fm = parse_frontmatter(text)
    if fm is None:
        return [f"{skill_md}: missing or unterminated frontmatter"]

    name = fm.get("name", "")
    if name != skill_dir.name:
        errors.append(f"{skill_md}: name '{name}' must match directory '{skill_dir.name}'")
    if not NAME_RE.match(name) or len(name) > 64:
        errors.append(f"{skill_md}: name must be lowercase letters, digits and hyphens, max 64 chars")
    description = fm.get("description", "")
    if not description:
        errors.append(f"{skill_md}: description is empty")
    elif len(description) > 1024:
        errors.append(f"{skill_md}: description is {len(description)} chars, max 1024")

    for rel in BUNDLED_PATH_RE.findall(text):
        if not (skill_dir / rel).is_file():
            errors.append(f"{skill_md}: references `{rel}` but {skill_dir / rel} does not exist")

    templates = skill_dir / "templates"
    if templates.is_dir():
        for tpl in sorted(templates.glob("*.md")):
            for ph in set(PLACEHOLDER_RE.findall(tpl.read_text(encoding="utf-8"))):
                # A placeholder is either another template file or explained in SKILL.md.
                if not (templates / f"{ph}.md").is_file() and f"{{{{{ph}}}}}" not in text:
                    errors.append(f"{tpl}: placeholder {{{{{ph}}}}} has no template file and is not explained in SKILL.md")
    return errors


def check_links(root):
    errors = []
    for md in root.rglob("*.md"):
        if ".git" in md.parts:
            continue
        for target in MD_LINK_RE.findall(md.read_text(encoding="utf-8")):
            if not (md.parent / target).exists():
                errors.append(f"{md}: broken link {target}")
    return errors


def check_manifests(root, skill_names):
    errors = []
    try:
        plugin = json.loads((root / ".claude-plugin/plugin.json").read_text(encoding="utf-8"))
        marketplace = json.loads((root / ".claude-plugin/marketplace.json").read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        return [f".claude-plugin: {exc}"]

    versions = CHANGELOG_VERSION_RE.findall((root / "CHANGELOG.md").read_text(encoding="utf-8"))
    if not versions or plugin.get("version") != versions[0]:
        errors.append(f"plugin.json version {plugin.get('version')} != latest CHANGELOG version {versions[:1]}")
    if not any(p.get("name") == plugin.get("name") for p in marketplace.get("plugins", [])):
        errors.append("marketplace.json does not list the plugin from plugin.json")
    if not skill_names:
        errors.append("no skills found under skills/")
    return errors


def validate(root):
    root = Path(root)
    skill_dirs = sorted(p for p in (root / "skills").iterdir() if p.is_dir())
    errors = []
    for d in skill_dirs:
        errors += check_skill(d)
    errors += check_links(root)
    errors += check_manifests(root, [d.name for d in skill_dirs])
    return errors


if __name__ == "__main__":
    root = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parent.parent
    problems = validate(root)
    for p in problems:
        print(f"ERROR {p}")
    print(f"{len(problems)} problem(s)")
    sys.exit(1 if problems else 0)
