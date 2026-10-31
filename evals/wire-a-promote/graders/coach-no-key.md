---
type: regex
target:
  source: file
  path: src/pages/Coach.tsx
pattern: 'VITE_OPENAI_API_KEY|sk-evalfakekey|api\.openai\.com'
match: not_contains
---
