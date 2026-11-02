---
type: regex
target:
  source: file
  path: .ui-workflow/audit.md
# the command only CI runs
pattern: '-\s*Checks:[^\n]*css_budget'
match: contains
---
