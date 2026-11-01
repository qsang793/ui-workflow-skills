---
type: tool_used
tool: Bash
# The eval sandbox refuses local ports, so this checks the attempt; the reply then escalates.
input_match: 'python3?\s+(-\w+\s+)*\S*main\.py'
min: 1
arm: both
---
