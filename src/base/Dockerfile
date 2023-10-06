FROM phusion/baseimage:jammy-1.0.1
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

# Install Recommended Packages
# Clean up APT when done to minimise filesize.
# RUN apt-get update \
#     && apt-get install -y curl ca-certificates zip unzip git \
#     && mkdir -p ~/.gnupg \
#     && chmod 600 ~/.gnupg \
#     && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf \
#     && echo "keyserver hkp://keyserver.ubuntu.com:80" >> ~/.gnupg/dirmngr.conf \
#     && apt-get update \
#     && curl -sLS https://deb.nodesource.com/setup_16.x | bash - \
#     && apt-get install -y nodejs \
#     && npm install -g npm \
#     && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarn.gpg >/dev/null \
#     && echo "deb [signed-by=/usr/share/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
#     && apt-get update \
#     && apt-get install -y yarn \
#     && apt-get -y autoremove \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Use baseimage-docker's init system.
# https://github.com/phusion/baseimage-docker
CMD ["/sbin/my_init"]

# Set working directory to the project
WORKDIR /home/ubuntu