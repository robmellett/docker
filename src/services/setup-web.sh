#!/usr/bin/env bash

set -e

role=${CONTAINER_ROLE:-app}
env=${APP_ENV:-production}
xdebug_enabled=${XDEBUG_ENABLED}

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

    # Clear previous logs
    echo > "/var/www/html/storage/logs/laravel.log"

    if [ "$xdebug_enabled" == "true" ]; then
        # Configure XDebug Settings from the docker .env variables
        sh /usr/sbin/xdebug.sh
    fi

    if [ ! -z "$DEV_UID" ]; then
        echo "Changing www-data UID to $DEV_UID"
        echo "The UID should only be changed in development environments."
        usermod -u $DEV_UID www-data
    fi
fi

confd -onetime -backend env

# Configure Docker as App
if [ "$role" = "app" ]; then

    echo ">> Setting role to: [app]"
    ln -sf /etc/supervisor/conf.d-available/app.conf /etc/supervisor/conf.d/app.conf

# Configure Docker as Queue
elif [ "$role" = "queue" ]; then

    echo ">> Setting role to: [queue]"
    ln -sf /etc/supervisor/conf.d-available/queue.conf /etc/supervisor/conf.d/queue.conf

# Configure Docker as Horizon
elif [ "$role" = "horizon" ]; then

    echo ">> Setting role to: [queue]"
    ln -sf /etc/supervisor/conf.d-available/horizon.conf /etc/supervisor/conf.d/horizon.conf


# Configure Docker as Scheduler
elif [ "$role" = "scheduler" ]; then

    echo ">> Setting role to: [scheduler]"
    ln -sf /etc/supervisor/conf.d-available/scheduler.conf /etc/supervisor/conf.d/scheduler.conf

else
    echo ">> Could not match the container role \"$role\""
    exit 1
fi

# Setup tinker directory
# mkdir -p /home/ubuntu/.config
# chown -R ubuntu: /home/ubuntu/
# chown -R ubuntu: /home/ubuntu/.config

# Docker needs this line before it can run
# the PHP-FPM service
mkdir -p /run/php

# Start Supervisor Monitoring
exec supervisord -c /etc/supervisor/supervisord.conf
