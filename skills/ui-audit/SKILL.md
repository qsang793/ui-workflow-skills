---
name: ui-audit
description: Use after ui-scenario-picker selects scenario B or C — on existing FE codebases that need improvement. Maps the stack, lists pages/routes, surfaces concrete pain points (responsive issues, missing accessibility, oversized files, color sprawl). Skip for greenfield (scenario A) — there is nothing to audit.
---

# UI Audit

## Overview

Turn vague "the UI looks bad" into a one-page report with: stack used, pages/routes, style approach, and prioritized pain points. Output drives the next skill (`design-brief`).

## When to Use

- Right after `ui-scenario-picker` returns scenario B or C
- Before generating any design brief — the brief must be informed by what exists

## When NOT to Use

- Scenario A (nothing to audit)
- Pure backend changes

## Process

Reply in the language of the Stakeholder's latest message; if unclear, use `Stakeholder language` from the Workflow state. Write the report's prose in that language but keep the headings below in English, because later skills read them.

### 0. Read the Workflow state

Read `.ui-workflow/state.md` at the project root before anything else. Stop with a short message, without auditing, when:

- The file is missing: say the Scenario has not been picked yet and give the command `/ui-workflow-skills:ui-scenario-picker`.
- `Blocked` is not `none` and `Current step` is another step: repeat the reason and say a Developer must decide first. Re-running the step that stopped is allowed.
- `Scenario` is `A`: say there is no frontend to audit, so this step is skipped by design, and give the command for the recorded `Current step`.
- `Completed steps` does not include `picker`: name the picker step and its command.

### 1. Detect the stack

Read in this order:
- `package.json` — look for `react`, `next`, `vue`, `svelte`, `jquery`, `htmx` in deps
- `requirements.txt`, `Pipfile`, `pyproject.toml` — is BE serving templates (Jinja/EJS/Handlebars)?
- File extensions across the repo: `.tsx`, `.jsx`, `.vue`, `.svelte`, `.html`, `.ejs`, `.hbs`
- Build config: `vite.config.*`, `next.config.*`, `webpack.config.*`, or none (raw HTML)
- CSS approach: Tailwind config present? CSS modules? SCSS? Bootstrap? Plain CSS?

### 2. Map the structure

- Find route/page definitions:
  - Next.js: `app/` or `pages/`
  - React Router: `<Route>` components
  - Flask: `@app.route`
  - FastAPI: `@router.get/post/...`
  - Django: `urls.py`
- List the **top 10** user-facing pages (filename + path).
- **SPA mode**: if the project is a single-page app (one `index.html` + JS tabs/views switched client-side), list the **tabs/views** as "pages" — they're what the user perceives. Read the SPA entry file (e.g. `app.js`) to find the tab list.
- Count components in the FE dir, then tier by line count:
  - **🔴 High**: any file > **1000 lines** (urgent split)
  - **🟡 Medium**: any file **500-1000 lines** (split when convenient)
  - Files < 500 lines are healthy.
- Identify state management: Redux, Zustand, Context, Pinia, native, none.

### 3. Spot pain points (specific greps)

| Pain | How to detect |
|---|---|
| Not responsive | grep `width: \d+px`, missing `<meta viewport>`, low media-query count |
| Inaccessible images | grep `<img` without `alt=` |
| Missing ARIA / semantics | low count of `aria-` (e.g. < 1 per 10 `<button>`), missing `<header>`, `<nav>`, `<main>` |
| No loading state | **Spot-check**: pick 3 random `fetch(` / `axios.` calls; for each, confirm a visible loading UI exists (spinner, skeleton, disabled button). Heuristic ratios are unreliable. |
| Inline style sprawl | grep `style=` — > 50 occurrences = inconsistent |
| Color sprawl | unique hex/rgb colors > 20 = no design system |
| **Tokens-exist-but-unused** | If `:root { --color-...: }` block exists AND `style=` / hex count is high → tokens drift. Report this specifically — it's the highest-leverage redesign action. |
| Oversized files | see tiering in step 2 (> 1000 = High, 500-1000 = Medium) |
| Hardcoded text (no i18n) | **First check** for `data-i18n=`, `t('...')`, `useTranslation`, or similar markers. **If present, skip this pain** — it would be a false positive. If absent, then grep for raw strings in HTML. |

### 4. Write the report

Single markdown file: `.ui-workflow/audit.md` (create the `.ui-workflow/` folder at the project root if missing).

Cap at **5 items per severity tier**. More than that = the report is too long for a non-tech stakeholder to act on. A tier with nothing in it has the single bullet `- none`.

### 5. Update the Workflow state

In `.ui-workflow/state.md`: append `audit` to `Completed steps`, set `Current step: brief`, `Blocked: none` and `Updated: <YYYY-MM-DD> by ui-audit`, and update `Stakeholder language` if the Stakeholder switched language. Leave the other fields as they are. Then tell the Stakeholder the top High items in a few lines, where the report is, and the next command, `/ui-workflow-skills:design-brief`.

## Output Format

```markdown
# UI Audit — <project name> (<YYYY-MM-DD>)

## Stack
- Framework: <e.g. Vanilla JS + FastAPI Jinja templates>
- Build tool: <none / vite / next / etc.>
- CSS: <e.g. plain CSS in src/styles.css, or Tailwind, or CSS modules>
- State: <e.g. Redux / global window vars / none>
- Design tokens: <file holding the `:root { --... }` block | none>

## Pages / Routes (top 10)
- `/` — `<path-to-entry-template>`
- `/api/<route>` — `<path-to-route-file>`
- …

## Style approach
<2–3 sentences describing how styling currently works>

## Pain points

### 🔴 High
- <e.g. No responsive breakpoints — fixed 800px width breaks on mobile>
- <e.g. 47 unique color hex codes, no design tokens>

### 🟡 Medium
- <e.g. 12 fetch() calls without matching loading state>

### 🟢 Low
- <e.g. Inconsistent button padding>

## Recommendation
<One sentence: scenario B or C? Confirm or revise picker's earlier choice.>
```

## Common Mistakes

- **Listing every problem.** Cap at 5 per tier. Prioritize ruthlessly — non-tech users can't act on a 30-item list.
- **Recommending a full rewrite when 3 days of polish would fix it.** Bias toward C unless something genuinely blocks it.
- **Auditing files that aren't user-facing.** Skip admin scripts, cron jobs, migrations — they don't have UI.
- **Detecting only one framework when multiple coexist.** Some repos have legacy jQuery + new React side-by-side. Report both.

## Related Skills

- `ui-scenario-picker` — must run first
- `design-brief` — runs after, uses this report as input
