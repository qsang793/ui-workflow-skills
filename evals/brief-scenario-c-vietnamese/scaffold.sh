#!/bin/bash
set -euo pipefail
cp -R "$(dirname "$0")/../fixtures/fastapi-vanilla/." .
mkdir -p .ui-workflow
cat > .ui-workflow/state.md <<'STATE'
# UI Workflow state

- Scenario: C
- Scenario reason: FastAPI serves a Jinja template with vanilla JS; the Stakeholder wants to keep the stack.
- Maturity: Beta
- Design tool: none
- Current step: brief
- Completed steps: picker, audit
- Work branch: none
- Stakeholder language: Vietnamese
- Blocked: none
- Updated: 2026-10-27 by ui-audit
STATE
cat > .ui-workflow/audit.md <<'AUDIT'
# UI Audit — Reminders (2026-10-27)

## Stack
- Framework: FastAPI + Jinja2 templates, vanilla JavaScript
- CSS: plain CSS in app/static/styles.css, plus inline styles
- Design tokens: app/static/styles.css
- Run: uvicorn app.main:app --reload → http://127.0.0.1:8000

## Pages / Routes
- Today (tab view of /) — app/templates/index.html#today
- All reminders (tab view of /) — app/templates/index.html#all
- Settings (tab view of /) — app/templates/index.html#settings

## Pain points
### 🔴 High
- Fixed 800px width; the page scrolls sideways on phones.
- Tokens exist in :root but colours are hard-coded inline instead.
### 🟡 Medium
- Tabs give no sign of which one is active.
- No empty state when there are no reminders.
### 🟢 Low
- Logo image has no alt text.

## Recommendation
Scenario C is right: the stack works, only the look is dated.
AUDIT
