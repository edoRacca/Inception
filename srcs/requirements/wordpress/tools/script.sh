#!/bin/bash

set -e

# upload variables from .env file
if [ -f /usr/local/bin/.env ]; then
	export $(grep -v '^#' /usr/local/bin/.env | xargs)
elif [ -f /var/www/html/.env ]; then
	export $(grep -v '^#' /var/www/html/.env | xargs)
fi

# WP_EXTRA="define(), "

mkdir -p $WP_PATH
cd $WP_PATH

# Se WordPress non è presente, lo scarico
if [ ! -f "$WP_PATH/wp-load.php" ]; then
	wp core download --path=$WP_PATH --allow-root
else
	echo "WordPress still present"
fi

if [ ! -f "$WP_PATH/wp-config.php" ]; then
	echo "creating wp-config.php configuration file"
	wp config create --dbname=$DB_NAME \
	--dbuser=$DB_USER --dbpass=$DB_PASSWORD \
	--dbhost=$DB_HOST \
	--allow-root || \
	echo "Maria DB not found"
fi


# install wordpress only if Maria DB is present
if wp db check --allow-root >/dev/null 2>&1; then
	if ! wp core is-installed --allow-root; then
		echo "DEBUG: installazione WordPress"
		wp core install \
			--url="$SITE_URL" \
			--title="$SITE_TITLE" \
			--admin_user="$WP_ADMIN_USER" \
			--locale="it_IT" \
			--admin_password="$WP_ADMIN_PASSWORD" \
			--admin_email="$WP_ADMIN_EMAIL" --allow-root
		wp user create "$WP_USER" "$WP_USER_EMAIL" --user_pass="$WP_USER_PASSWORD" --allow-root
	fi
else
	echo "wp core is not installed"
fi

# Imposta i permessi corretti
chown -R www-data:www-data $WP_PATH

# Configura php-fpm per ascoltare sulla porta 9000
PHP_FPM_CONF=$(find /etc/php -name www.conf | head -n 1)
if [ -n "$PHP_FPM_CONF" ]; then
	sed -i 's|listen = .*|listen = 0.0.0.0:9000|' "$PHP_FPM_CONF"
fi

# Trova il binario php-fpm disponibile
PHP_FPM_BIN=$(command -v php-fpm8.2 || command -v php-fpm || true)
if [ -z "$PHP_FPM_BIN" ]; then
	echo "ERROR: php-fpm binary not found!"
	exit 1
fi

exec $PHP_FPM_BIN -F