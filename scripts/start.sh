#!/bin/bash
set -xe
source "$(dirname "$0")/_common.sh"

APP_DIR="/var/www/coffee-cafe"
cd "$APP_DIR" || exit 1

log "Starting ApplicationStart phase..."

systemctl daemon-reload || true

# Start Nginx if installed
if command -v nginx >/dev/null 2>&1; then
  log "Starting Nginx..."
  systemctl enable nginx || true
  systemctl start nginx || true
else
  log "Nginx not installed, skipping."
fi

# Start Node app with pm2 (Node & pm2 already installed in AfterInstall)
log "Starting Node app with pm2..."
pm2 restart coffee-cafe || pm2 start npm --name coffee-cafe -- start

log "ApplicationStart completed successfully."
