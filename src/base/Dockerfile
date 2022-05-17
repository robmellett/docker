FROM phusion/baseimage:focal-1.0.0
LABEL Rob Mellett <dev@robmellett.com>

# Ensure UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Set Timezone to UTC
RUN ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# Set Timezone to Melbourne, Australia
# RUN ln -sf /usr/share/zoneinfo/Australia/Melbourne /etc/localtime

# Add New User to run apps under
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 ubuntu
RUN usermod -aG www-data ubuntu

# Install Recommended Packages. 
RUN apt-get update \
  && apt-get -q -y install \ 
  rsync curl wget zip unzip git htop lnav vim build-essential make libpng-dev pngquant unattended-upgrades

# Node
RUN curl --silent --location https://deb.nodesource.com/setup_16.x | bash - && apt-get update
RUN apt-get -q -y install nodejs

# Yarn
RUN wget -qO - https://raw.githubusercontent.com/yarnpkg/releases/gh-pages/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get -q -y update && apt-get -q -y install yarn

# Use baseimage-docker's init system.
# https://github.com/phusion/baseimage-docker
CMD ["/sbin/my_init"]

# Clean up APT when done to minimise filesize.
RUN apt-get -q -y clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set working directory to the project
WORKDIR /var/www/html