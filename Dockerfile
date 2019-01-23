FROM ubuntu:16.04

MAINTAINER  pangxiaobo <10846295@qq.com>

COPY sshd_config /etc/ssh/

RUN apt-get update -y \
    && apt-get install -y language-pack-en-base \
    && apt-get install -y software-properties-common \
    && LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php \
    && apt-get update -y \
    && apt-get install -y  \
    tzdata \
    curl \
    bison \
    re2c \
    nginx-full \
    php7.1 \
    php-pear \
    php7.1-fpm \
    php7.1-cgi \
    php7.1-bz2 \
    php7.1-bcmath \
    php7.1-calendar \
    php7.1-cli \
    php7.1-ctype \
    php7.1-curl \
    php7.1-dev \
    php7.1-geoip \
    php7.1-gettext \
    php7.1-gd \
    php7.1-intl \
    php7.1-imap \
    php7.1-ldap \
    php7.1-mbstring \
    php7.1-mcrypt \
    php7.1-memcached \
    php7.1-mongo \
    php7.1-mysql \
    php7.1-pdo \
    php7.1-pgsql \
    php7.1-redis \
    php7.1-soap \
    php7.1-sqlite3 \
    php7.1-ssh2 \
    php7.1-zip \
    php7.1-xmlrpc \
    php7.1-xsl \
    zlib1g-dev \
    vim \
    libssl-dev \
    unzip \
    wget \
    git \
    imagemagick \
    zlib1g-dev \
    libfreetype6-dev \
    libxpm-dev \
    libjpeg-dev \
    libpng-dev \
    make \
    sudo \
    net-tools \
    openssh-server \
    subversion \
    supervisor \
    --no-install-recommends \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && pecl install inotify \
    && echo extension=inotify.so >> /etc/php/7.1/mods-available/inotify.ini \
    && ln -s /etc/php/7.1/mods-available/inotify.ini /etc/php/7.1/cli/conf.d/inotify.ini \
    && ln -s /etc/php/7.1/mods-available/inotify.ini /etc/php/7.1/fpm/conf.d/inotify.ini \
    && pecl install ds \
    && echo extension=ds.so >> /etc/php/7.1/mods-available/ds.ini \
    && ln -s /etc/php/7.1/mods-available/ds.ini /etc/php/7.1/cli/conf.d/ds.ini \
    && ln -s /etc/php/7.1/mods-available/ds.ini /etc/php/7.1/fpm/conf.d/ds.ini \
    && pecl install yaf \
    && echo extension=yaf.so >> /etc/php/7.1/mods-available/yaf.ini \
    && ln -s /etc/php/7.1/mods-available/yaf.ini /etc/php/7.1/cli/conf.d/yaf.ini \
    && ln -s /etc/php/7.1/mods-available/yaf.ini /etc/php/7.1/fpm/conf.d/yaf.ini \
    && cd /home && rm -rf temp && mkdir temp && cd temp \
    && wget https://github.com/redis/hiredis/archive/v0.13.3.tar.gz \
    https://github.com/phpredis/phpredis/archive/3.1.3.tar.gz \
    https://github.com/swoole/swoole-src/archive/v4.2.12.tar.gz \
    https://github.com/phadej/igbinary/archive/1.0.2.tar.gz \
    && tar -xzvf 3.1.3.tar.gz \
    && tar -xzvf v0.13.3.tar.gz \
    && tar -xzvf v4.2.12.tar.gz \
    && tar -xzvf 1.0.2.tar.gz \
    && cd /home/temp/igbinary-1.0.2 \
    && phpize \
    && ./configure CFLAGS="-O2 -g" --enable-igbinary \
    && make && make install \
    && cd /home/temp/hiredis-0.13.3 \
    && make -j && make install && ldconfig \
    && cd /home/temp/phpredis-3.1.3 \
    && phpize \
    && ./configure --enable-redis-igbinary \
    && make &&  make install \
	&& cd /home/temp/swoole-src-4.2.12 \
	&& phpize && ./configure --enable-async-redis  --enable-openssl --enable-mysqlnd && make \
	&& make install \
    && echo extension=swoole.so >> /etc/php/7.1/mods-available/swoole.ini \
    && ln -s /etc/php/7.1/mods-available/swoole.ini /etc/php/7.1/cli/conf.d/swoole.ini \
    && ln -s /etc/php/7.1/mods-available/swoole.ini /etc/php/7.1/fpm/conf.d/swoole.ini \
    && wget https://github.com/phalcon/cphalcon/archive/v3.3.2.tar.gz \
    && tar -zxvf v3.3.2.tar.gz \
    && cd cphalcon-3.3.2/build \
    && sudo ./install \
    && echo extension=phalcon.so >> /etc/php/7.1/mods-available/phalcon.ini \
    && ln -s /etc/php/7.1/mods-available/phalcon.ini /etc/php/7.1/cli/conf.d/phalcon.ini \
    && ln -s /etc/php/7.1/mods-available/phalcon.ini /etc/php/7.1/fpm/conf.d/phalcon.ini \
    && echo extension=igbinary.so >> /etc/php/7.1/mods-available/igbinary.ini \
    && ln -s /etc/php/7.1/mods-available/igbinary.ini /etc/php/7.1/cli/conf.d/igbinary.ini \
    && ln -s /etc/php/7.1/mods-available/igbinary.ini /etc/php/7.1/fpm/conf.d/igbinary.ini \
    && mkdir -p /var/log/supervisor \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* \
    && useradd admin \
    && echo 'root:pang123' | chpasswd \
    && /etc/init.d/ssh restart \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' > /etc/timezone \
    && mkdir -p /var/www/app

COPY src/info.php /var/www/app/info.php
COPY build/.bashrc /root/.bashrc
COPY build/nginx.conf /etc/nginx/sites-enabled/default
COPY build/app.conf /etc/nginx/conf.d/app.conf
COPY build/php.ini /etc/php/7.1/fpm/php.ini
COPY start.sh /root/start.sh
WORKDIR /root

#CMD ["/usr/sbin/sshd", "-D"]
# start-up nginx and fpm and ssh
CMD chmod +x start.sh && \
    ./start.sh && \
    /usr/sbin/sshd -D