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





# set -e

# # Se la cartella dei dati è vuota, inizializzo MariaDB
# if [ ! -d /var/lib/mysql/mysql ]; then
#     echo ">> Inizializzazione MariaDB..."
#     mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql
# fi

# #creazione cartella mysql modificabili per mysql user
# mkdir -p /var/run/mysql
# chmod -R mysql:mysql /var/run/mysql /var/lib/mysql

# mysqld --user=mysql --datadir=/var/lib/mysql --pid-file=/var/run/mysql/mysql.pid & pid="$!"

# until mysql ping --silent; do
#     echo "Pinging myself";
#     sleep 1;
# done
# echo "Mariadb ready";


# # Imposta password root se definita
# if [ -n "$MYSQL_ROOT_PASSWORD" ]; then
#     echo ">> Imposto password root..."
#     mysql -u root <<EOSQL
# ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
# FLUSH PRIVILEGES;
# EOSQL
# fi

# # Crea database di default
# if [ -n "$MYSQL_DATABASE" ]; then
#     echo ">> Creo database ${MYSQL_DATABASE}..."
#     mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
# fi

# # Crea utente applicazione
# if [ -n "$MYSQL_DATABASE" ] || [ -n "$MYSQL_USER" ]; then
#     INIT_FILE=/tmp/init.sql
#     echo "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;" > $INIT_FILE
#     echo "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';" >> $INIT_FILE
#     echo "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%';" >> $INIT_FILE
#     echo "FLUSH PRIVILEGES;" >> $INIT_FILE
#     # Avvia mysqld con init-file
#     exec mysqld --user=mysql --datadir=/var/lib/mysql --init-file=$INIT_FILE --bind-address=0.0.0.0
# else
#     # Altrimenti avvia normalmente
#     exec mysqld --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0
# fi

# # Arresta il MariaDB temporaneo
# mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

# # Avvia MariaDB normalmente
# echo ">> Avvio MariaDB..."
# exec mysqld --user=mysql --bind-address=0.0.0.0
