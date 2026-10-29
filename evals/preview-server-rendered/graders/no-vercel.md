---
type: tool_used
tool: Bash
# A server-rendered app never goes to Vercel, so the run must not even run or look for the Vercel CLI.
# Matches commands, not prose such as a Host reason written through a heredoc.
input_match: '\bvercel\s+(?:deploy|link|whoami|login|env|promote|--)|\bwhich\b[^\n"]*\bvercel\b'
min: 0
max: 0
arm: both
---
