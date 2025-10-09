#!/bin/bash
set -e

# Ensure runtime directories exist
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

# Initialize database directory if it doesn't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "🆕 First initialization detected — setting up MariaDB..."

    mysql_install_db --user=mysql --ldata=/var/lib/mysql

    echo "Starting temporary MariaDB server..."
    mysqld_safe --skip-networking &
    pid="$!"

    echo "Waiting for MariaDB to be ready..."
    timeout=30
    while [ ! -S /run/mysqld/mysqld.sock ]; do
        sleep 1
        timeout=$((timeout-1))
        if [ $timeout -le 0 ]; then
            echo "❌ MariaDB did not start properly — aborting setup."
            exit 1
        fi
    done

    echo "✅ MariaDB is ready, configuring initial users..."
    mysql -u root <<-EOSQL
CREATE DATABASE IF NOT EXISTS \`${MARIADB_DATABASE}\`;
CREATE USER IF NOT EXISTS \`${MARIADB_USER}\`@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MARIADB_DATABASE}\`.* TO \`${MARIADB_USER}\`@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOSQL

    echo "Shutting down temporary MariaDB..."
    mysqladmin -u root -p"${MARIADB_ROOT_PASSWORD}" shutdown

    echo "✅ MariaDB initial setup complete."

else
    echo "🔁 Existing MariaDB data found — skipping initialization."
fi

echo "🚀 Starting MariaDB in foreground..."
exec mysqld_safe