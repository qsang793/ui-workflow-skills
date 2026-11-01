"""The project's browser-level check: the page keeps its approved markup."""
import sys
from pathlib import Path

ROOT = Path(__file__).parent.parent
page = (ROOT / "app/templates/index.html").read_text(encoding="utf-8")
approved = (ROOT / "tests/snapshots/index.html").read_text(encoding="utf-8")

if page != approved:
    print("FAIL: app/templates/index.html differs from the approved tests/snapshots/index.html")
    sys.exit(1)
print("PASS: page matches the approved snapshot")
