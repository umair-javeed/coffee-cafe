#!/bin/bash
set -xe
source "$(dirname "$0")/_common.sh"

APP_DIR="/var/www/coffee-cafe"
cd "$APP_DIR" || exit 1

log "AfterInstall: Installing dependencies and building app..."

# Ensure Node is installed
if ! command -v node >/dev/null 2>&1; then
  curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
  yum install -y nodejs || apt-get install -y nodejs
fi

# Install deps & build
npm ci || npm install
npm run build

log "AfterInstall completed successfully."
