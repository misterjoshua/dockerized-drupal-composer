FROM drupal:8

# Remove the old drupal
RUN rm -rf /var/www/html

# Add xdebug (disabled by entrypoint.sh if DEBUG_MODE env is empty)
RUN pecl install xdebug-2.7.1 && docker-php-ext-enable xdebug

# Configure httpd
COPY docker/httpd/app.conf /etc/apache2/sites-available/000-default.conf
COPY docker/httpd/xdebug.ini /usr/local/etc/php/conf.d/99-xdebug.ini

# Provide a build date so drupal can use it as a deployment_identifier
RUN date +"%s" >/deployment-identifier

# Provide the app build
COPY app /app
COPY docker /docker

# Runtime environment
ENV DEBUG_MODE=''
ENV DRUPAL_DB_DRIVER=mysql
ENV DRUPAL_DB_HOST=mysql
ENV DRUPAL_DB_PORT=3306
ENV DRUPAL_DB_NAME=drupal
ENV DRUPAL_DB_USERNAME=drupal
ENV DRUPAL_DB_PASSWORD=changeme
ENV DRUPAL_DB_PREFIX=""
ENV DRUPAL_HASH_SALT=changeme
ENV DRUPAL_TRUSTED_HOST_PATTERN="^.*$"

ENV DEBUG_MODE=""
ENV DRUPAL_FILES_ROOT=/data
ENV DRUPAL_FILES_USER=www-data
ENV DRUPAL_FILES_GROUP=www-data
ENV DRUPAL_FILES_PATH=/files

VOLUME /data

WORKDIR /app
ENTRYPOINT /docker/entrypoint.sh

EXPOSE 80
CMD ["apache2-foreground"]