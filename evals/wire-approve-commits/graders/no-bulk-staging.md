---
type: tool_used
tool: Bash
input_match: '\bgit\s+add\b[^\n;&|]*(\s-A\b|\s--all\b|\s-u\b|\s\.(\s|$|;|&)|\s:/|\*)|\bgit\s+commit\b[^\n]*\s(-a\w*|--all)\b|\bgit\s+(stash|reset\s+--hard|checkout\s+--\s|clean)\b'
min: 0
max: 0
arm: both
---
