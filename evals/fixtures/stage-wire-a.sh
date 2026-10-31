#!/bin/bash
# Shared by the Scenario A wire cases: an empty git repo, the Design export staged,
# Workflow state at the wire step. Takes the export fixture name.
set -euo pipefail
fixtures="$(dirname "$0")"
mkdir -p .ui-workflow/export
cp -R "$fixtures/$1/." .ui-workflow/export/
printf '.ui-workflow/export*/\n' > .gitignore
cat > .ui-workflow/design-prompt.md <<'PROMPT'
=== COPY EVERYTHING BELOW INTO Lovable ===
A habit tracker with a Today page and a Coach page.
=== END COPY ===
PROMPT
cat > .ui-workflow/state.md <<'STATE'
# UI Workflow state

- Scenario: A
- Scenario reason: The folder holds no code; the Stakeholder is starting a new habit tracker.
- Maturity: Beta
- Design tool: Lovable
- Current step: wire
- Completed steps: picker, brief, ingest
- Work branch: none
- Stakeholder language: English
- Blocked: none
- Updated: 2026-10-28 by ingest-design-export
STATE
git init -q -b main
git config user.email eval@example.com
git config user.name eval
# Graders read .git/logs/HEAD, which only exists after a first commit.
git commit -q --allow-empty -m "Empty repo"
