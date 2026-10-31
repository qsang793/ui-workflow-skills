---
type: tool_used
tool: Edit
# file_exists only sees new files, so edits to the old frontend and backend are read from the tool calls. A shell edit would not show here.
input_match: '\bapp/(templates|static|main\.py)'
min: 0
max: 0
arm: both
---
