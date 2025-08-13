#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/_common.sh"

# Reload/enable/start Nginx
systemctl daemon-reload || true
systemctl enable nginx || true

# Test Nginx config before restarting for safety
nginx -t
systemctl restart nginx

echo "Nginx restarted. Serving from $APP_DIR/web"
