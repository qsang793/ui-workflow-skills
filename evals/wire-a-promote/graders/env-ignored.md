---
type: regex
target:
  source: file
  path: .gitignore
pattern: '(^|\n)/?\.env\*?\s*(\n|$)'
match: contains
---
