---
type: tool_used
tool: Bash
# Neither the export nor the app gets packages installed to make it run; a failing app is escalated.
input_match: '\b(npm|pnpm|yarn|bun)\s+(install|i|ci|add|run|dev|build|start)\b|\bnpx\s+vite\b|\bpip3?\s+install\b|\buv\s+(pip|add|sync)\b|\bpoetry\s+install\b'
min: 0
max: 0
arm: both
---
