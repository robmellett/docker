#!/bin/bash

git checkout -b 'feature/laravel-sail-upgrade'

git clone https://github.com/laravel/sail temp

cp temp/runtimes/7.4/* src/php74

cp temp/runtimes/8.0/* src/php80

cp temp/runtimes/8.1/* src/php81

rm -rf temp/

git add .

git commit -m 'Laravel Sail Bump'

git push -u origin "feature/laravel-sail-upgrade"
