FROM robmellett/base:latest
LABEL Rob Mellett <dev@robmellett.com>

# Install Recommended Packages
RUN apt-get update \
  && apt-get -q -y install supervisor

# Install Nginx
RUN apt-get update \
  && apt-get -q -y install software-properties-common \
  && apt-add-repository ppa:nginx/development \
  && apt-get -q -y update \
  && apt-get -q -y install nginx-full

# Install PM2 for Node.js Apps
RUN npm install pm2 -g

# Supervisor
# COPY src/supervisor/supervisord.conf /etc/supervisor/supervisord.conf
# COPY src/supervisor/conf.d/*.conf /etc/supervisor/conf.d-available/

# Confd
COPY src/confd/templates /etc/confd/templates
COPY src/confd/conf.d /etc/confd/conf.d

# Nginx Config
ADD src/nginx/nginx.conf /etc/nginx/nginx.conf
ADD src/nginx/default-node.conf /etc/nginx/sites-available/default
ADD src/nginx/self-signed.conf /etc/nginx/snippets/self-signed.conf
ADD src/nginx/ssl-params.conf /etc/nginx/snippets/ssl-params.conf

# Copy Start Service Scripts
RUN mkdir -p /etc/my_init.d
COPY src/services/setup-node.sh /etc/my_init.d/setup
COPY src/ssl/ssl.sh /etc/my_init.d/ssl.sh

RUN chmod +x \
  /etc/my_init.d/setup \
  /usr/local/bin/confd \
  /etc/my_init.d/ssl.sh

# Create SSL Certs
RUN /etc/my_init.d/ssl.sh

RUN chown -R ubuntu:www-data /var/www/html

# Expose the Logs to Docker
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log

# Use baseimage-docker's init system.
# https://github.com/phusion/baseimage-docker
CMD ["/sbin/my_init"]

# Clean up APT when done to minimise filesize.
RUN apt-get -q -y clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set working directory to the project
WORKDIR /var/www/html

# Expose Ports for Web/HTTPS
EXPOSE 80 443