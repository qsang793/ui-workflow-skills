<img src=".claude-plugin/icon.png" alt="" width="96" height="96">

# UI Workflow Skills

A Claude Code plugin that lets a non-technical Stakeholder drive the UI improvement of any project: 8 skills around an external AI Design tool (Lovable or Google AI Studio). A Developer steps in only when a skill stops on a Blocker, and does the push, merge and release at the end.

> **Status: Beta.** All three Scenarios are Beta until a real end-to-end pilot passes ([#13](https://github.com/qsang793/ui-workflow-skills/issues/13)). See [Status](#status).

**Stakeholders:** read the guide, in [English](docs/stakeholder-guide.md) or [Vietnamese](docs/stakeholder-guide.vi.md). It needs no code. The rest of this page is for whoever installs and maintains the plugin.

## Install

Tested with Claude Code 2.1.307, the version CI pins.

### Plugin (recommended)

```bash
claude plugin marketplace add qsang793/ui-workflow-skills
```

```bash
claude plugin install ui-workflow-skills@ui-workflow-skills
```

Skills are then named under the plugin, such as `/ui-workflow-skills:ui-scenario-picker`. To update, refresh the marketplace, update the plugin, and restart Claude Code:

```bash
claude plugin marketplace update ui-workflow-skills
```

```bash
claude plugin update ui-workflow-skills@ui-workflow-skills
```

Plugin users get a new release only when `version` changes in `.claude-plugin/plugin.json`.

### Symlink

For short names such as `/ui-scenario-picker`, or to follow the repository:

```bash
git clone https://github.com/qsang793/ui-workflow-skills.git ~/projects/ui-workflow-skills
mkdir -p ~/.claude/skills
ln -sf ~/projects/ui-workflow-skills/skills/* ~/.claude/skills/
```

Check that the 8 skills are there:

```bash
ls ~/.claude/skills/ | grep -E '^(ui-|design-|ingest-|integration-|preview-)'
```

Update with `git pull`. The skills still print the long `ui-workflow-skills:` names in their replies, so a Stakeholder on a symlink install drops that part when typing a command.

### For the Preview step

`preview-deploy` picks the host from the project's shape and never installs these itself:

- A static frontend goes to a Vercel preview. Run `npm i -g vercel` and `vercel login` once, unless Claude already has a logged-in Vercel tool. Vercel also protects previews by default, so someone with access to the Vercel project creates a Shareable Link for each Preview; the Hobby plan allows one per account.
- A backend that renders the UI runs locally behind a temporary tunnel. Run `brew install cloudflared`; no account is needed.

## Flow

Pick a Scenario once, then follow its path. `.ui-workflow/state.md` in the project records the Scenario and the current step, and every skill reads it first and names any step that is missing.

| Scenario | When | Status | Path |
|---|---|---|---|
| A. Greenfield | No frontend yet | Beta | picker → brief → ingest → wire → preview |
| B. Stack migration | Rewrite the frontend in a new stack | Beta | picker → audit → brief → ingest → planner → wire → preview |
| C. Keep stack | Restyle the frontend in its current stack | Beta | picker → audit → brief → ingest → planner → port → preview |

| Step | Command | What it does | Writes |
|---|---|---|---|
| picker | `/ui-workflow-skills:ui-scenario-picker` | Reads the files, asks a few questions, picks the Scenario | `.ui-workflow/state.md` |
| audit | `/ui-workflow-skills:ui-audit` | Maps the stack, pages and pain points | `.ui-workflow/audit.md` |
| brief | `/ui-workflow-skills:design-brief` | Interviews the Stakeholder, writes the English Design prompt | `.ui-workflow/design-prompt.md` |
| (Design tool) | none | The Stakeholder generates the UI and gets the code out | |
| ingest | `/ui-workflow-skills:ingest-design-export` | Stages the Design export without running it, lists its Screens | `.ui-workflow/export/` |
| planner | `/ui-workflow-skills:integration-planner` | Compares the design with the backend. Any Blocker means STOP | `.ui-workflow/integration-plan.md` |
| port (C) | `/ui-workflow-skills:design-port` | Rebuilds one Screen per turn in the existing stack, shows it in the local app, commits after approval | Work branch |
| wire (A, B) | `/ui-workflow-skills:integration-wire` | Places the new frontend, wires it, passes the build, commits after approval | Work branch, `.ui-workflow/wiring.md` |
| preview | `/ui-workflow-skills:preview-deploy` | Opens a Preview for the phone and laptop, checks the link from outside, runs the click-test checklist | `.ui-workflow/preview.md` |

The skills commit only to the Work branch, `ui-workflow/<yyyy-mm-dd>`. They never push, merge or deploy to production; the workflow stops at an approved Preview.

What the skills hand each other: [docs/workflow-contract.md](docs/workflow-contract.md). Vocabulary: [GLOSSARY.md](GLOSSARY.md). Decisions: [docs/adr/](docs/adr/).

## Status

No Scenario has passed a real end-to-end run. Behavioural evals cover the skills on small fixtures ([evals/README.md](evals/README.md)), but:

- No real Lovable or Google AI Studio export has gone through the workflow. The Port rules were tried on one Screen of a Google Stitch export ([note](docs/research/2026-10-31-stitch-source-only-port-spike.md)) and on fixtures.
- The eval sandbox cannot open local ports or install real frameworks, so it does not reach a Screen viewed in the running app, a real framework build, or a live tunnel or Vercel link.

Scenario C becomes Production once its pilot passes; Scenarios A and B stay Beta (ADR-0001). The first pilot covered only the early steps of v0.1.0: [docs/pilots/2026-05-21-retrospective.md](docs/pilots/2026-05-21-retrospective.md).

## Repository layout

```
.claude-plugin/    plugin.json (the single source of the version), marketplace.json, icon.png
skills/            the 8 skills; design-brief/templates/ holds the prompt templates
docs/              Stakeholder guides, workflow contract, ADRs, pilots, research
evals/             behavioural evals for `claude plugin eval`
scripts/           static validator and its tests
GLOSSARY.md        domain vocabulary
CHANGELOG.md       version history
```

## Contributing

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

To release:

1. Bump `version` in `.claude-plugin/plugin.json` and add an entry with the same number at the top of `CHANGELOG.md`. CI fails if they differ.
2. Commit and tag: `git tag -a v<version> -m "v<version>"`, then `git push --tags`.

## License

MIT. See [LICENSE](LICENSE).
