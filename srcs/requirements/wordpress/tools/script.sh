#!/bin/bash

set -e 
WP_PATH=/var/www/html

if [ ! -f $WP_PATH/wp-config.php ]; then
	echo "Installing WordPress ..."
	wp core download --path="$WP_PATH" --allow-root
	sed -i 's|listen = /run/php/php.*-fpm.sock|listen = 0.0.0.0:9000|' /etc/php/*/fpm/pool.d/www.conf
else
	echo "WordPress already installed"
fi
	exec php-fpm8.2 -F