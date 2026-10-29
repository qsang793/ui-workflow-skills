#!/bin/bash
set -euo pipefail
bash "$(dirname "$0")/../fixtures/stage-reminders-design.sh"
# The design shows a priority the backend does not store.
perl -0pi -e 's/done: boolean \};/done: boolean; priority: "high" | "normal" };/; s/done: (true|false) \},/done: $1, priority: "high" },/g; s{(<p className="text-sm text-slate-500">Due \{r\.due\}</p>)}{$1\n        <span className="rounded bg-amber-100 px-2 text-xs text-amber-800">{r.priority} priority</span>}' .ui-workflow/export/src/App.tsx
grep -q 'priority' .ui-workflow/export/src/App.tsx  # fail loudly if the patch did not apply
