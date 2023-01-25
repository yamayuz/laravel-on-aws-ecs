ARG PHP_VERSION=8.1

FROM nginx:1.18.0-alpine AS nginx
RUN apk add --no-cache --update tzdata &&\
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata
COPY ./docker/nginx/default.conf /etc/nginx/conf.d/default.conf


FROM php:${PHP_VERSION}-fpm-alpine AS composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY /laravel/composer.json /laravel/composer.lock ./
COPY /laravel/vendor /var/www/laravel/vendor
COPY /laravel/bootstrap/cache /var/www/laravel/bootstrap/cache
RUN docker-php-ext-install pdo_mysql


FROM php:${PHP_VERSION}-fpm-alpine AS app
WORKDIR /var/www/html
RUN apk --no-cache update && \
    apk --no-cache upgrade && \
    apk --no-cache add \
    curl \
    zip \
    unzip \
    libjpeg-turbo-dev \
    freetype-dev \
    zlib \
    libwebp-dev \
    libpng-dev \
    libjpeg \
    nodejs \
    npm
COPY /docker/php/php.ini /usr/local/etc/php
RUN docker-php-ext-install pdo_mysql
COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY --from=composer /var/www/laravel/vendor ./vendor
COPY --from=composer /var/www/laravel/bootstrap/cache ./bootstrap/cachedocke
COPY /laravel /var/www/html/
