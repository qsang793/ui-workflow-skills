#!/bin/bash
set -euo pipefail
bash "$(dirname "$0")/../fixtures/stage-preview-return.sh"
# preview-deploy moved the run back, and an earlier turn made the change, which the Stakeholder has now viewed.
perl -0pi -e 's/Current step: preview/Current step: port/; s/(Completed steps: picker, audit, brief, ingest, planner), port/$1/; s/Updated: .*/Updated: 2026-10-28 by preview-deploy/' .ui-workflow/state.md
grep -q 'Current step: port$' .ui-workflow/state.md
grep -q 'Completed steps: picker, audit, brief, ingest, planner$' .ui-workflow/state.md
perl -pi -e 's/^- URL: .*/- URL: none/; s/^- Status: open$/- Status: closed/' .ui-workflow/preview.md
grep -q 'Status: closed' .ui-workflow/preview.md
printf '\n## Return to the Port\n- Today: the Done button is too small to hit with a thumb on a phone; make it bigger.\n' >> .ui-workflow/preview.md
perl -pi -e 's/border-radius: 8px; padding: 4px 12px; \}/border-radius: 8px; min-height: 44px; padding: 8px 16px; }/' app/static/styles.css
grep -q 'min-height: 44px' app/static/styles.css
