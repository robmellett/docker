### A base Docker image with Ubuntu (18.04), Php (Xdebug), Composer, Nginx, NPM, Yarn, Prometheus Node Exporter

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

- robmellett/lemp:7.4
- robmellett/lemp:7.3
- robmellett/lemp:7.2
- robmellett/lemp:7.1
- robmellett/lemp:7.0
- robmellett/lemp:5.6

## Getting Started
**Option 1**

`composer require robmellett/devops`

`php artisan vendor:publish  --provider="Robmellett\Devops\DevopsServiceProvider"`

And the required files will be copied into your project.


**Option 2**

Copy the following files into your project.

`./src/docker-compose.yml` and `./src/.docker.env.example.` into your project.


## Run the application with:
```
docker-compose up --build
```

## Connect to application with:
```
docker exec -it 'acme-app' bash
```

## View site in Chrome
> https://localhost:7000

## SSL Configuration for Local Development
If you would like to use SSL with the docker container, it generates a self signed certificate.  You will see an annoying error message everytime you view `https://localhost:7000`

You can use [`mkcert`](https://github.com/FiloSottile/mkcert) on your local/host machine, and override the docker certificates with the following.

- Install mkcert on your host machine
- Run `mkcert install` on your host machine
- Generate a certificate for localhost with the following command:

`mkcert -key-file '~/.mkcert/docker-selfsigned-key.pem' -cert-file '~/.mkcert/docker-selfsigned.pem' localhost 127.0.0.1 ::1`

Within your `docker-compose.yml` file, you can now override the docker ssl certs with the following:

```yml
acme-app:
  image: robmellett/lemp:7.4
  hostname: acme-app
  container_name: acme-app
  dns: 8.8.8.8
  env_file:
    - .docker.env
  environment:
    CONTAINER_ROLE: app # [app, horizon, queue, scheduler]
    APP_ENV: local # [local, staging, production]
  volumes:
    - ../app:/var/www/html
    - ~/.mkcert/docker-selfsigned.pem:/etc/nginx/ssl/nginx-selfsigned.crt # Override default SSL Cert
    - ~/.mkcert/docker-selfsigned-key.pem:/etc/nginx/ssl/nginx-selfsigned.key # Override default SSL keys
  networks:
    - acme
  ports:
    - 7000:80 # Web
    - 443:443 # Https
  tty: true
```

## Application has one of 3 website settings: (.docker.env)
```
app
queue
scheduler
```

## Connecting via XDebug
Make sure the website is in `/var/www/html/`, Nginx is configured to serve pages from `/var/www/html/public`.

Update values in the `.docker.env` file
- `XDEBUG_HOST` must be equal to the IP of your local host machine. Run `ip a` to see it, not the Docker IP.

## VSCode with XDebug
Create a `.vscode/launch.json` with the following.
```
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Listen for XDebug",
      "type": "php",
      "request": "launch",
      "port": 9000,
      "log": false,
      "externalConsole": false,
      "pathMappings": {
          "/var/www/html": "${workspaceRoot}",
      },
      "ignore": ["**/vendor/**/*.php"]
    }
  ]
}
```

## PHPStorm with XDebug

1. Configure PHPStorm XDebug Configuration Settings
![PHPStorm XDebug Settings 1](wiki/xdebug-server-settings-2.png "PHPStorm XDebug Settings 2")

2. Configure PHPStorm DBGp Proxy Settings.  Make sure `IP Address` matches your local machine IP
![PHPStorm XDebug Settings 2](wiki/xdebug-server-settings-4.png "PHPStorm XDebug Settings 1")

3. Configure Project Path Mappings
![PHPStorm XDebug Settings 3](wiki/xdebug-server-settings-1.png "PHPStorm XDebug Settings 1")

4. Set a breakpoint in Phpstorm and you should be good to go

### Troubleshooting XDebug
`cat /etc/php/7.4/mods-available/xdebug.ini`

`cat /tmp/xdebug_remote.log`

`service php7.4-fpm reload`

### XDebug Resources

- https://serversforhackers.com/c/getting-xdebug-working
- https://www.jetbrains.com/help/phpstorm/troubleshooting-php-debugging.html
- https://www.jetbrains.com/help/phpstorm/configuring-xdebug.html
- https://www.jetbrains.com/help/phpstorm/creating-a-php-debug-server-configuration.html

## Connecting to a Docker Database Instance (Mysql/Postgres)

When connecting to the docker database you can use the settings provided in the `docker-compose.yml` file.

`localhost` and port `3306`, these will be mapped across to the docker images.

![Datagrip Server Settings 1](wiki/datagrip-server-settings-2.png "Datagrip Server Settings 1")

## If you need to use MySQL instead of Postgres, you can configure `docker-compose.yml` with the following:

```yml
acme-database:
  image: mysql:latest
  hostname: acme-database
  container_name: acme-database
  command: --default-authentication-plugin=mysql_native_password
  networks:
    - acme
  ports:
    - 3306:3306
  volumes:
    - acme-db-data:/var/lib/mysql
  environment:
    - MYSQL_DATABASE=laravel
    - MYSQL_USER=laravel
    - MYSQL_PASSWORD=secret
    - MYSQL_ROOT_PASSWORD=root
```

## Redis
Configure redis as the default connection in `.env`.

`composer require predis/predis`

In `config/database.php` you might need to change:

`'client' => env('REDIS_CLIENT', 'redis'),`

to

`'client' => env('REDIS_CLIENT', 'predis'),`

`QUEUE_CONNECTION=redis`

Or for a specific job via:

```PHP
App\Jobs\ProcessJobExample::dispatch()->onConnection('redis');
```

Sample Redis Config

```env
# Configure Laravel to work with Docker containers.
# Use in laravel .env file

DB_CONNECTION=mysql
DB_HOST=docker-database
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=laravel
DB_PASSWORD=secret

REDIS_HOST=docker-redis
REDIS_PASSWORD=null
REDIS_PORT=6379

# To set Redis as default queue connection
QUEUE_CONNECTION=redis
```

### Supervisor Services
Documention:
- https://medium.com/@rohit_shirke/configuring-supervisor-for-laravel-queues-81e555e550c6

```
supervisorctl -c /etc/supervisor/supervisord.conf
```

## Testing

Add this to your routes file

```php
<?php

use Carbon\Carbon;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/job', function () {
    # Test the Job Dispatcher Works via Redis.
    # Will print line to log file
    App\Jobs\ProcessJobExample::dispatch();
});

Route::get('cache', function () {
    $cached = Cache::remember('users', 10, function () {
        return Carbon::now();
    });

    return response()->json([
        "cached" =>  $cached->diffForHumans(),
        "now" => Carbon::now()->diffForHumans()
    ]);
});

```

Then test with
`docker-compose up`

### Alias Commands

While you are connected, you can access common laravel commands via their alisas below.

| Alias | Description |
|:-:|:-:|
| `artisan`  | `php artisan`  |

## Database

| Alias | Description |
|:-:|:-:|
| `pam`  |  `php artisan migrate` |
| `pamf`  |  `php artisan migrate:fresh` |
| `pamfs`  |  `php artisan migrate:fresh --seed` |
| `pamr`  |  `php artisan migrate:rollback` |
| `pads`  |  `php artisan db:seed` |

## Makers

| Alias | Description |
|:-:|:-:|
| `pamm`  |  `php artisan make:model` |
| `pamc`  |  `php artisan make:controller` |
| `pams`  |  `php artisan make:seeder` |
| `pamt`  |  `php artisan make:test` |
| `pamfa`  |  `php artisan make:factory` |
| `pamp`  |  `php artisan make:policy` |
| `pame`  |  `php artisan make:event` |
| `pamj`  |  `php artisan make:job` |
| `paml`  |  `php artisan make:listener` |
| `pamn`  |  `php artisan make:notification` |

## Clears

| Alias | Description |
|:-:|:-:|
| `pacac`  |  `php artisan cache:clear` |
| `pacoc`  |  `php artisan config:clear` |
| `pavic`  |  `php artisan view:clear` |
| `paroc`  |  `php artisan route:clear` |

## Queues

| Alias | Description |
|:-:|:-:|
| `paqf`  |  `php artisan queue:failed` |
| `paqft`  |  `php artisan queue:failed-table` |
| `paql`  |  `php artisan queue:listen` |
| `paqr`  |  `php artisan queue:retry` |
| `paqt`  |  `php artisan queue:table` |
| `paqw`  |  `php artisan queue:work` |

### Ngrok

If you need to open your machine to the internet for the internet (like testing webhooks). You can do so with Ngrok.

```sh
ngrok http https://localhost:7000
```
