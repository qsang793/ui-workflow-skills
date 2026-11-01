#!/usr/bin/env python3
"""Static checks for the skill bundle. Run from anywhere: python3 scripts/validate.py"""
import json
import re
import sys
from itertools import zip_longest
from pathlib import Path

NAME_RE = re.compile(r"^[a-z0-9]+(-[a-z0-9]+)*$")
PLACEHOLDER_RE = re.compile(r"\{\{([a-z0-9-]+)\}\}")
# Backticked path to a bundled file, e.g. `templates/brand-block.md`.
BUNDLED_PATH_RE = re.compile(r"`(?:\$\{CLAUDE_SKILL_DIR\}/)?(templates/[\w./-]+)`")
MD_LINK_RE = re.compile(r"\]\((?!https?://|mailto:|#)([^)#\s]+)")
CHANGELOG_VERSION_RE = re.compile(r"^## \[(\d+\.\d+\.\d+)\]", re.M)
OLD_NAME_RE = re.compile(r"ingest-lovable-export|lovable-export|LOVABLE_PROMPT|ui-translator")
HEADING_RE = re.compile(r"(#+) ")
LOCAL_PATH_RE = re.compile(r"/(?:Users|home)/[\w.-]+")
GUIDE_GLOB = "docs/stakeholder-guide*.md"
# A slash command as typed, /name or /plugin:name; not a path, a URL or A/B.
COMMAND_RE = re.compile(r"(?<![\w./:~-])/([\w-]+(?::[\w-]+)?)(?![\w/-]|\.\w)")


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


def markdown_files(root):
    # Skip git internals and agent worktrees, which are other checkouts of this repo.
    for md in root.rglob("*.md"):
        rel = md.relative_to(root).parts
        if ".git" not in rel and rel[:2] != (".claude", "worktrees"):
            yield md


def check_links(root):
    errors = []
    for md in markdown_files(root):
        for target in MD_LINK_RE.findall(md.read_text(encoding="utf-8")):
            if not (md.parent / target).exists():
                errors.append(f"{md}: broken link {target}")
    return errors


def active_lines(text):
    """Yield (line number, line), skipping any "Migrating from 0.x" section."""
    level, fenced = None, False
    for n, line in enumerate(text.splitlines(), 1):
        if line.lstrip().startswith(("```", "~~~")):
            fenced = not fenced
        heading = None if fenced else HEADING_RE.match(line)
        if heading and level and len(heading.group(1)) <= level:
            level = None
        if heading and "Migrating from 0.x" in line:
            level = len(heading.group(1))
        if not level:
            yield n, line


def is_history(md):
    return md.name == "CHANGELOG.md" or "retrospective" in md.name.lower()


def check_old_names(root):
    # 0.x names may stay only in historical text: the changelog, retrospectives, migration sections.
    errors = []
    for md in markdown_files(root):
        if is_history(md):
            continue
        for n, line in active_lines(md.read_text(encoding="utf-8")):
            for old in OLD_NAME_RE.findall(line):
                errors.append(f"{md}:{n}: old name '{old}'")
    return errors


def check_local_paths(root):
    # Eval results get committed and this repo is public, so a home path must not reach them.
    errors = []
    for path in (root / "evals/results").rglob("*"):
        if path.is_file() and LOCAL_PATH_RE.search(path.read_text(encoding="utf-8", errors="replace")):
            errors.append(f"{path}: contains a local home path")
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


def guide_outline(guide):
    outline = []
    for line in guide.read_text(encoding="utf-8").splitlines():
        heading = HEADING_RE.match(line)
        if heading:
            outline.append(heading.group(1))
        outline += COMMAND_RE.findall(line)
    return outline


def check_commands(root, plugin, skill_names):
    known = {f"{plugin}:{name}" for name in skill_names}
    guides = sorted(root.glob(GUIDE_GLOB))
    errors = [] if guides else [f"no Stakeholder guide matches {GUIDE_GLOB}"]
    for md in markdown_files(root):
        if is_history(md):
            continue
        for n, line in active_lines(md.read_text(encoding="utf-8")):
            for command in COMMAND_RE.findall(line):
                # Guides name only plugin commands; elsewhere /plugin or a short symlink name may appear.
                if command not in known and (md in guides or command.startswith(f"{plugin}:")):
                    errors.append(f"{md}:{n}: /{command} is not an existing skill, as /{plugin}:<skill>")

    # Each language has its own source, so they must share headings and commands, in order.
    for guide in guides[1:]:
        for ours, theirs in zip_longest(guide_outline(guide), guide_outline(guides[0])):
            if ours != theirs:
                errors.append(f"{guide}: outline differs from {guides[0].name}: {ours} where it has {theirs}")
                break
    return errors


def validate(root):
    root = Path(root)
    skill_dirs = sorted(p for p in (root / "skills").iterdir() if p.is_dir())
    skill_names = [d.name for d in skill_dirs]
    errors = []
    for d in skill_dirs:
        errors += check_skill(d)
    errors += check_links(root)
    errors += check_old_names(root)
    errors += check_local_paths(root)
    errors += check_manifests(root, skill_names)
    try:
        plugin = json.loads((root / ".claude-plugin/plugin.json").read_text(encoding="utf-8")).get("name")
    except (OSError, json.JSONDecodeError):
        return errors  # check_manifests reported it
    errors += check_commands(root, plugin, skill_names)
    return errors


if __name__ == "__main__":
    root = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parent.parent
    problems = validate(root)
    for p in problems:
        print(f"ERROR {p}")
    print(f"{len(problems)} problem(s)")
    sys.exit(1 if problems else 0)
