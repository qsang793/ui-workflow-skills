#!/bin/bash
# Shared by the planner cases: the FastAPI reminders app with a single-file React Design export staged,
# Workflow state at the planner step of Scenario C.
set -euo pipefail
fixtures="$(dirname "$0")"
cp -R "$fixtures/fastapi-vanilla/." .
mkdir -p .ui-workflow
cp -R "$fixtures/reminders-design/." .ui-workflow/
cat > .ui-workflow/state.md <<'STATE'
# UI Workflow state

- Scenario: C
- Scenario reason: FastAPI serves a Jinja template with vanilla JS; the Stakeholder wants to keep the stack.
- Maturity: Beta
- Design tool: Lovable
- Current step: planner
- Completed steps: picker, audit, brief, ingest
- Work branch: none
- Stakeholder language: English
- Blocked: none
- Updated: 2026-10-27 by ingest-design-export
STATE
