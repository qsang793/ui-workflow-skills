# Changelog

All notable changes to this skill bundle are documented here. Format loosely follows [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

### Changed — tool-neutral names and `.ui-workflow/` folder
- `ingest-lovable-export` → `ingest-design-export`, `ui-translator` → `design-port`. No aliases.
- Intermediate files move from the project root into `.ui-workflow/`: `UI_AUDIT.md` → `audit.md`, `LOVABLE_PROMPT.md` → `design-prompt.md`, `INTEGRATION_PLAN.md` → `integration-plan.md`, `lovable-export/` → `export/`.
- `ingest-design-export` adds `.ui-workflow/export*/` to the project's `.gitignore`; the rest of `.ui-workflow/` stays committable.
- `scripts/validate.py` rejects the old names outside the changelog, retrospectives and "Migrating from 0.x" sections.

### Added — Workflow state and behavioural evals
- `.ui-workflow/state.md` records Scenario, Design tool, current step, completed steps, Work branch, Stakeholder language and any Blocker. `ui-scenario-picker` writes it; every skill reads it first and names the missing step and its command instead of guessing. Contract, step order per Scenario and handoff formats: `docs/workflow-contract.md`.
- Every skill replies in the Stakeholder's language. The picker labels every Scenario Beta; Scenario C becomes Production once its end-to-end pilot passes.
- Behavioural evals for `claude plugin eval` under `evals/`, with a FastAPI + vanilla JS fixture and a mixed framework/vanilla fixture. Run locally or via the manual `evals` workflow. Local run 2026-10-27: 5 cases × 3 runs, every run scored 1.0 (`evals/results/2026-10-27T09-39-42-094Z/`).

### Changed — `ingest-design-export` takes any framework under Scenario C
- Under Scenario C the Design export is a visual reference in any framework (ADR-0004). Ingest reports the framework and the Screens the export renders (routes, pages, conditional views; not file names), asks when it cannot tell, and stops with a mismatch only when no Screen exists.
- Asks for one optional screenshot per Screen, saved to `.ui-workflow/export/screenshots/<Screen>.png`.
- ZIPs are checked entry by entry before extraction: an absolute, `..` or symlink entry rejects the whole ZIP. Nested `.git` is removed for every source, and the export is never installed, built or run.
- Evals `ingest-react-scenario-c`, `ingest-single-file-views`, `ingest-no-screen` and `ingest-traversal-zip`, with React and backend-only export fixtures. Not run yet.

## [0.2.0] — 2026-10-27

### Added — Claude Code plugin packaging
- `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json`. Install in one step with `/plugin install ui-workflow-skills --marketplace qsang793/ui-workflow-skills`. Plugin-installed skills are namespaced, e.g. `/ui-workflow-skills:design-brief`. The symlink install still works and keeps the short names.
- `plugin.json` is now the single source of the version number.

### Added — CI
- `scripts/validate.py` checks skill frontmatter (name matches folder, description present and ≤ 1024 chars), bundled template paths, template placeholders, relative Markdown links, and that `plugin.json` version matches the latest CHANGELOG entry. Tests in `scripts/test_validate.py`.
- GitHub Actions workflow runs the tests, the validator, and `claude plugin validate ./ --strict` on every push to `main` and every PR.

### Fixed — `design-brief` could not find its templates after install
Templates lived at the repo root (`templates/`), but install only symlinked `skills/*`, so `design-brief` looked for `templates/...` inside the user's project. Moved to `skills/design-brief/templates/` and referenced via `${CLAUDE_SKILL_DIR}`. Each skill folder is now self-contained.

### Fixed — `{{existing-design-tokens}}` placeholder was never filled
The scenario-C template had the placeholder, but `design-brief` only said to "append" a section. Projects without tokens got the raw placeholder in their prompt. The skill now replaces it, or deletes it when there are no tokens.

### Changed — README
- Plugin install documented as the default. Clone URL fixed (was `<your-username>`). Release steps documented.

---

## [0.1.4] — 2026-05-24

### Fixed — install verify regex missed the new skill
README install script used `grep -E '^(ui-|design-|integration-|preview-)'` to confirm symlinks landed. This regex was written for v0.1.1 (7 skills) and never updated when `ingest-lovable-export` was added in v0.1.2. A user following the install commands would see 7 results instead of 8 and reasonably conclude the install failed. Regex now includes `ingest-`.

### Fixed — LICENSE copyright holder
v0.1.1 commit was authored by `qsang793` (the repo owner) but the `LICENSE` file accidentally listed `koliaphan` (the local git config name at the time the LICENSE was first written, before the per-repo author config was set). Corrected to `qsang793`.

---

## [0.1.3] — 2026-05-23

### Renamed — templates (drop `lovable-` prefix)
Templates are not Lovable-specific. They work in both Lovable and Google AI Studio, and the prefix was misleading:
- `lovable-prompt-scenario-A.md` → `prompt-scenario-A.md`
- `lovable-prompt-scenario-B.md` → `prompt-scenario-B.md`
- `lovable-prompt-scenario-C.md` → `prompt-scenario-C.md`
- `lovable-brand-block.md` → `brand-block.md`
- `lovable-constraints-block.md` → `constraints-block.md`

Placeholder names updated to match: `{{lovable-brand-block}}` → `{{brand-block}}`, `{{lovable-constraints-block}}` → `{{constraints-block}}`. `design-brief` skill updated to use the new paths and placeholder names.

### Added — tool selection matrix (Lovable vs Google AI Studio)
- `UI_IMPROVEMENT_GUIDE.md` (Bước 3): added "Chọn tool nào?" table + per-tool post-iteration instructions (Lovable: download ZIP / GitHub sync; AI Studio: copy from chat).
- `CHEAT_SHEET.md`: added compact tool-pick block before the 4-cách table.
- `design-brief/SKILL.md`: new step 1b — asks user which tool they'll use, then tailors the step 4 output instructions accordingly. Recommends AI Studio for scenario C, Lovable for A/B.

### Changed — `ingest-lovable-export`
- Description softened to clarify it handles **both** Lovable (ZIP / GitHub) and Google AI Studio (paste) outputs. Skill name kept as `ingest-lovable-export` for stability — not renamed (would have broken existing references).
- Step 1 prompt now annotates each option with the tool that typically produces it.

### Why
The user pointed out that the templates were Lovable-biased (prefix `lovable-`, deliverable sections referencing "Lovable" specifically). For scenario C — where the output must be HTML+CSS only — Google AI Studio is actually a better fit than Lovable. This release removes the bias and gives non-tech users clear tool guidance.

---

## [0.1.2] — 2026-05-23

### Added — `ingest-lovable-export` skill
New skill that bridges the gap between Lovable export and `integration-planner`. Accepts a ZIP path, GitHub URL, an unzipped folder, or pasted-in code; stages everything to the conventional location `lovable-export/` at project root; validates the content against the chosen scenario (e.g. scenario C must be HTML+CSS, not React) and fails loudly on mismatch.

### Changed — `integration-planner`
- Hard-pinned expected input location to `lovable-export/`. Skill now refuses to search alternates.
- Added explicit precondition block: if `lovable-export/` is missing, output a single message telling the user to run `/ingest-lovable-export` first.

### Changed — `UI_IMPROVEMENT_GUIDE.md` (boss guide)
- Renumbered the 7-step flow to 8 steps. New "Bước 4 — Mang code Lovable về project" inserted between Lovable iteration and integration-planner.
- Updated the quick-reference command table to include `/ingest-lovable-export`.

### Changed — `CHEAT_SHEET.md`
- Bumped flow from "7 lệnh" to "8 lệnh", inserted `/ingest-lovable-export` between Lovable and `/integration-planner`.
- Added section "📥 Bước 5 — 4 cách bỏ code Lovable vào project" with the ZIP / GitHub / Folder / Paste cheat table.
- Added one more troubleshooting row: "Đã tải code Lovable, không biết để đâu → `/ingest-lovable-export`".

### Why
v0.1.1 had a quiet gap: after step 4 (user iterates in Lovable), users were expected to "just have" the export at the right place before invoking `/integration-planner`. Non-tech users would have had to open a terminal and unzip manually. v0.1.2 makes the staging an explicit, claude-driven skill.

---

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
