#!/bin/bash

set -e

# upload variables from .env file
if [ -f /usr/local/bin/.env ]; then
	export $(grep -v '^#' /usr/local/bin/.env | xargs)
elif [ -f /var/www/html/.env ]; then
	export $(grep -v '^#' /var/www/html/.env | xargs)
fi

echo "📦 Avvio setup WordPress..."

mkdir -p $WP_PATH
cd $WP_PATH

# Se WordPress non è presente, scaricalo
if [ ! -f "$WP_PATH/wp-load.php" ]; then
    echo "⬇️ Downloading WordPress..."
    wp core download --allow-root --path=$WP_PATH
else
    echo "✔️ WordPress già presente"
fi

if [ ! -f "$WP_PATH/wp-config.php" ]; then
	echo "DEBUG: Creazione file wp-config.php"
	wp config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASSWORD --dbhost=$DB_HOST --allow-root || \
	echo "DEBUG: Maria DB not found"
fi

# install wordpress only if Maria DB is present
if wp db check --allow-root >/dev/null 2>&1; then
	if ! wp core is-installed --allow-root; then
		echo "DEBUG: installazione WordPress"
		wp core install --url=$SITE_URL --title="$SITE_TITLE" --admin-user=$ADMIN_USER --allow-root
	fi
else
	echo "DEBUG: installation failed, WordPress skipped"
fi

# Imposta i permessi corretti
chown -R www-data:www-data $WP_PATH

# Configura php-fpm per ascoltare su 0.0.0.0:9000
PHP_FPM_CONF=$(find /etc/php -name www.conf | head -n 1)
if [ -n "$PHP_FPM_CONF" ]; then
    sed -i 's|listen = .*|listen = 0.0.0.0:9000|' "$PHP_FPM_CONF"
fi

echo "🚀 Avvio di php-fpm..."
exec php-fpm8.2 -F
