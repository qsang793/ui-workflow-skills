#!/bin/bash
set -euo pipefail
bash "$(dirname "$0")/../fixtures/stage-vercel-stub.sh" VERCEL_STUB_DEPLOYED=1 VERCEL_STUB_ALIAS=always
