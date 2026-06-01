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

### How these images stay up to date

The PHP images are kept in sync with upstream [Laravel Sail](https://github.com/laravel/sail) automatically — there's no need to bump them by hand:

1. **Weekly Sail sync (Wednesdays).** `.github/workflows/automatic-upgrades.yml` runs every Wednesday at 00:00 UTC (`0 0 * * 3`). It checks out `laravel/sail`, copies each `runtimes/8.x/*` directory over the matching `src/php8x/` folder in this repo, and opens a PR titled *"[Weekly] Laravel Sail Docker Image Update"* via [`peter-evans/create-pull-request`](https://github.com/peter-evans/create-pull-request). Review the diff and merge if it looks sane.
2. **Image rebuild on merge.** Merging that PR into `master` triggers `.github/workflows/build-php.yml`, which builds the `php-81`…`php-85` images in a matrix and pushes them to Docker Hub as `robmellett/php-<version>:latest`.
3. **Weekly rebuild safety net (Sundays).** `build-php.yml` also runs on its own schedule (`0 0 * * 0`) every Sunday, so the published images get a fresh rebuild against the latest base layers even if no Sail PR landed that week.

If you ever need to run the sync manually — e.g. to test a Sail change locally before the Wednesday cron — there's a script that mirrors what the workflow does:

```shell
sh src/scripts/update-sail.sh
```

If you need to install a Laravel project's dependencies without php / composer on your machine. The following command will assist you.

```shell
docker run --rm \
    -u "$(id -u):$(id -g)" \
    -v $(pwd):/var/www/html \
    -w /var/www/html \
    laravelsail/php84-composer:latest \
    composer install --ignore-platform-reqs
```    

## PHP CLI

A lightweight `php:8.5-cli` image bundled with Composer, intended for running `php` and `composer` commands against a project directory without installing PHP on the host.

- **No host PHP install.** No Homebrew/apt PHP, no `php.ini` tweaking, no PECL extensions to compile. Uninstall by deleting the image.
- **Per-project PHP versions.** Swap `robmellett/php-85-cli` for a different tag per project — no `phpenv`/`asdf` juggling.
- **Reproducible across machines.** The image is identical on your laptop, a colleague's machine, and CI. "Works on my machine" stops being a PHP-version problem.
- **Composer included.** No separate Composer install or signature-verification ritual on every host.
- **Cheap and disposable.** `--rm` means each invocation is ephemeral — nothing leaks onto the host.
- **Matches CI.** The same image you run locally is what runs in GitHub Actions, so local passes mean CI passes (for PHP-version reasons, at least).

The aliases below hide the `docker run` ceremony so it feels exactly like a native install.

You can use the image with:

- `robmellett/php-85-cli`


### Usage

Run a one-off command by mounting the project into `/app`:

```shell
docker run --rm -it \
    --user "$(id -u):$(id -g)" \
    -v "$(pwd)":/app \
    robmellett/php-85-cli:latest composer install
```

### Installing Laravel

The image bundles `laravel/installer`, so you can scaffold a new project without installing anything on your host:

```shell
docker run --rm -it \
    --user "$(id -u):$(id -g)" \
    -v "$(pwd)":/app \
    robmellett/php-85-cli:latest \
    laravel new my-app
```

This creates a `my-app/` directory inside your current working directory. The interactive installer will prompt for starter kit preferences, testing framework, and other options.

Alternatively, install via Composer directly:

```shell
docker run --rm -it \
    --user "$(id -u):$(id -g)" \
    -v "$(pwd)":/app \
    robmellett/php-85-cli:latest \
    composer create-project laravel/laravel my-app
```

Once the project is created, `cd` into it and use the [shell aliases](#shell-aliases) below to run `php` and `composer` commands as if they were installed natively.

### Shell aliases

To make the container feel like a locally-installed PHP toolchain, add a wrapper function and aliases to your `~/.zshrc` (or `~/.bashrc`):

```shell
phpcli() {
  docker run --rm -it \
    --user "$(id -u):$(id -g)" \
    -v "$(pwd)":/app \
    -w /app \
    robmellett/php-85-cli:latest "$@"
}

alias php='phpcli php'
alias composer='phpcli composer'
alias phpunit='phpcli php vendor/bin/phpunit'
alias pest='phpcli php vendor/bin/pest'
```

Reload your shell (`source ~/.zshrc`) and then `php -v`, `composer install`, `phpunit`, etc. all run inside the container against the current working directory. Matching the container user to your host UID/GID keeps file ownership correct and avoids Git's "dubious ownership" warnings.

## Hasura CLI

You can use the image with:

This will download and install the [Hasura CLI](https://hasura.io/docs/2.0/hasura-cli/overview/).

- `robmellett/hasura-cli`

## Docker

You can build docker images locally by running the following.

```
docker build -t robmellett/<name-of-container>:latest .
```
