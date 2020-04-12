#!/bin/bash

composer install
chown -R www-data:www-data * && \
php artisan key:generate
php artisan migrate
php-fpm
