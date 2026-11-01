#!/bin/bash
set -euo pipefail
fixtures="$(cd "$(dirname "$0")/../fixtures" && pwd)"
cp -R "$fixtures/static-vite/." .

# The stand-in CLI sits outside the project, where the run would not read it, and goes first on PATH through the shell's startup files.
bin="$(dirname "$PWD")/.eval-bin"
mkdir -p "$bin"
cp "$fixtures/vercel-stub" "$bin/vercel"
chmod +x "$bin/vercel"
for rc in .zshenv .zshrc .bashrc .bash_profile .profile; do
  printf 'export PATH="%s:$PATH" VERCEL_STUB_LOG="%s"\n' "$bin" "$PWD/.vercel-calls" >> "$(dirname "$PWD")/$rc"
done

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
