# Install

Tested with Claude Code 2.1.307, the version CI pins.

## Plugin (recommended)

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

## Symlink

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

## For the Preview step

`preview-deploy` picks the host from the project's shape and never installs these itself:

- A static frontend goes to a Vercel preview. Run `npm i -g vercel` and `vercel login` once, unless Claude already has a logged-in Vercel tool. Vercel also protects previews by default, so someone with access to the Vercel project creates a Shareable Link for each Preview; the Hobby plan allows one per account. A project that has never been deployed cannot get a preview: the skill stops and asks a Developer for one placeholder deployment first.
- A backend that renders the UI runs locally behind a temporary tunnel. Run `brew install cloudflared`; no account is needed.
