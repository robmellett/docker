FROM robmellett/base:latest
LABEL Rob Mellett <dev@robmellett.com>

RUN curl -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | bash

# Use baseimage-docker's init system.
# https://github.com/phusion/baseimage-docker
CMD ["/sbin/my_init"]