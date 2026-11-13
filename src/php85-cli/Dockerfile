FROM php:8.5-cli@sha256:50956f094e90a716d43bea28087d447555ad80510e386ab8c9c10d8c70d781a9

ARG NODE_VERSION=24

ENV TZ=UTC
ENV LANG=C.UTF-8

# @See https://github.com/composer/composer/issues/9150
ENV COMPOSER_CACHE_READ_ONLY=1
ENV COMPOSER_HOME=/usr/local/share/composer

# Install some additional packages and the Laravel
# installer uses them when creating a new project.
# openssh-client lets Composer pull private repositories over SSH.
RUN apt-get update \
    && apt-get install -y curl ca-certificates zip unzip git openssh-client \
       libzip-dev libsqlite3-dev libicu-dev libpq-dev \
    && docker-php-ext-install zip intl pcntl bcmath pdo_mysql pdo_pgsql \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "copy('https://composer.github.io/installer.sig', 'composer-installer.sig');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') !== trim(file_get_contents('composer-installer.sig'))) { unlink('composer-setup.php'); unlink('composer-installer.sig'); throw new Exception('Invalid installer signature'); }" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm composer-setup.php composer-installer.sig

RUN composer global require laravel/installer

ENV PATH="${COMPOSER_HOME}/vendor/bin:${PATH}"

WORKDIR /app

CMD ["php", "-a"]
