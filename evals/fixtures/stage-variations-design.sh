#!/bin/bash
# Shared by the planner variation cases: the planner fixture with an export whose three routes render one Screen.
# Only TodayTimeline has a Snooze button, so a plan that reads an unchosen variation shows it.
set -euo pipefail
fixtures="$(dirname "$0")"
bash "$fixtures/stage-reminders-design.sh"
rm -rf .ui-workflow/export
cp -R "$fixtures/design-export-variations" .ui-workflow/export
