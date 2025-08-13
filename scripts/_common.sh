#!/bin/bash
set -euo pipefail

APP_DIR="/var/www/coffee-cafe"
REPO_DIR="$(pwd)"                 # CodeDeploy extracts bundle here before copying
LOG="/var/log/coffee-cafe-deploy.log"
NGINX_CONF="/etc/nginx/conf.d/coffee-cafe.conf"

exec >>"$LOG" 2>&1
echo "[$(date -Is)] ----- $0 -----"
echo "REPO_DIR=$REPO_DIR  APP_DIR=$APP_DIR"
