---
type: regex
target:
  source: file
  path: frontend-new/src/lib/api.ts
pattern: 'https?://(?:127\.0\.0\.1|localhost)'
match: not_contains
---
