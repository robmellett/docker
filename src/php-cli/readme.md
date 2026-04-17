To keep things lightweight on Arch, you can use Docker’s rootless mode or Podman; below is a straightforward Docker-based approach (works just as well with Podman by replacing `docker` with `podman` in the commands).

1. **Install Docker and enable the service**

   ```bash
   sudo pacman -S docker
   sudo systemctl enable --now docker.service
   sudo usermod -aG docker "$USER"
   newgrp docker   # refresh your shell session so group membership takes effect
   ```

2. **Create a minimal PHP+Composer image**

   Put this `Dockerfile` somewhere in your project:

   ```Dockerfile#L1-11
   FROM php:8.3-cli-alpine

   # Install Composer
   ENV COMPOSER_ALLOW_SUPERUSER=1 \
       COMPOSER_HOME=/tmp/composer

   RUN apk add --no-cache git unzip icu-dev \
       && docker-php-ext-install intl \
       && curl -sS https://getcomposer.org/installer \
          | php -- --install-dir=/usr/local/bin --filename=composer \
       && composer --version

   WORKDIR /app
   ```

   This uses `php:8.3-cli-alpine`, adds `intl` (commonly required), installs Composer globally, and sets `/app` as the working directory.

3. **Build the image**

   ```bash
   docker build -t php-cli:latest -f Dockerfile .
   ```

4. **Run Composer or vendor scripts against your project**

   From the root of your PHP project, mount the current directory into `/app` and execute whatever you need:

   ```bash
   docker run --rm -it -v "$(pwd)":/app php-cli:latest composer install
   docker run --rm -it -v "$(pwd)":/app php-cli:latest composer run-script test
   docker run --rm -it -v "$(pwd)":/app php-cli:latest php vendor/bin/phpunit
   ```

   The `--rm` flag keeps containers ephemeral, and the bind mount ensures your project files stay on the host while the container handles dependencies.

5. **Optional: define helper scripts**

   If you want a shorthand, create a wrapper in your project:

   ```run-composer.sh#L1-6
   #!/bin/sh

   docker run --rm -it \
     -v "$(pwd)":/app \
     php-cli:latest "$@"
   ```

   Make it executable (`chmod +x run-composer.sh`) and then run `./run-composer.sh composer install`, `./run-composer.sh php vendor/bin/phpunit`, and so on.

That’s it: a minimal containerized PHP toolchain on Arch that runs Composer and any `vendor/bin/*` scripts without polluting your host system.
