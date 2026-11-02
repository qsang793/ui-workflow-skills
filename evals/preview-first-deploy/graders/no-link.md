---
type: regex
target:
  source: file
  path: .ui-workflow/preview.md
# Stopped, so the file records no link for the Stakeholder.
pattern: 'URL:\W*https?://'
match: not_contains
---
