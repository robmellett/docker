FROM robmellett/base:latest
LABEL Rob Mellett <dev@robmellett.com>

# Environmental Configuration
ENV XDEBUG_REMOTE_ENABLE=${XDEBUG_REMOTE_ENABLE}
ENV XDEBUG_REMOTE_AUTOSTART=${XDEBUG_REMOTE_AUTOSTART}
ENV XDEBUG_REMOTE_CONNECT_BACK=${XDEBUG_REMOTE_CONNECT_BACK}
ENV XDEBUG_HOST=${XDEBUG_HOST}
ENV XDEBUG_REMOTE_PORT=${XDEBUG_REMOTE_PORT}
ENV XDEBUG_IDEKEY=${XDEBUG_IDEKEY}

#
# Install
#

# Install Recommended Packages
RUN apt-get update \
  && apt-get -q -y install supervisor sqlite3

# Install Prometheus Monitoring
RUN curl https://s3-eu-west-1.amazonaws.com/deb.robustperception.io/41EFC99D.gpg | apt-key add -
RUN apt-get update && apt-get -q -y install prometheus-node-exporter

# Install Nginx
RUN apt-get update \
    && apt-get -q -y install software-properties-common \
    && apt-add-repository ppa:nginx/development \
    && apt-get -q -y update \
    && apt-get -q -y install nginx-full

# Install PHP
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php && apt-get update
RUN apt-get -q -y install \
    php7.4 \
    php7.4-fpm \
    php7.4-bcmath \
    php7.4-cli \
    php7.4-common \
    php7.4-curl \
    php7.4-dev \
    php7.4-gd \
    php7.4-imap \
    php7.4-intl \
    php7.4-intl \
    php7.4-json \
    php7.4-mbstring \
    php7.4-mbstring \
    php7.4-mysql \
    php7.4-pgsql \
    php7.4-soap \
    php7.4-sqlite \
    php7.4-xml \
    php7.4-xml \
    php7.4-zip \
    php-mysql \
    php-curl \
    php-zip \
    php-xdebug \
    php-memcached \
    php-redis
RUN command -v php

# Install Composer
RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

#
# Configuration
#

# Supervisor Config
COPY src/supervisor/supervisord.conf /etc/supervisor/supervisord.conf
COPY src/supervisor/conf.d/*.conf /etc/supervisor/conf.d-available/

# Confd Config
COPY src/confd/templates /etc/confd/templates
COPY src/confd/conf.d /etc/confd/conf.d

# Nginx Config
ADD src/nginx/nginx.conf /etc/nginx/nginx.conf
ADD src/nginx/default.conf /etc/nginx/sites-available/default
ADD src/nginx/default-production.conf /etc/nginx/sites-available/default-production
ADD src/nginx/self-signed.conf /etc/nginx/snippets/self-signed.conf
ADD src/nginx/ssl-params.conf /etc/nginx/snippets/ssl-params.conf

# PHP Config
COPY src/php/php.ini /etc/php/7.4/cli/php.ini
COPY src/php/xdebug.ini /etc/php/7.4/mods-available/xdebug.ini
COPY src/php/xdebug.ini /etc/php/7.4/mods-available/xdebug.ini.original
COPY src/php/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY src/php/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf

RUN mkdir -p /var/log/xdebug \
  && touch /var/log/xdebug/xdebug.log \
  && chmod 775 /var/log/xdebug/xdebug.log

# Configure User Aliases
COPY src/bash/bashrc /home/ubuntu/.bashrc

# Start Service Scripts
RUN mkdir -p /etc/my_init.d
COPY src/services/php.sh /etc/my_init.d/php.sh
COPY src/services/setup-web.sh /etc/my_init.d/setup
COPY src/services/ssh.sh /etc/my_init.d/ssh.sh
COPY src/services/xdebug.sh /usr/sbin/xdebug.sh
COPY src/ssl/ssl.sh /etc/my_init.d/ssl.sh

RUN chmod +x \
  /etc/my_init.d/php.sh \
  /etc/my_init.d/setup \
  /etc/my_init.d/ssh.sh \
  /etc/my_init.d/ssl.sh \
  /usr/local/bin/confd \
  /usr/sbin/xdebug.sh

# Create SSL Certs
RUN /etc/my_init.d/ssl.sh

# Configure SSH
RUN rm -f /etc/service/sshd/down
COPY src/ssh/docker-dev.pub /tmp/docker-dev.pub
RUN cat /tmp/docker-dev.pub >> /root/.ssh/authorized_keys 
# RUN cat /tmp/docker-dev.pub >> /home/ubuntu/.ssh/authorized_keys && rm -f /tmp/docker-dev.pub

# Set Permissions and make sure www-data owns the directory
RUN chown -R ubuntu:www-data /var/www/html

# Expose the Logs to Docker
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && ln -sf /dev/stdout /var/log/php7.4-fpm.log

# Use baseimage-docker's init system.
# https://github.com/phusion/baseimage-docker
CMD ["/sbin/my_init"]

# Clean up APT when done to minimise filesize.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set working directory to the project
WORKDIR /var/www/html

# Expose Ports for Web/HTTPS & Prometheus node_exporter
EXPOSE 80 443 9100
