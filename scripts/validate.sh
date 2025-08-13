#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/_common.sh"

# Simple health checks (any one passing is OK)
set +e
curl -fsS http://127.0.0.1/health && ok=1
curl -fsS http://127.0.0.1/index.html && ok=1
curl -fsS http://localhost/ && ok=1
set -e

if [[ "${ok:-0}" -ne 1 ]]; then
  echo "Health check failed"
  exit 1
fi
echo "Health check passed"
