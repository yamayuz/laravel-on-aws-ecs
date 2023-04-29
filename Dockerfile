ARG PHP_VERSION=8.1


FROM nginx:1.18.0-alpine AS nginx
RUN apk add --no-cache --update tzdata &&\
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata
COPY ./docker/nginx/default.conf /etc/nginx/conf.d/default.conf


FROM php:${PHP_VERSION}-fpm-alpine AS composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY /laravel/composer.json /laravel/composer.lock ./
RUN composer install --no-scripts --no-autoloader --dev
COPY ./laravel/ .
RUN composer dump-autoload --optimize


FROM php:${PHP_VERSION}-fpm-alpine AS app
WORKDIR /var/www/html
RUN apk add --no-cache libstdc++ && \
    apk add --no-cache libgcc && \
    apk --no-cache update && \
    apk --no-cache upgrade
COPY docker/php/php.ini /usr/local/etc/php/
RUN docker-php-ext-install pdo_mysql
COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY --from=composer /var/www/html/vendor ./vendor
COPY --from=composer /var/www/html/bootstrap/cache ./bootstrap/cache
COPY /laravel /var/www/html/