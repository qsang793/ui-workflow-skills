---
type: regex
# The config sets rounded-full to 0.75rem, so the buttons are not pills.
target:
  source: file
  path: app/static/styles.css
pattern: 'border-radius:\s*(999|9999)px'
match: not_contains
---
