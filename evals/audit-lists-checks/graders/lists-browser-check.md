---
type: regex
target:
  source: file
  path: .ui-workflow/audit.md
# package.json `test:browser`, a name that may look like it needs a browser
pattern: '-\s*Checks:[^\n]*test:browser'
match: contains
---
