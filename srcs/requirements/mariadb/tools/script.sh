
#!/bin/bash

set -e

# initialize db if not existing
if [ ! -d /var/lib/mysql/mysql ]; then
	mysql_install_db --user=mysql --ldata=/var/lib/mysql
fi

# start mariadb in background for starting configuration
mysqld --user=mysql --skip-networking & pid=$!

# Configure root
if [ -n "$MYSQL_ROOT_PASSWORD" ]; then
    echo ">> Imposto password root..."
    mysql -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF
fi

# create db if required
if [ -n "$MYSQL_DATABASE" ]; then
    echo ">> Creo database ${MYSQL_DATABASE}..."
    mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
fi

# create application block if required
if [ -n "$MYSQL_USER" ] && [ -n "$MYSQL_PASSWORD" ]; then
    echo ">> Creo utente ${MYSQL_USER}..."
    mysql -u root -p${MYSQL_ROOT_PASSWORD} << EOF
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
fi

# Stop MariaDB bootstrap
mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

# Avvia MariaDB normalmente
echo ">> Avvio MariaDB..."
exec mysqld --user=mysql