!/bin/bash

git clone git@github.com:laravel/sail.git laravel-sail

tree laravel-sail

cp laravel-sail/runtimes/8.1/* ./src/php81
cp laravel-sail/runtimes/8.2/* ./src/php82
cp laravel-sail/runtimes/8.3/* ./src/php83
cp laravel-sail/runtimes/8.4/* ./src/php84

rm -rf laravel-sail