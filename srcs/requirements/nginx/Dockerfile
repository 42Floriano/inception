# Use a lightweight Alpine-based NGINX image
FROM alpine:latest

# Install required packages: NGINX and OpenSSL for TLS
RUN apk update && apk add --no-cache nginx openssl certbot certbot-nginx

# Create necessary directories for NGINX
RUN mkdir -p /etc/nginx/ssl /run/nginx /var/www/html

# Generate a self-signed SSL certificate
RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/OU=OrgUnit/CN=localhost"

# Copy the custom NGINX configuration file
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/conf.d/default.conf

# Set up entrypoint script
COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

# Expose HTTPS port
EXPOSE 80 443

# Run NGINX
CMD ["nginx", "-g", "daemon off;"]
