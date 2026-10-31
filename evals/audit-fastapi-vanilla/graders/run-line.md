---
type: regex
target:
  source: file
  path: .ui-workflow/audit.md
# The command is read from the files (uvicorn in requirements.txt, app/main.py), never run.
pattern: '-\s*Run:[^\n]*\buvicorn\b'
match: contains
---
