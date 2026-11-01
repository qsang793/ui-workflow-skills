#!/bin/bash
set -euo pipefail
bash "$(dirname "$0")/../fixtures/stage-port-extraction.sh" port-tailwind
