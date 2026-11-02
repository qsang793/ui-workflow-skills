---
type: regex
target:
  source: file
  path: .ui-workflow/state.md
# A withdrawal by the Stakeholder never clears a reason a Developer must decide.
pattern: 'Blocked:[^\n]*staging link fails'
match: contains
---
