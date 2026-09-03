FROM php:8.4-cli-alpine

LABEL maintainer="Rob Mellett"
LABEL org.opencontainers.image.title="php-84-ci"
LABEL org.opencontainers.image.description="Minimal PHP 8.4 CLI image for CI: PHP, Composer and the extensions a PHP/Laravel test suite needs."
LABEL org.opencontainers.image.source="https://github.com/robmellett/docker"

ENV TZ=UTC
ENV LANG=C.UTF-8

# CI runs a throwaway container, so let Composer run as root and keep its
# cache on tmpfs rather than baking it into the image.
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV COMPOSER_HOME=/tmp/composer
ENV COMPOSER_NO_INTERACTION=1

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Runtime libraries stay; the toolchain needed to compile the extensions is
# installed as a virtual package and removed again in the same layer.
RUN apk add --no-cache \
        ca-certificates \
        git \
        icu-data-full \
        icu-libs \
        libpq \
        libzip \
        unzip \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        icu-dev \
        libpq-dev \
        libzip-dev \
        linux-headers \
    && docker-php-ext-install -j"$(nproc)" \
        bcmath \
        intl \
        pcntl \
        pdo_mysql \
        pdo_pgsql \
        zip \
    && pecl install pcov redis \
    && docker-php-ext-enable pcov redis \
    && apk del --no-network .build-deps \
    && rm -rf /tmp/pear /var/cache/apk/*

COPY php.ini /usr/local/etc/php/conf.d/99-ci.ini

# CI checkouts are frequently owned by a different UID than the container user,
# which otherwise trips Git's "dubious ownership" guard.
RUN git config --global --add safe.directory '*'

WORKDIR /app

CMD ["php", "-v"]
