#!/bin/bash
# Runs the behavioural evals on Sonnet. Extra arguments go to `claude plugin eval`: --case <name>, --runs 1, --model <model>.
set -euo pipefail
cd "$(dirname "$0")/.."

started="$(mktemp)"
status=0
# env -i: a child `claude` that inherits a Claude Code session's environment can fail its subscription login.
env -i HOME="$HOME" PATH="$PATH" USER="$USER" TERM="${TERM:-xterm-256color}" LANG="${LANG:-en_US.UTF-8}" TMPDIR="${TMPDIR:-/tmp}" \
  claude plugin eval . --trust-plugin --scaffold --allow-tools Bash Write Edit --ablation none --no-publish --model sonnet "$@" || status=$?

# Results get committed and this repo is public; scripts/validate.py rejects a home path in them.
find evals/results -type f -newer "$started" -exec perl -pi -e 's/\Q$ENV{HOME}\E/~/g' {} +
rm -f "$started"
exit "$status"
