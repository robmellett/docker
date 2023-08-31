#!/bin/bash

cd laravel-sail

ls -la

cp runtimes/7.4/* src/php74

cp runtimes/8.0/* src/php80

cp runtimes/8.1/* src/php81

rm -rf cd laravel-sail
