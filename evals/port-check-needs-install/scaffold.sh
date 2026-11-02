#!/bin/bash
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
bash "$here/../fixtures/stage-port-extraction.sh" port-provenance

# A second check that cannot run: the package it imports is not installed.
cat > package.json <<'JSON'
{
  "name": "reminders",
  "private": true,
  "scripts": {
    "test": "python3 -m unittest discover tests",
    "test:e2e": "python3 tests/e2e_checks.py"
  }
}
JSON
cp "$here/e2e_checks.py" tests/e2e_checks.py
git add -- package.json tests/e2e_checks.py
git commit -q --amend --no-edit

perl -pi -e 's{^(- Run: .*)$}{$1\n- Checks: `npm test`; `npm run test:e2e`}' .ui-workflow/audit.md
grep -q 'test:e2e' .ui-workflow/audit.md
