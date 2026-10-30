#!/bin/bash
set -euo pipefail
bash "$(dirname "$0")/../fixtures/stage-reminders-port.sh"
# An earlier turn created the Work branch and Ported Today, which the Stakeholder has now viewed.
git switch -q -c ui-workflow/2026-10-28
perl -pi -e 's/^- Work branch: none$/- Work branch: ui-workflow\/2026-10-28/; s/^- Updated: .*/- Updated: 2026-10-28 by design-port/' .ui-workflow/state.md
grep -q 'Work branch: ui-workflow/2026-10-28' .ui-workflow/state.md
grep -q 'Updated: 2026-10-28 by design-port' .ui-workflow/state.md
perl -pi -e 's{<body style="width: 800px; margin: 0 auto; background: #fafafa">}{<body class="app">}' app/templates/index.html
grep -q '<body class="app">' app/templates/index.html
cat >> app/static/styles.css <<'CSS'

/* Today */
.app { max-width: 36rem; margin: 0 auto; padding: 24px; background: #f8fafc; }
#today .reminder { align-items: center; background: #ffffff; border-radius: 12px; padding: 12px 16px; margin-bottom: 8px; box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05); }
#today .reminder button { background: var(--color-success); border-radius: 8px; padding: 4px 12px; }
CSS
