FROM robmellett/base:latest@sha256:9577fcd7abf2d8b3544d2a50039ec48756fe54e37d6db559854ca079cadd7501
LABEL Rob Mellett <dev@robmellett.com>

RUN curl -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | bash

# Use baseimage-docker's init system.
# https://github.com/phusion/baseimage-docker
CMD ["/sbin/my_init"]