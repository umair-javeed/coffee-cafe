#!/bin/bash
set -xe

# Use a safer log location inside your app folder instead of /var/log
APP_DIR="/var/www/coffee-cafe"
LOG_FILE="$APP_DIR/deploy.log"

# Ensure app dir exists
mkdir -p "$APP_DIR"

# Ensure log file exists and is writable
touch "$LOG_FILE"
chmod 666 "$LOG_FILE"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}
