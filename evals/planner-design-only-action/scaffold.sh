#!/bin/bash
set -euo pipefail
bash "$(dirname "$0")/../fixtures/stage-reminders-design.sh"
# An "Email me" button that only the design has; nothing in the backend sends email.
perl -0pi -e 's{(\s*</li>)}{\n      <button onClick={() => alert("We will email you before " + r.due)} className="text-sm text-slate-500">\n        Email me\n      </button>$1}' .ui-workflow/export/src/App.tsx
grep -q 'Email me' .ui-workflow/export/src/App.tsx  # fail loudly if the patch did not apply
