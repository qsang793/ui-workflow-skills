from fastapi import FastAPI, Request
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

app = FastAPI()
app.mount("/static", StaticFiles(directory="app/static"), name="static")
templates = Jinja2Templates(directory="app/templates")

REMINDERS = [
    {"id": 1, "title": "Pay rent", "due": "2026-11-01", "done": False},
    {"id": 2, "title": "Call dentist", "due": "2026-11-03", "done": True},
]


@app.get("/")
def index(request: Request):
    return templates.TemplateResponse(request, "index.html", {"owner": "Lan"})


@app.get("/api/reminders")
def list_reminders():
    return REMINDERS


@app.post("/api/reminders/{reminder_id}/done")
def mark_done(reminder_id: int):
    for r in REMINDERS:
        if r["id"] == reminder_id:
            r["done"] = True
    return {"ok": True}
