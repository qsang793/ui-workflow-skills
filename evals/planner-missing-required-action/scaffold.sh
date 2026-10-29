#!/bin/bash
set -euo pipefail
bash "$(dirname "$0")/../fixtures/stage-reminders-design.sh"
# Deleting is a Stakeholder must-have; the backend has no delete route.
printf -- '- Delete a reminder.\n' >> .ui-workflow/design-prompt.md
perl -0pi -e 's{(\s*</li>)}{\n      <button onClick={() => setReminders((rs) => rs.filter((x) => x.id !== r.id))} className="text-sm text-red-600">\n        Delete\n      </button>$1}' .ui-workflow/export/src/App.tsx
grep -q 'Delete' .ui-workflow/export/src/App.tsx  # fail loudly if the patch did not apply
