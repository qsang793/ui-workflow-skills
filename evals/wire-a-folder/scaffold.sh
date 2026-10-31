#!/bin/bash
set -euo pipefail
bash "$(dirname "$0")/../fixtures/stage-wire-a.sh" wire-export-a
mkdir docs
echo "Keep these notes." > docs/notes.md
git add -- docs/notes.md
git commit -qm "Notes"
