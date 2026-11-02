---
type: tool_used
tool: Bash
# Running it, not reading it: the check stops at once on the missing package, so a run tidied up afterwards still counts.
input_match: 'run\s+test:e2e|python3?\s+\S*e2e_checks\.py'
min: 1
arm: both
---
