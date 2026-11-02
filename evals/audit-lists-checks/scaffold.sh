#!/bin/bash
set -euo pipefail
here="$(dirname "$0")"
bash "$here/../audit-fastapi-vanilla/scaffold.sh"

# Checks in three places, one of them named so it may look like it needs a browser.
cat > package.json <<'JSON'
{
  "name": "reminders",
  "private": true,
  "scripts": {
    "test": "python3 -m unittest discover tests",
    "test:browser": "python3 tests/browser_checks.py",
    "dev": "uvicorn app.main:app --reload",
    "deploy": "scp -r app host:/srv/reminders"
  }
}
JSON
mkdir tests
for script in browser_checks contrast css_budget test_app; do
  printf 'import sys\nsys.exit(0)\n' > "tests/$script.py"
done
printf 'check-contrast:\n\tpython3 tests/contrast.py\n' > Makefile
mkdir -p .github/workflows
cat > .github/workflows/ci.yml <<'YAML'
on: push
jobs:
  css:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: python3 tests/css_budget.py
YAML
