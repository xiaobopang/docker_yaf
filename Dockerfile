FROM ubuntu

MAINTAINER  peterpang <10846295@qq.com>

COPY sshd_config /etc/ssh/

RUN apt update \
    && apt install language-pack-en-base -y && locale-gen en_US.UTF-8 && apt install software-properties-common -y \
    && LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php -y && apt update \
    && apt install -y nginx redis-server zip php7.1 php7.1-cli php7.1-fpm php7.1-gd \
    php7.1-curl php7.1-redis php7.1-mysql php7.1-mbstring php7.1-bcmath php7.1-xml php7.1-zip php7.1-dev \
    php7.1-amqp php7.1-pgsql php7.1-sqlite3 php7.1-memcached php7.1-imap php7.1-soap php7.1-bcmath php7.1-intl php7.1-readline php-xdebug php-pear\
    composer
    
COPY build/.bashrc /root/.bashrc
COPY build/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY build/nginx.conf /etc/nginx/sites-enabled/default
COPY build/php.ini /etc/php/7.1/fpm/php.ini

ADD src /var/www/public/

EXPOSE 80 22

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]