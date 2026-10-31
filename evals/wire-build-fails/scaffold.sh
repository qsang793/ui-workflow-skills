#!/bin/bash
set -euo pipefail
bash "$(dirname "$0")/../fixtures/stage-wire-a.sh" wire-export-a
# A dependency that exists nowhere: install fails with or without network.
cd .ui-workflow/export
perl -0pi -e 's/("type": "module",)/$1\n  "dependencies": { "\@ui-workflow-eval\/design-kit": "1.0.0" },/' package.json
perl -pi -e '$_ = "import \"\@ui-workflow-eval\/design-kit\";\n$_" if $. == 2' scripts/build.mjs
grep -q '"@ui-workflow-eval/design-kit": "1.0.0"' package.json
grep -q '^import "@ui-workflow-eval/design-kit";$' scripts/build.mjs
