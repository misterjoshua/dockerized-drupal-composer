#!/bin/bash

# ENV DATABASE_TYPE=mysql
# ENV DATABASE_HOST=localhost
# ENV DATABASE_PORT=3306
# ENV DATABASE_NAME=drupal
# ENV DATABASE_USER=user
# ENV DATABASE_PASSWORD=changeme

DRUSH=/app/vendor/bin/drush
INSTALL_PROFILE=${INSTALL_PROFILE:=standard}

function db_url() {
    echo "$DATABASE_TYPE://$DATABASE_USER:$DATABASE_PASSWORD@$DATABASE_HOST:$DATABASE_PORT/$DATABASE_NAME"
}

function apply_default_settings() {
    DEFAULT=web/sites/default
    # Use default settings because it has environment variables.
    rm -rf $DEFAULT/settings.php
    rm -rf $DEFAULT/files
    cp $DEFAULT/default.settings.php $DEFAULT/settings.php
}

function is_drupal_installed() {
    $DRUSH status bootstrap | grep -q Successful
}

function install_drupal() {
    DB_URL=$(db_url)

    $DRUSH site-install -y --db-url="$DB_URL" ${INSTALL_PROFILE}
    apply_default_settings
}

function serve() {
    docker-php-entrypoint $*
}

###########################
# Script begins here
###########################

set -x

apply_default_settings

for ATTEMPT in `seq 20`; do
    sleep 5
    echo "Checking if drupal is installed."
    if is_drupal_installed; then
        echo "Drupal is installed."
        break
    fi

    echo "Attempting to install drupal"
    install_drupal
done

if ! is_drupal_installed; then
    echo "Timed out: Drupal not available."
    exit 1
fi

serve apache2-foreground