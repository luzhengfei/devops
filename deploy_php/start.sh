#!/bin/bash

# 启动 PHP-FPM
php-fpm &

# 启动 nginx
nginx -g "daemon off;"