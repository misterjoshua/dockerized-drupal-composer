#!/bin/bash

set -e

# Environment settings
PHP_CONF_DIR=${PHP_CONF_DIR:=/usr/local/etc/php/conf.d}
SITE_DIR=${SITE_DIR:=/app/web/sites/default}
DEBUG_MODE=${DEBUG_MODE:=}
DRUPAL_FILES_ROOT=${DRUPAL_FILES_ROOT:=/data}
DRUPAL_FILES_USER=${DRUPAL_FILES_USER:=www-data}
DRUPAL_FILES_GROUP=${DRUPAL_FILES_GROUP:=www-data}

# Disable xdebug if we're not in debug mode.
if [[ -z "$DEBUG_MODE" ]]; then
    rm -rf ${PHP_CONF_DIR}/*xdebug*.ini
fi

# Initialize the data volume
mkdir -p ${DRUPAL_FILES_ROOT}/public
mkdir -p ${DRUPAL_FILES_ROOT}/private
mkdir -p ${DRUPAL_FILES_ROOT}/translations
chown -R ${DRUPAL_FILES_USER}:${DRUPAL_FILES_GROUP} ${DRUPAL_FILES_ROOT}/*

# Initialize drupal settings to use the default settings file.
rm -rf ${SITE_DIR}/settings.php
ln -sf ${SITE_DIR}/default.settings.php ${SITE_DIR}/settings.php

# Run apache
docker-php-entrypoint apache2-foreground