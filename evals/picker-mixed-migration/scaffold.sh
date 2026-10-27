#!/bin/bash
set -euo pipefail
# The mixed fixture is the FastAPI + vanilla project plus a half-started React app.
cp -R "$(dirname "$0")/../fixtures/fastapi-vanilla/." .
cp -R "$(dirname "$0")/../fixtures/mixed-migration/." .
