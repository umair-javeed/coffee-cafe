#!/bin/bash
set -xe
source "$(dirname "$0")/_common.sh"

log "ValidateService: Checking app health..."

# Give nginx a few seconds to start
sleep 5

if curl -fsS http://127.0.0.1/index.html >/dev/null; then
  echo "Health check passed"
  exit 0
else
  echo "Health check failed"
  exit 1
fi
