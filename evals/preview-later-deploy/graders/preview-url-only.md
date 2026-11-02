---
type: regex
target:
  source: file
  path: .ui-workflow/preview.md
# The plain deployment URL opens a login page, so it is not a link for the Stakeholder.
pattern: 'URL:\W*https://reminders-web-abc123\.vercel\.app'
match: not_contains
---
