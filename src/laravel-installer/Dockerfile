FROM php:8.4-cli

ENV TZ=UTC
ENV LANG=C.UTF-8
ENV COMPOSER_CACHE_READ_ONLY=1
ENV COMPOSER_HOME=/usr/local/share/composer

RUN apt-get update \
    && apt-get install -y curl ca-certificates zip unzip git libzip-dev libsqlite3-dev \
    && docker-php-ext-install zip \
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

ENTRYPOINT ["laravel"]
CMD ["--help"]
