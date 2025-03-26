#!/bin/sh
set -x

# Wait for MariaDB to be ready
until mariadb-admin ping -hmariadb -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --skip-ssl --silent; do
  echo "⏳ Waiting for MariaDB..."
  sleep 2
done

# Extract WordPress if needed
if [ ! -f /var/www/html/index.php ]; then
  echo "⚙️ Extracting WordPress..."
  curl -O https://wordpress.org/latest.tar.gz && \
  tar -xzf latest.tar.gz && \
  rm latest.tar.gz && \
  mv wordpress/* /var/www/html && \
  chown -R 82:82 /var/www/html
fi

# Generate wp-config.php from environment
if [ ! -f /var/www/html/wp-config.php ]; then
  echo "🔧 Generating wp-config.php..."
  cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

  sed -i "s/database_name_here/$MYSQL_DATABASE/" /var/www/html/wp-config.php
  sed -i "s/username_here/$MYSQL_USER/" /var/www/html/wp-config.php
  sed -i "s/password_here/$MYSQL_PASSWORD/" /var/www/html/wp-config.php
  sed -i "s/localhost/mariadb/" /var/www/html/wp-config.php
fi

# Auto-install WordPress if not installed
if ! wp core is-installed --path=/var/www/html --allow-root; then
  echo "🔨 Installing WordPress..."
  wp core install \
    --path=/var/www/html \
    --url="$WP_URL" \
    --title="$WP_TITLE" \
    --admin_user="$WP_ADMIN" \
    --admin_password="$WP_ADMIN_PASSWORD" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --skip-email \
    --allow-root

  echo "🌎 Installing default plugin..."
  wp plugin install hello-dolly --activate --allow-root
fi

exec php-fpm -F
