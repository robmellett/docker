# Docker Versions

You can use the following docker images

## Base

These images are based on [Baseimage-docker](https://github.com/phusion/baseimage-docker) which only consumes 8.3 MB RAM and is much more powerful than Busybox or Alpine. See why below.

Baseimage-docker is a special Docker image that is configured for correct use within Docker containers. It is Ubuntu, plus:

- Modifications for Docker-friendliness.
- Administration tools that are especially useful in the context of Docker.
- Mechanisms for easily running multiple processes, without violating the Docker philosophy.
- You can use it as a base for your own Docker images.
- [So you're building a Docker image. What might be wrong with it?
  ](https://phusion.github.io/baseimage-docker)

You can use the image with:

- `robmellett/base`

## PHP

These are based on the [Laravel Sail ](https://laravel.com/docs/8.x/sail) images provided by Taylor Otwell.

You can use the image with:

- `robmellett/php-84`
- `robmellett/php-83`
- `robmellett/php-82`
- `robmellett/php-81`
- `robmellett/php-80` (No Longer maintained)
- `robmellett/php-74` (No Longer maintained)

You can automate the Laravel sail upgrade by running the following command:

This will allow you to pull the latest docker runtime updates from [Laravel Sail](https://github.com/laravel/sail).

```shell
sh src/scripts/update-sail.sh
```

## Hasura CLI

You can use the image with:

This will download and install the [Hasura CLI](https://hasura.io/docs/2.0/hasura-cli/overview/).

- `robmellett/hasura-cli`
