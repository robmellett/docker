### A base Docker image with Ubuntu (18.04), Php (Xdebug), Composer, Nginx, NPM, Yarn

## Base Image 
> http://phusion.github.io/baseimage-docker/#intro

Baseimage-docker only consumes 8.3 MB RAM and is much more powerful than Busybox or Alpine. See why below.

Baseimage-docker is a special Docker image that is configured for correct use within Docker containers. It is Ubuntu, plus:

- Modifications for Docker-friendliness.
- Administration tools that are especially useful in the context of Docker.
- Mechanisms for easily running multiple processes, without violating the Docker philosophy.
- You can use it as a base for your own Docker images.

## Docker Versions
You can use the following docker images

# Base
- robmellett/base

## PHP
- robmellett/php-81
- robmellett/php-80
- robmellett/php-74

## Hasura CLI
- robmellett/hasura-cli