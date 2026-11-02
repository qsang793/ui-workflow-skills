---
type: regex
target:
  source: file
  path: .ui-workflow/audit.md
# package.json `test`
pattern: '-\s*Checks:[^\n]*npm\s+(run\s+)?test\b(?!:)'
match: contains
---
