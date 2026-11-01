---
type: regex
target:
  source: file
  path: app/templates/index.html
pattern: '(px-\d|py-\d|bg-paper|bg-stamp|text-ink|space-y-\d|max-w-3xl)'
match: not_contains
---
