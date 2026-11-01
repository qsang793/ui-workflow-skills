---
type: regex
target:
  source: file
  path: app/templates/index.html
pattern: '(px-\d|py-\d|bg-accent|rounded-full|rounded-xl|text-ink|flex-col|space-y-\d|md:flex-row|max-w-\[)'
match: not_contains
---
