"""The reminders app on the standard library: the eval sandbox refuses local ports, but a kept run starts by hand with no install."""
import json
import mimetypes
import re
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

ROOT = Path(__file__).parent

REMINDERS = [
    {"id": 1, "title": "Pay rent", "due": "2026-11-01", "done": False},
    {"id": 2, "title": "Call dentist", "due": "2026-11-03", "done": True},
]


class Handler(BaseHTTPRequestHandler):
    def send(self, body, content_type, status=200):
        self.send_response(status)
        self.send_header("Content-Type", content_type)
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        if self.path == "/":
            page = (ROOT / "templates/index.html").read_text(encoding="utf-8")
            self.send(page.replace("{{ owner }}", "Lan").encode(), "text/html; charset=utf-8")
        elif self.path == "/api/reminders":
            self.send(json.dumps(REMINDERS).encode(), "application/json")
        elif self.path.startswith("/static/") and ".." not in self.path:
            file = ROOT / self.path.lstrip("/")
            if file.is_file():
                self.send(file.read_bytes(), mimetypes.guess_type(file.name)[0] or "application/octet-stream")
            else:
                self.send(b"not found", "text/plain", 404)
        else:
            self.send(b"not found", "text/plain", 404)

    def do_POST(self):
        match = re.fullmatch(r"/api/reminders/(\d+)/done", self.path)
        if not match:
            self.send(b"not found", "text/plain", 404)
            return
        for r in REMINDERS:
            if r["id"] == int(match.group(1)):
                r["done"] = True
        self.send(b'{"ok": true}', "application/json")


if __name__ == "__main__":
    ThreadingHTTPServer(("127.0.0.1", 8000), Handler).serve_forever()
