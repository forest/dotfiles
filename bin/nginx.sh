#!/usr/bin/env bash

# From http://freelancing-gods.com/posts/script_nginx

echo "Starting Phusion Passenger via Nginx in `pwd`:"

# Make directories if needed
[ ! -d `pwd`/tmp ] && mkdir `pwd`/tmp
[ ! -d `pwd`/log ] && mkdir `pwd`/log

/usr/local/nginx/sbin/nginx -p `pwd`/ -c ~/.dotfiles/nginx-dir.conf -g "error_log `pwd`/log/nginx.error.log; pid `pwd`/log/nginx.pid;";
