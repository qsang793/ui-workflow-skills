---
type: regex
target:
  source: file
  path: .git/logs/HEAD
# Only the scaffold's commits may exist. Read from the reflog, since tool_used misses a git command after a long heredoc in one Bash call.
pattern: '\tcommit(?! \(initial\)): (?!Notes\n)'
match: not_contains
---
