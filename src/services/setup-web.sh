#!/usr/bin/env bash

set -e

role=${CONTAINER_ROLE:-app}
env=${APP_ENV:-production}

if [ "$env" != "local" ]; then

    # echo ">>> Caching configuration..."
    # (cd /var/www/html && php artisan config:cache && php artisan route:cache)

    echo ">>> Set Production Nginx"
    cp /etc/nginx/sites-available/default-production /etc/nginx/sites-available/default.conf

    echo ">>> Removing Xdebug..."
    rm -rf /etc/php/7.4/mods-available/xdebug.ini

    echo ">> Configuring Prometheus"
    ln -sf /etc/supervisor/conf.d-available/prometheus.conf /etc/supervisor/conf.d/prometheus.conf
fi

if [ "$env" == "local" ]; then

    sh /usr/sbin/xdebug.sh

    if [ ! -z "$DEV_UID" ]; then
        echo "Changing www-data UID to $DEV_UID"
        echo "The UID should only be changed in development environments."
        usermod -u $DEV_UID www-data
    fi
fi

confd -onetime -backend env

# App
if [ "$role" = "app" ]; then

    echo ">> Setting role to: [app]"
    ln -sf /etc/supervisor/conf.d-available/app.conf /etc/supervisor/conf.d/app.conf

# Queue
elif [ "$role" = "queue" ]; then

    echo ">> Setting role to: [queue]"
    ln -sf /etc/supervisor/conf.d-available/queue.conf /etc/supervisor/conf.d/queue.conf

# Horizon
elif [ "$role" = "horizon" ]; then

    echo ">> Setting role to: [queue]"
    ln -sf /etc/supervisor/conf.d-available/horizon.conf /etc/supervisor/conf.d/horizon.conf


# Scheduler
elif [ "$role" = "scheduler" ]; then

    echo ">> Setting role to: [scheduler]"
    ln -sf /etc/supervisor/conf.d-available/scheduler.conf /etc/supervisor/conf.d/scheduler.conf

else
    echo ">> Could not match the container role \"$role\""
    exit 1
fi

# Docker needs this line before it can run
# the PHP-FPM service
mkdir -p /run/php

exec supervisord -c /etc/supervisor/supervisord.conf
