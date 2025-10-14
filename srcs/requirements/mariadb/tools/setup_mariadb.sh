#!/bin/bash
set -euo pipefail

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "🆕 First initialization detected — setting up MariaDB..."

    mysql_install_db --user=mysql --ldata=/var/lib/mysql

    echo "Starting temporary MariaDB server..."
    mysqld --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
    temp_pid=$!

    echo "Waiting for MariaDB to be ready..."
    for i in {30..0}; do
        if [ -S /run/mysqld/mysqld.sock ]; then
            break
        fi
        sleep 1
    done

    if [ ! -S /run/mysqld/mysqld.sock ]; then
        echo "❌ MariaDB did not start properly — aborting setup."
        kill "$temp_pid" || true
        exit 1
    fi

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
exec mysqld --user=mysql --console

# #!/bin/sh
# set -e

# echo "🧩 Starting MariaDB setup..."

# # Start MariaDB in safe mode temporarily
# mysqld_safe --skip-networking &
# pid="$!"

# # Wait for MariaDB to be ready
# echo "⏳ Waiting for MariaDB..."
# until mariadb -u root -e "SELECT 1" >/dev/null 2>&1; do
#   sleep 1
# done
# echo "✅ MariaDB is ready!"

# # Run setup only if DB not initialized
# if [ ! -d "/var/lib/mysql/${MARIADB_DATABASE}" ]; then
#   echo "⚙️ Configuring database..."
#   mariadb -u root -e "CREATE DATABASE IF NOT EXISTS \`${MARIADB_DATABASE}\`;"
#   mariadb -u root -e "CREATE USER IF NOT EXISTS \`${MARIADB_USER}\`@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';"
#   mariadb -u root -e "GRANT ALL PRIVILEGES ON \`${MARIADB_DATABASE}\`.* TO \`${MARIADB_USER}\`@'%';"
#   mariadb -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';"
#   mariadb -u root -p"${MARIADB_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"
# fi

# # Stop temporary server
# mysqladmin -u root -p"${MARIADB_ROOT_PASSWORD}" shutdown

# # Start MariaDB in the foreground (keeps container alive)
# echo "🚀 Launching MariaDB..."
# exec mysqld_safe


# #Script for tini
