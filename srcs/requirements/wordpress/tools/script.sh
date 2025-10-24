#!/bin/bash

set -e WP_PATH="/var/www/html"

if [ ! -f $WP_PATH/wp-config.php ] then
	echo "Installing WordPress ..."
	wp core download --path="$WP_PATH" --allow-root
else
	echo "WordPress already installed"
fi