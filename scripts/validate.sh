#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/_common.sh"

APP_PORT=3000   # adjust to whatever port your app listens on

set +e
curl -fsS "http://127.0.0.1:${APP_PORT}/health" && ok=1
set -e

if [[ "${ok:-0}" -ne 1 ]]; then
  echo "Health check failed"
  exit 1
fi
echo "Health check passed"

