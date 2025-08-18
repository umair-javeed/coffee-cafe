#!/bin/bash
set -xe
source "$(dirname "$0")/_common.sh"

APP_DIR="/var/www/coffee-cafe"
cd "$APP_DIR" || exit 1

log "Starting ApplicationStart phase..."

# Ensure PATH includes npm + pm2 locations
export PATH=$PATH:/usr/bin:/usr/local/bin

# Reload systemd units
systemctl daemon-reload || true

# Start Nginx only if installed
if command -v nginx >/dev/null 2>&1; then
  log "Configuring Nginx..."
  systemctl enable nginx || true
  systemctl start nginx || true
  nginx -t || true
else
  log "Nginx not installed, skipping reverse proxy setup."
fi

# Start Node app with pm2
if command -v pm2 >/dev/null 2>&1; then
  log "Restarting app with pm2..."
  pm2 restart coffee-cafe || pm2 start npm --name coffee-cafe -- start
else
  log "pm2 not installed, installing..."
  # Use full path to npm just in case PATH still misses it
  if command -v npm >/dev/null 2>&1; then
    NPM_CMD=$(command -v npm)
    $NPM_CMD install -g pm2
    pm2 start npm --name coffee-cafe -- start
  else
    log "npm not found — ensure Node.js and npm are installed in AfterInstall step."
    exit 1
  fi
fi

log "ApplicationStart completed successfully."

