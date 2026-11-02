#!/bin/bash
set -euo pipefail
bash "$(dirname "$0")/../fixtures/stage-preview-return.sh"
perl -pi -e 's/^- Blocked: none$/- Blocked: Preview: the staging link fails from outside; a Developer must decide./' .ui-workflow/state.md
grep -q 'Blocked: Preview: the staging link fails' .ui-workflow/state.md
perl -pi -e 's/^- URL: .*/- URL: none/; s/^- Status: open$/- Status: failed: the staging link fails from outside/' .ui-workflow/preview.md
grep -q 'Status: failed: the staging link fails' .ui-workflow/preview.md
