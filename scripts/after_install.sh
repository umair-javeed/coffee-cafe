#!/bin/bash
set -xe
source "$(dirname "$0")/_common.sh"

APP_DIR="/var/www/coffee-cafe"
cd "$APP_DIR" || exit 1

log "Starting AfterInstall phase..."

# Ensure PATH has common bin dirs
export PATH=$PATH:/usr/bin:/usr/local/bin

# Install Node.js + npm if missing
if ! command -v node >/dev/null 2>&1; then
  log "Installing Node.js..."
  curl -fsSL https://rpm.nodesource.com/setup_18.x | bash - || curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
  (yum install -y nodejs || apt-get install -y nodejs)
fi

# Install pm2 globally
if ! command -v pm2 >/dev/null 2>&1; then
  log "Installing pm2..."
  npm install -g pm2
fi

# Install dependencies
if [[ -f package-lock.json ]]; then
  npm ci
else
  npm install
fi

# Build app
npm run build

log "AfterInstall completed successfully."
