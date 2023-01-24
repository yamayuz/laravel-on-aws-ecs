ARG PHP_VERSION=8.1


FROM nginx:1.18.0-alpine AS nginx
COPY laravel/public /var/www/html/public
COPY docker/nginx/default.conf.template /etc/nginx/conf.d/default.conf.template
ENV PHP_HOST=127.0.0.1
EXPOSE 80
CMD /bin/sh -c 'sed "s/\${PHP_HOST}/${PHP_HOST}/" /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf && nginx -g "daemon off;"'


FROM php:${PHP_VERSION}-fpm-alpine AS composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY /laravel/composer.json /laravel/composer.lock ./
COPY /laravel/vendor /var/www/laravel/vendor
COPY /laravel/bootstrap/cache /var/www/laravel/bootstrap/cache
RUN docker-php-ext-install pdo_mysql


FROM php:${PHP_VERSION}-fpm-alpine AS app
WORKDIR /var/www/html
COPY docker/php/php.ini /usr/local/etc/php
COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY --from=composer /var/www/laravel/vendor ./vendor
COPY --from=composer /var/www/laravel/bootstrap/cache ./bootstrap/cachedocke
RUN docker-php-ext-install pdo_mysql
