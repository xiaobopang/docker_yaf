#!/bin/bash

/usr/sbin/service php7.0-fpm start
/usr/sbin/service nginx start
/usr/sbin/sshd -D
tail -f /dev/null