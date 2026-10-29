---
type: regex
target:
  source: file
  path: .ui-workflow/design-prompt.md
# The section sits after the copy block, so the Stakeholder never pastes it.
pattern: '=== END COPY ===[\s\S]*\n## Required behaviour[ \t]*\r?\n'
match: contains
---
