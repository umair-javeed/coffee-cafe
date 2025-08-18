#!/bin/bash
set -xe
source "$(dirname "$0")/_common.sh"

log "ApplicationStart: Configuring Nginx..."

# Install nginx if missing
if ! command -v nginx >/dev/null 2>&1; then
  yum install -y nginx || apt-get install -y nginx
fi

# Nginx config for Vite build
cat > /etc/nginx/conf.d/coffee-cafe.conf <<'EOL'
server {
    listen 80;
    server_name _;

    root /var/www/coffee-cafe/dist;
    index index.html;

    location / {
        try_files $uri /index.html;
    }
}
EOL

# Restart Nginx
systemctl enable nginx
systemctl restart nginx

log "ApplicationStart completed successfully."
