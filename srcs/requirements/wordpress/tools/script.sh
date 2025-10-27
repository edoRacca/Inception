#!/bin/bash

set -e

WP_PATH=/var/www/html
DB_NAME=wordpress
DB_USER=wp_user
DB_PASSWORD=wp_pass
DB_HOST=mariadb  # quando aggiungerai il container MariaDB
SITE_URL=https://localhost
SITE_TITLE="My Docker WP"
ADMIN_USER=admin
ADMIN_PASSWORD=admin123
ADMIN_EMAIL=admin@example.com

echo "📦 Avvio setup WordPress..."

# 1️⃣ Scarica WordPress se non esiste
if [ ! -f "$WP_PATH/wp-load.php" ]; then
    echo "⬇️ Downloading WordPress..."
    wp core download --allow-root --path=$WP_PATH
else
    echo "✔️ WordPress già presente"
fi

# 2️⃣ Crea wp-config.php se non esiste
if [ ! -f "$WP_PATH/wp-config.php" ]; then
    echo "⚙️ Creazione file wp-config.php..."
    wp config create \
        --dbname=$DB_NAME \
        --dbuser=$DB_USER \
        --dbpass=$DB_PASSWORD \
        --dbhost=$DB_HOST \
        --allow-root
else
    echo "✔️ Config già presente"
fi

# 3️⃣ Installa WordPress (solo se non è già installato)
if ! wp core is-installed --allow-root; then
    echo "🚀 Installazione di WordPress..."
    wp core install \
        --url=$SITE_URL \
        --title="$SITE_TITLE" \
        --admin_user=$ADMIN_USER \
        --admin_password=$ADMIN_PASSWORD \
        --admin_email=$ADMIN_EMAIL \
        --skip-email \
        --allow-root
else
    echo "✔️ WordPress già installato"
fi

# 4️⃣ Permessi corretti
chown -R www-data:www-data $WP_PATH

# 5️⃣ Configura php-fpm per ascoltare su 0.0.0.0:9000
PHP_FPM_CONF=$(find /etc/php -name www.conf | head -n 1)
if [ -n "$PHP_FPM_CONF" ]; then
    sed -i 's|listen = .*|listen = 0.0.0.0:9000|' "$PHP_FPM_CONF"
fi

# 6️⃣ Avvia php-fpm in foreground (processo principale)
echo "🚀 Avvio di php-fpm..."
exec php-fpm8.2 -F



# set -e 
# WP_PATH=/var/www/html

# if [ ! -f $WP_PATH/wp-config.php ]; then
# 	echo "Installing WordPress ..."
# 	wp core download --path="$WP_PATH" --allow-root
# 	sed -i 's|listen = /run/php/php.*-fpm.sock|listen = 0.0.0.0:9000|' /etc/php/*/fpm/pool.d/www.conf
# else
# 	echo "WordPress already installed"
# fi
# 	exec php-fpm8.2 -F