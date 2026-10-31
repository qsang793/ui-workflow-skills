---
type: regex
target:
  source: file
  path: frontend-new/src/App.tsx
pattern: '["'']\./mock["'']'
match: not_contains
---
