# #!/bin/bash

set -e

# Directory necessarie
mkdir -p /var/lib/mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

# Se MariaDB non è inizializzato
if [ ! -d /var/lib/mysql/mysql ]; then
    echo ">> Inizializzazione MariaDB (prima installazione)..."
    mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql
fi

# Se ci sono variabili da configurare, genero init.sql
INIT_FILE=""

if [ -n "$MYSQL_ROOT_PASSWORD" ] || [ -n "$MYSQL_DATABASE" ] || [ -n "$MYSQL_USER" ]; then
    INIT_FILE="/tmp/init.sql"
    echo "SET @@SESSION.SQL_LOG_BIN=0;" > "$INIT_FILE"

    # Password root
    if [ -n "$MYSQL_ROOT_PASSWORD" ]; then
        echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';" >> "$INIT_FILE"
    fi

    # Database
    if [ -n "$MYSQL_DATABASE" ]; then
        echo "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;" >> "$INIT_FILE"
    fi

    # Utente applicazione
    if [ -n "$MYSQL_USER" ] && [ -n "$MYSQL_PASSWORD" ]; then
        echo "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';" >> "$INIT_FILE"
        echo "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%';" >> "$INIT_FILE"
    fi

    echo "FLUSH PRIVILEGES;" >> "$INIT_FILE"
fi

echo ">> Avvio MariaDB..."

# Avvio finale: solo UN mysqld in foreground
if [ -n "$INIT_FILE" ]; then
    exec mysqld --user=mysql --datadir=/var/lib/mysql --init-file="$INIT_FILE" --bind-address=0.0.0.0
else
    exec mysqld --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0
fi
