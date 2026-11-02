---
type: regex
target:
  source: file
  path: .ui-workflow/audit.md
# the Makefile target
pattern: '-\s*Checks:[^\n]*make\s+check-contrast'
match: contains
---
