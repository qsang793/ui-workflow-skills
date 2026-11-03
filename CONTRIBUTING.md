# Contributing

## Repository layout

```
.claude-plugin/    plugin.json (the single source of the version), marketplace.json, icon.png
skills/            the 8 skills; design-brief/templates/ holds the prompt templates
docs/              Stakeholder guides, install, status, workflow contract, ADRs, pilots, research
evals/             behavioural evals for `claude plugin eval`
scripts/           static validator and its tests
GLOSSARY.md        domain vocabulary
CHANGELOG.md       version history
```

What the skills hand each other: [docs/workflow-contract.md](docs/workflow-contract.md). Vocabulary: [GLOSSARY.md](GLOSSARY.md). Decisions: [docs/adr/](docs/adr/).

## Checks

Each skill is one Markdown file. Before pushing, run the static checks (CI runs them on every pull request):

```bash
python3 -m unittest discover -s scripts -p "test_*.py"
```

```bash
python3 scripts/validate.py
```

```bash
claude plugin validate ./ --strict
```

`validate.py` also checks commands. Every `/ui-workflow-skills:` command in current Markdown must be an existing skill. In the Stakeholder guides every command must have that form, and the English and Vietnamese guides must share the same headings and commands in the same order, so change both together. To change a skill's behaviour, run its eval too; see [evals/README.md](evals/README.md).

## Release

1. Bump `version` in `.claude-plugin/plugin.json` and add an entry with the same number at the top of `CHANGELOG.md`. CI fails if they differ.
2. Commit and tag: `git tag -a v<version> -m "v<version>"`, then `git push --tags`.
