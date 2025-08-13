#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/_common.sh"

# Detect Amazon Linux / RHEL family
if command -v yum >/dev/null 2>&1; then
  PKG_MGR="yum"
elif command -v dnf >/dev/null 2>&1; then
  PKG_MGR="dnf"
elif command -v apt-get >/dev/null 2>&1; then
  PKG_MGR="apt"
else
  echo "Unsupported package manager"; exit 1
fi

# Install Node (for building) if not present
if ! command -v node >/dev/null 2>&1; then
  echo "Installing Node.js (LTS)…"
  if [[ "$PKG_MGR" =~ ^(yum|dnf)$ ]]; then
    curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
    sudo $PKG_MGR -y install nodejs
  else
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    sudo apt-get -yq install nodejs
  fi
fi

# Install Nginx if not present
if ! command -v nginx >/dev/null 2>&1; then
  echo "Installing Nginx…"
  if [[ "$PKG_MGR" =~ ^(yum|dnf)$ ]]; then
    sudo $PKG_MGR -y install nginx
  else
    sudo apt-get -yq install nginx
  fi
fi

# Build the site from the copied repo in APP_DIR
# (appspec files section copied the repo to $APP_DIR already)
cd "$APP_DIR"

# Use npm ci when lockfile exists, else npm install
if [[ -f package-lock.json ]]; then
  npm ci
else
  npm install
fi

# Build (expects "build" script in package.json for Vite)
npm run build
