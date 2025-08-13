#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/_common.sh"

# Publish built assets: ensure a clean webroot, then copy ./dist
mkdir -p "$APP_DIR/web"
rm -rf "$APP_DIR/web"/*
if [[ -d "$APP_DIR/dist" ]]; then
  cp -R "$APP_DIR/dist/"* "$APP_DIR/web/"
elif [[ -d "$APP_DIR/build" ]]; then
  cp -R "$APP_DIR/build/"* "$APP_DIR/web/"
else
  echo "ERROR: No dist/ (or build/) directory found after build"; exit 1
fi

# Nginx server block pointing to /var/www/coffee-cafe/web
if [[ ! -f "$NGINX_CONF" ]]; then
  cat > "$NGINX_CONF" <<EOF
server {
    listen 80 default_server;
    server_name _;
    root $APP_DIR/web;
    index index.html;

    location / {
        try_files \$uri /index.html;
    }

    access_log /var/log/nginx/coffee-cafe.access.log;
    error_log  /var/log/nginx/coffee-cafe.error.log;
}
EOF
fi

# Correct permissions
chown -R nginx:nginx "$APP_DIR/web" 2>/dev/null || chown -R ec2-user:ec2-user "$APP_DIR/web"
