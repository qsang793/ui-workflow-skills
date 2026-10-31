---
type: regex
target:
  source: file
  path: frontend-new/src/lib/api.ts
pattern: 'credentials:\s*["'']include["'']'
match: contains
---
