#!/bin/bash
set -euo pipefail
bash "$(dirname "$0")/../fixtures/stage-wire-b.sh" session
# An earlier turn placed and wired the new frontend, built it and reported to the Stakeholder.
git switch -q -c ui-workflow/2026-10-28
perl -pi -e 's/^- Work branch: none$/- Work branch: ui-workflow\/2026-10-28/; s/^- Updated: .*/- Updated: 2026-10-28 by integration-wire/' .ui-workflow/state.md
grep -q 'Work branch: ui-workflow/2026-10-28' .ui-workflow/state.md
mkdir frontend-new
cp -R .ui-workflow/export/. frontend-new/
rm frontend-new/src/mock.ts
mkdir frontend-new/src/lib
cat > frontend-new/src/lib/api.ts <<'TS'
export async function listReminders() {
  const res = await fetch("/api/reminders", { credentials: "include" });
  const raw: { id: number; title: string; due: string; done: boolean }[] = await res.json();
  return raw.map((r) => ({ id: r.id, name: r.title, dueDate: r.due, isDone: r.done }));
}
TS
printf 'node_modules/\ndist/\n.env*\n!.env.example\n' > frontend-new/.gitignore
cat > .ui-workflow/wiring.md <<'WIRING'
# Wiring

- Frontend folder: frontend-new
- Build command: npm run build
- Build: passed
- Run: npm run dev → http://localhost:5173
- Public env vars: none
- Updated: 2026-10-28 by integration-wire
WIRING
