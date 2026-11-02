---
type: regex
target:
  source: file
  path: .ui-workflow/audit.md
# The fixture has no tests, scripts or CI, and the audit says so instead of leaving the line out.
pattern: '-\s*Checks:\W*none'
match: contains
---
