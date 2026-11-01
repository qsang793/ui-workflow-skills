---
type: regex
target:
  source: file
  path: app/templates/index.html
pattern: 'fetch\(\s*["`'']/api/reminders'
match: contains
---
