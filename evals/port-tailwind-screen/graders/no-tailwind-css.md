---
type: regex
target:
  source: file
  path: app/static/styles.css
pattern: '@tailwind|@apply'
match: not_contains
---
