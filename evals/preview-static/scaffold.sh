#!/bin/bash
set -euo pipefail
cp -R "$(dirname "$0")/../fixtures/static-vite/." .
mkdir -p .ui-workflow
cat > .ui-workflow/state.md <<'STATE'
# UI Workflow state

- Scenario: A
- Scenario reason: The Stakeholder is starting a new frontend from scratch against an existing public API.
- Maturity: Beta
- Design tool: Lovable
- Current step: preview
- Completed steps: picker, brief, ingest, wire
- Work branch: ui-workflow/2026-10-27
- Stakeholder language: English
- Blocked: none
- Updated: 2026-10-27 by integration-wire
STATE
