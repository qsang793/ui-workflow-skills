---
type: tool_used
tool: Bash
# Without Vercel the skill stops and asks for a login; it never falls back to a tunnel on its own.
input_match: '\bcloudflared\s+tunnel\b|\bssh\s+[^\n"]*-R\b'
min: 0
max: 0
arm: both
---
