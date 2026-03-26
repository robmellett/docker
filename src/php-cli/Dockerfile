FROM php:8.4-cli

ARG NODE_VERSION=24

ENV TZ=UTC
ENV LANG=C.UTF-8

RUN apt-get update \
    && apt-get install -y curl ca-certificates zip unzip git \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "copy('https://composer.github.io/installer.sig', 'composer-installer.sig');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') !== trim(file_get_contents('composer-installer.sig'))) { unlink('composer-setup.php'); unlink('composer-installer.sig'); throw new Exception('Invalid installer signature'); }" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm composer-setup.php composer-installer.sig

WORKDIR /app

CMD ["composer/composer"]
