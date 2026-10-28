---
type: regex
target:
  source: file
  path: .ui-workflow/audit.md
# Six bullets in a row under any ### heading (indented continuation lines allowed) means a tier went over the cap.
pattern: '### [^\n]*\n(?:[ \t]*\n)*(?:[ \t]*[-*] [^\n]*\n(?:[ \t]+(?![-*] )\S[^\n]*\n|[ \t]*\n)*){6}'
match: not_contains
---
