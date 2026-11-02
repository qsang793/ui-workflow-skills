---
type: tool_used
tool: Bash
# Running the project's scripts is expected here; only installing is banned.
input_match: '\b(npm|pnpm|yarn|bun)\s+(install|i|ci|add)\b|\bpip3?\s+install\b|\bpython3?\s+-m\s+pip\s+install\b|\buv\s+(pip|add)\b|\bbrew\s+install\b'
min: 0
max: 0
arm: both
---
