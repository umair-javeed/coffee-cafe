#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/_common.sh"

# Create target dir (CodeDeploy will copy files there from appspec 'files' section)
mkdir -p "$APP_DIR"
chown -R ec2-user:ec2-user "$APP_DIR"

# If Nginx is running, keep it up (serves old content) until new build is ready
# We only stop on ApplicationStart after swapping content if needed.
systemctl status nginx >/dev/null 2>&1 || true
