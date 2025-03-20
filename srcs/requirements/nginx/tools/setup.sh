#!/bin/sh

# Ensure SSL certificates exist
if [ ! -f "/etc/nginx/ssl/nginx.crt" ] || [ ! -f "/etc/nginx/ssl/nginx.key" ]; then
    echo "SSL certificates missing!"
    exit 1
fi

# Start NGINX
exec nginx -g "daemon off;"
