---
type: regex
target:
  source: file
  path: .ui-workflow/audit.md
pattern: '-\s*Checks:[^\n]*(uvicorn|run\s+dev|run\s+deploy|scp)'
match: not_contains
---
