#!/bin/bash
# Shared by the Vercel Preview cases: the static fixture at the preview step, with stand-in `vercel` and `curl`.
# Arguments are exports for the stand-ins, such as VERCEL_STUB_DEPLOYED=1.
set -euo pipefail
fixtures="$(cd "$(dirname "$0")" && pwd)"
cp -R "$fixtures/static-vite/." .

# The stand-ins sit outside the project, where the run would not read them, and go first on PATH through the shell's startup files.
bin="$(dirname "$PWD")/.eval-bin"
mkdir -p "$bin"
cp "$fixtures/vercel-stub" "$bin/vercel"
cp "$fixtures/curl-stub" "$bin/curl"
chmod +x "$bin/vercel" "$bin/curl"
for rc in .zshenv .zshrc .bashrc .bash_profile .profile; do
  printf 'export PATH="%s:$PATH" VERCEL_STUB_LOG="%s" %s\n' "$bin" "$PWD/.vercel-calls" "$*" >> "$(dirname "$PWD")/$rc"
done

case " $* " in
  *" VERCEL_STUB_DEPLOYED=1 "*)
    mkdir .vercel
    echo '{"projectId":"prj_eval","orgId":"team_eval","projectName":"reminders-web"}' > .vercel/project.json
    ;;
esac

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
