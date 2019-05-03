FROM drupal:8

RUN apt update && apt install -y \
        mysql-client \
        vim

COPY docker/httpd/app.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /app
COPY config config
COPY docker docker
COPY drush drush
COPY scripts scripts
COPY vendor vendor
COPY web web
COPY load.environment.php load.environment.php
COPY composer.json composer.json
COPY composer.lock composer.lock

RUN chown -R www-data:www-data web/sites web/modules web/themes config

WORKDIR /app/web/sites/default
RUN cp default.settings.php settings.php && \
    rm -rf files && \
    ln -s /data/public files

ENV DRUPAL_DB_DRIVER=mysql
ENV DRUPAL_DB_HOST=mysql
ENV DRUPAL_DB_PORT=3306
ENV DRUPAL_DB_NAME=drupal
ENV DRUPAL_DB_USERNAME=drupal
ENV DRUPAL_DB_PASSWORD=changeme
ENV DRUPAL_DB_PREFIX=""
ENV DRUPAL_HASH_SALT=changeme
ENV DRUPAL_TRUSTED_HOST_PATTERN="^.*$"
VOLUME /data

WORKDIR /app/

ENTRYPOINT /app/docker/entrypoint.sh