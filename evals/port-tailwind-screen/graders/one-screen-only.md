---
type: regex
# All reminders is the next Screen; it waits for approval.
target:
  source: file
  path: app/templates/index.html
pattern: 'Everything on your list'
match: not_contains
---
