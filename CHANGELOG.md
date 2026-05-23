# Changelog

All notable changes to this skill bundle are documented here. Format loosely follows [Keep a Changelog](https://keepachangelog.com/).

## [0.1.1] — 2026-05-21

### Pilot test
Ran the early skills (`ui-scenario-picker`, `ui-audit`, `design-brief` template inspection) against a real Vanilla JS + FastAPI repo. 12 friction points found and addressed below. See `PILOT_RETROSPECTIVE.md` for full details.

### Changed — `ui-scenario-picker`
- Added **"I don't know" fallback** for Q2 — teaches the trade-off, then re-asks; defaults to C on second uncertainty.
- Added **partial-migration detection** — if both framework code AND vanilla code exist, escalate to dev before answering.
- Documented `package.json`-missing fallback (file-extension scan).

### Changed — `ui-audit`
- Added **SPA mode** — for single-page apps, list tabs/views as "pages" alongside backend routes.
- **Split file-size tiering**: `> 1000 lines` = High; `500-1000` = Medium; `< 500` = healthy. Previously a flat 500-line threshold.
- Replaced the **loading-state ratio heuristic** with a "spot-check 3 random fetches" rule (ratios were unreliable).
- Added **"tokens-exist-but-unused" pain pattern** — flags projects with `:root` design tokens AND simultaneous color/style sprawl.
- Added **i18n-aware hardcoded-string detection** — checks for `data-i18n`, `t('...')`, etc. before flagging raw strings.

### Changed — `design-brief`
- **Substitution mechanism is now explicit** — instructs to `Read` placeholder templates and do literal string replace.
- Output is now written to **`LOVABLE_PROMPT.md` at project root** instead of inline in chat — non-tech users find files easier to copy from.
- Added **lazy-answer probe** — offers 2-3 concrete examples when user says "idk", never accepts uncertainty twice on the same question.
- Added **Q9 "skip-list"** — asks which sections to leave alone (common: login, admin, settings).
- For scenario C with existing design tokens detected by audit, **the prompt now reuses them** instead of letting Lovable invent new colors.

### Changed — `templates/lovable-prompt-scenario-C.md`
- Added `{{existing-design-tokens}}` placeholder that `design-brief` populates from the audit's `:root` block.

### Generalized — `preview-deploy`
- Removed project-specific reference to `dashboard/static/`. Skill now instructs to look for `StaticFiles(directory=...)` in the FastAPI app, or ask the user.

---

## [0.1.0] — 2026-05-21

### Added — initial release
- 7 skills: `ui-scenario-picker`, `ui-audit`, `design-brief`, `integration-planner`, `integration-wire`, `ui-translator`, `preview-deploy`
- 5 prompt templates for Lovable / Google AI Studio (scenario A/B/C base + brand block + constraints block)
- Vietnamese boss-facing guide (`UI_IMPROVEMENT_GUIDE.md`) — no code, decision tree
- English dev README

### Design decisions
- **Three-scenario model**: A (greenfield), B (brownfield + stack migration), C (brownfield + keep stack). Default bias = C.
- **Scenario C lockdown**: scenario-C template explicitly forbids React/Vue/Svelte/JSX in 6+ places. Single biggest failure-mode prevention.
- **Diagnostic / Generative / Action separation**: `integration-planner` outputs `STOP` on any 🚨 blocker; all action skills refuse to bypass.
- **Vercel-first** for preview deploys (free tier), MCP-preferred with CLI fallback.
