FROM php:8.5-cli-alpine

# Install Composer
ENV COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/tmp/composer

RUN apk add --no-cache git unzip icu-dev \
    && docker-php-ext-install intl \
    && curl -sS https://getcomposer.org/installer \
        | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer --version

WORKDIR /app
