#!/bin/bash
set -euo pipefail
cp -R "$(dirname "$0")/../fixtures/fastapi-vanilla/." .
mkdir -p .ui-workflow
cat > .ui-workflow/state.md <<'STATE'
# UI Workflow state

- Scenario: C
- Scenario reason: FastAPI serves a Jinja template with vanilla JS; the Stakeholder wants to keep the stack.
- Maturity: Beta
- Design tool: Lovable
- Current step: preview
- Completed steps: picker, audit, brief, ingest, planner, port
- Work branch: ui-workflow/2026-10-27
- Stakeholder language: English
- Blocked: none
- Updated: 2026-10-27 by design-port
STATE
cat > .ui-workflow/audit.md <<'AUDIT'
# UI Audit — reminders (2026-10-27)

## Stack
- Framework: FastAPI + Jinja2 templates, vanilla JS
- CSS: one stylesheet, app/static/styles.css
- Design tokens: app/static/styles.css
- Run: uvicorn app.main:app --port 8000 → http://127.0.0.1:8000

## Pages / Routes
- Today, All reminders, Settings (tabs) — app/templates/index.html

## Pain points
### 🔴 High
- none
### 🟡 Medium
- none
### 🟢 Low
- none

## Recommendation
Keep Scenario C.
AUDIT
