#!/bin/bash

cd laravel-sail

cp runtimes/7.4/* src/php74

cp runtimes/8.0/* src/php80

cp runtimes/8.1/* src/php81

rm -rf cd laravel-sail

# git add .

# git commit -m 'Laravel Sail Bump'

# git push -u origin "feature/laravel-sail-upgrade"

# # git request-pull "origin/master" "feature/laravel-sail-upgrade"
