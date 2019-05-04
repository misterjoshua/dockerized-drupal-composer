#!/bin/bash

set -e

# Environment settings
PHP_CONF_DIR=${PHP_CONF_DIR:=/usr/local/etc/php/conf.d}
SITE_DIR=${SITE_DIR:=/app/web/sites/default}
DEBUG_MODE=${DEBUG_MODE:=}
DRUPAL_FILES_ROOT=${DRUPAL_FILES_ROOT:=/data}
DRUPAL_FILES_USER=${DRUPAL_FILES_USER:=www-data}
DRUPAL_FILES_GROUP=${DRUPAL_FILES_GROUP:=www-data}
DOCKER_DIR=${DOCKER_DIR:=/docker}
DOCKER_LOCALHOST=host.docker.internal

# Disable xdebug if we're not in debug mode.
if [[ "$DEBUG_MODE" = "connect_back" ]]; then
    echo "Debugging with connect-back"
    cp ${DOCKER_DIR}/httpd/xdebug_connect_back.ini ${PHP_CONF_DIR}/xdebug.ini
elif [[ "$DEBUG_MODE" = "docker_host" ]]; then
    echo "Debugging to docker localhost"
    cp ${DOCKER_DIR}/httpd/xdebug_docker_localhost.ini ${PHP_CONF_DIR}/xdebug.ini
else
    rm -rf ${PHP_CONF_DIR}/*xdebug*.ini
fi

# Initialize the data volume
mkdir -p ${DRUPAL_FILES_ROOT}/public
mkdir -p ${DRUPAL_FILES_ROOT}/private
mkdir -p ${DRUPAL_FILES_ROOT}/translations
chown -R ${DRUPAL_FILES_USER}:${DRUPAL_FILES_GROUP} ${DRUPAL_FILES_ROOT}/*

# Initialize drupal settings to use the docker settings file. Users can add
# their own settings in settings.local.php.
ln -sf ${DOCKER_DIR}/drupal/settings.php ${SITE_DIR}/settings.php

# Run apache
docker-php-entrypoint apache2-foreground