FROM php:7.3-cli
RUN pecl install swoole \
    && docker-php-ext-enable swoole

COPY index.php /var/www

EXPOSE 9501

ENTRYPOINT ["php","/var/www/index.php","start"]