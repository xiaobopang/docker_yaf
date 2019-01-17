#!/usr/bin/env bash

set -e

/usr/sbin/service php7.0-fpm start
/usr/sbin/service nginx start
tail -f /dev/null

exec "$@"