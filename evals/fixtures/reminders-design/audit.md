# UI Audit — reminders (2026-10-27)

## Stack
- Framework: FastAPI + Jinja2 templates, vanilla JS
- CSS: plain CSS (`app/static/styles.css`)
- Design tokens: app/static/styles.css
- Run: `uvicorn app.main:app --reload` → http://127.0.0.1:8000

## Pages / Routes
- Today (tab) — app/templates/index.html
- All reminders (tab) — app/templates/index.html
- Settings (tab) — app/templates/index.html

## Pain points
### 🔴 High
- Hard-coded colours and inline styles bypass the tokens
### 🟡 Medium
- Fixed 800px width breaks on phones
### 🟢 Low
- none

## Recommendation
Scenario C confirmed: restyle the existing templates.
