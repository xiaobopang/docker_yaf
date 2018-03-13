FROM php:7.1.6-fpm

MAINTAINER  peterpang <10846295@qq.com>

COPY sshd_config /etc/ssh/

RUN docker-php-source extract && apt-get update  && apt-get -y --no-install-recommends install \
        supervisor \
        nginx \
        vim \
        nano \
        docker-php-ext-install \
        pdo_mysql \
        opcache

COPY build/.bashrc /root/.bashrc
COPY build/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY build/nginx.conf /etc/nginx/sites-enabled/default
COPY build/php.ini /etc/php/7.1/fpm/php.ini

ADD src /var/www/public/

EXPOSE 80 22

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf","/usr/sbin/sshd", "-D"]