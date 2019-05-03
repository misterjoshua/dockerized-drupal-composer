#!/bin/bash

mkdir -p /data/public
mkdir -p /data/private
chown -R www-data:www-data /data/*

docker-php-entrypoint apache2-foreground