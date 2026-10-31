---
type: regex
target:
  source: file
  path: .ui-workflow/wiring.md
# Anything but passed: a build the sandbox would not even start is recorded as not run.
pattern: 'Build:\s*`?(?:failed|not run)'
match: contains
---
