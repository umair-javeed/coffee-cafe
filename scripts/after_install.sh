#!/bin/bash
set -xe

APP_DIR="/var/www/coffee-cafe"

# Source shared functions
. "$(dirname "$0")/_common.sh"

log "Starting after_install step..."

cd "$APP_DIR" || exit 1

# Example: install dependencies
if command -v npm >/dev/null 2>&1; then
  log "Installing Node.js dependencies..."
  npm install --production 2>&1 | tee -a "$LOG_FILE"
else
  log "npm not found, skipping dependency installation."
fi

# Example: restart app using pm2
if command -v pm2 >/dev/null 2>&1; then
  log "Restarting app with pm2..."
  pm2 restart coffee-cafe || pm2 start npm --name coffee-cafe -- start
else
  log "pm2 not installed, skipping restart."
fi

log "after_install step completed successfully."
