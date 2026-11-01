---
type: regex
target:
  source: file
  path: app/templates/index.html
pattern: '/api/reminders/\$\{[^}]+\}/done'
match: contains
---
