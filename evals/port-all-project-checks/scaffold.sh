#!/bin/bash
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
bash "$here/../fixtures/stage-port-extraction.sh" port-provenance

# A second check that no install blocks, whose name suggests a browser. Any Port breaks its snapshot.
cat > package.json <<'JSON'
{
  "name": "reminders",
  "private": true,
  "scripts": {
    "test": "python3 -m unittest discover tests",
    "test:browser": "python3 tests/browser_checks.py"
  }
}
JSON
cp "$here/browser_checks.py" tests/browser_checks.py
mkdir -p tests/snapshots
cp app/templates/index.html tests/snapshots/index.html
python3 tests/browser_checks.py
git add -- package.json tests/browser_checks.py tests/snapshots
git commit -q --amend --no-edit
