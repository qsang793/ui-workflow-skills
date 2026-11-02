#!/bin/bash
# Shared by the way-back and gap cases: every Screen committed on the Work branch, Workflow state at
# the preview step, and an open Preview on staging. Closing a tunnel needs ps and the network, which
# the eval sandbox refuses, so a tunnel run could never reach the state change these cases prove.
set -euo pipefail
bash "$(dirname "$0")/stage-reminders-port.sh"
git switch -q -c ui-workflow/2026-10-28

perl -pi -e 's{<body style="width: 800px; margin: 0 auto; background: #fafafa">}{<body class="app">}' app/templates/index.html
grep -q '<body class="app">' app/templates/index.html
cat >> app/static/styles.css <<'CSS'

/* Today */
.app { max-width: 36rem; margin: 0 auto; padding: 24px; background: #f8fafc; }
#today .reminder { align-items: center; background: #ffffff; border-radius: 12px; padding: 12px 16px; margin-bottom: 8px; }
#today .reminder button { background: var(--color-success); border-radius: 8px; padding: 4px 12px; }
CSS
git add -- app/templates/index.html app/static/styles.css .ui-workflow/state.md .ui-workflow/audit.md .ui-workflow/design-prompt.md .ui-workflow/integration-plan.md
git commit -qm "ui-workflow: port Today"

cat >> app/static/styles.css <<'CSS'

/* All reminders */
#all .reminder { align-items: center; padding: 12px 16px; }
CSS
git add -- app/static/styles.css
git commit -qm "ui-workflow: port All reminders"

perl -pi -e 's{(<div id="all" class="view" style="display: none"></div>)}{$1\n  <div id="done" class="view" style="display: none"></div>}; s{(<button data-tab="all" style="color: #444">All reminders</button>)}{$1\n    <button data-tab="done">Done</button>}' app/templates/index.html
grep -q 'id="done"' app/templates/index.html
grep -q 'data-tab="done"' app/templates/index.html
perl -0pi -e 's/Current step: port/Current step: preview/; s/(Completed steps: picker, audit, brief, ingest, planner)/$1, port/; s/Work branch: none/Work branch: ui-workflow\/2026-10-28/; s/Updated: .*/Updated: 2026-10-28 by design-port/' .ui-workflow/state.md
grep -q 'Current step: preview$' .ui-workflow/state.md
grep -q 'Completed steps: picker, audit, brief, ingest, planner, port$' .ui-workflow/state.md
grep -q 'Work branch: ui-workflow/2026-10-28$' .ui-workflow/state.md
grep -q 'Updated: 2026-10-28 by design-port$' .ui-workflow/state.md
git add -- app/templates/index.html .ui-workflow/state.md
git commit -qm "ui-workflow: port Done"

cat > .ui-workflow/preview.md <<'PREVIEW'
# Preview

- Host: staging
- Host reason: the Developer confirmed the project's staging environment is the place to show this branch.
- Run: none
- Released site: none
- URL: https://staging.reminders.example
- Processes: none
- Status: open
- Updated: 2026-10-28 by preview-deploy
PREVIEW
