FROM robmellett/base:latest@sha256:7ec47e2ca32b16849b6a7f72e861e93427f08b47c84ad3e48ea6a1cce4215f0e
LABEL Rob Mellett <dev@robmellett.com>

RUN curl -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | bash

# Use baseimage-docker's init system.
# https://github.com/phusion/baseimage-docker
CMD ["/sbin/my_init"]