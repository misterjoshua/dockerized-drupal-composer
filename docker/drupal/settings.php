<?php

// @codingStandardsIgnoreFile

// Use the image build's deployment identifier.
$settings['deployment_identifier'] = file_get_contents('/deployment-identifier');

// Database
$databases = [];
$databases['default']['default'] = array (
  'database' => getenv('DRUPAL_DB_NAME'),
  'username' => getenv('DRUPAL_DB_USERNAME'),
  'password' => getenv('DRUPAL_DB_PASSWORD'),
  'host' => getenv('DRUPAL_DB_HOST'),
  'port' => getenv('DRUPAL_DB_PORT'),
  'driver' => getenv('DRUPAL_DB_DRIVER'),
  'prefix' => getenv('DRUPAL_DB_PREFIX'),
  'collation' => 'utf8mb4_general_ci',
);

// Password hash salt.
$settings['hash_salt'] = getenv('DRUPAL_HASH_SALT');

// Admin UI restrictions
$settings['update_free_access'] = FALSE;
$settings['allow_authorize_operations'] = FALSE;

// File paths
$settings['file_public_base_url'] = "//" . $_SERVER['HTTP_HOST'] . getenv('DRUPAL_FILES_PATH');
$settings['file_public_path'] = getenv('DRUPAL_FILES_ROOT').'/public';
$settings['translation_path'] = getenv('DRUPAL_FILES_ROOT').'/translations';
$settings['file_private_path'] = getenv('DRUPAL_FILES_ROOT').'/private';
$config['system.file']['path']['temporary'] = '/tmp';

// Site config
$config_directories = [];
$config_directories['sync'] = '../config/sync';
$settings['container_yamls'][] = $app_root . '/' . $site_path . '/services.yml';

// Http security
$settings['trusted_host_patterns'] = [
  getenv('DRUPAL_TRUSTED_HOST_PATTERN'),
];

// Miscellaneous
$settings['file_scan_ignore_directories'] = [
  'node_modules',
  'bower_components',
];
$settings['entity_update_batch_size'] = 50;
$settings['entity_update_backup'] = TRUE;

// Allow overrides via settings.local.php
if (file_exists($app_root . '/' . $site_path . '/settings.local.php')) {
  include $app_root . '/' . $site_path . '/settings.local.php';
}