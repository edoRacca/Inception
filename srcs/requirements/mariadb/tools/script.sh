#!/bin/bash
set -e

# Carico variabili .env
if [ -f /usr/local/bin/.env ]; then
    export $(grep -v '^#' /usr/local/bin/.env | xargs)
elif [ -f /var/www/html/.env ]; then
    export $(grep -v '^#' /var/www/html/.env | xargs)
fi

# Se la cartella dei dati è vuota, inizializzo MariaDB
if [ ! -d /var/lib/mysql/mysql ]; then
    echo ">> Inizializzazione MariaDB..."
    mysqld --initialize-insecure --user=mysql
fi

# Creo file SQL temporaneo per bootstrap (utente, DB)
BOOTSTRAP_SQL="/tmp/bootstrap.sql"
cat > $BOOTSTRAP_SQL << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# Avvio MariaDB con bootstrap
exec mysqld --user=mysql --init-file=$BOOTSTRAP_SQL
