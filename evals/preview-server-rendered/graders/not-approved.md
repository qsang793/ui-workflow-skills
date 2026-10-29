---
type: regex
target:
  source: file
  path: .ui-workflow/state.md
# Approval needs the Stakeholder's completed checklist, which a single turn cannot have.
pattern: 'Completed steps:[^\n]*\bpreview\b'
match: not_contains
---
