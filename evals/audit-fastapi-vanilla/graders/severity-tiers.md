---
type: regex
target:
  source: file
  path: .ui-workflow/audit.md
pattern: '### 🔴[\s\S]*### 🟡[\s\S]*### 🟢'
match: contains
---
