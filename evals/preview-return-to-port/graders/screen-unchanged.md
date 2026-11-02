---
type: regex
target:
  source: file
  path: app/static/styles.css
# The change belongs to the Port step and its own approval.
pattern: '#today \.reminder button \{ background: var\(--color-success\); border-radius: 8px; padding: 4px 12px; \}'
match: contains
---
