FROM ubuntu:16.04

MAINTAINER  pangxiaobo <10846295@qq.com>

RUN apt-get update -y \
    && apt-get install -y language-pack-en-base python-software-properties \
    && apt-get install -y software-properties-common \
    && LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php \
    && apt-get update -y \
    && apt-get install -y  \
    g++ \
    gnutls-bin \
    build-essential \
    tzdata \
    curl \
    bison \
    re2c \
    nginx-full \
    php7.2 \
    php-pear \
    php7.2-fpm \
    php7.2-cgi \
    php7.2-bz2 \
    php7.2-igbinary \
    php7.2-bcmath \
    php7.2-calendar \
    php7.2-cli \
    php7.2-ctype \
    php7.2-curl \
    php7.2-dev \
    php7.2-gettext \
    php7.2-gd \
    php7.2-intl \
    php7.2-imap \
    php7.2-ldap \
    php7.2-mbstring \
    php7.2-mysql \
    php7.2-pdo \
    php7.2-pgsql \
    php7.2-redis \
    php7.2-soap \
    php7.2-sqlite3 \
    php7.2-ssh2 \
    php7.2-zip \
    php7.2-json \
    php7.2-xml \
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
    && echo extension=inotify.so >> /etc/php/7.2/mods-available/inotify.ini \
    && ln -s /etc/php/7.2/mods-available/inotify.ini /etc/php/7.2/cli/conf.d/inotify.ini \
    && ln -s /etc/php/7.2/mods-available/inotify.ini /etc/php/7.2/fpm/conf.d/inotify.ini \
    && pecl install ds \
    && echo extension=ds.so >> /etc/php/7.2/mods-available/ds.ini \
    && ln -s /etc/php/7.2/mods-available/ds.ini /etc/php/7.2/cli/conf.d/ds.ini \
    && ln -s /etc/php/7.2/mods-available/ds.ini /etc/php/7.2/fpm/conf.d/ds.ini \
    && pecl install yaf \
    && echo extension=yaf.so >> /etc/php/7.2/mods-available/yaf.ini \
    && ln -s /etc/php/7.2/mods-available/yaf.ini /etc/php/7.2/cli/conf.d/yaf.ini \
    && ln -s /etc/php/7.2/mods-available/yaf.ini /etc/php/7.2/fpm/conf.d/yaf.ini \
    && cd /home && rm -rf temp && mkdir temp && cd temp \
    && wget https://github.com/redis/hiredis/archive/v0.13.3.tar.gz \
    https://github.com/phpredis/phpredis/archive/3.1.3.tar.gz \
    https://github.com/swoole/swoole-src/archive/v4.2.5.tar.gz \
    && tar -xzvf 3.1.3.tar.gz \
    && tar -xzvf v0.13.3.tar.gz \
    && tar -xzvf v4.2.5.tar.gz \
    && cd /home/temp/hiredis-0.13.3 \
    && make -j && make install && ldconfig \
    && cd /home/temp/phpredis-3.1.3 \
    && phpize \
    && ./configure --enable-redis-igbinary \
    && make &&  make install \
	&& cd /home/temp/swoole-src-4.2.5 \
	&& phpize && ./configure --enable-async-redis  --enable-openssl --enable-mysqlnd \
	&& make -j$(nproc) \ 
    && make install \
    && echo extension=swoole.so >> /etc/php/7.2/mods-available/swoole.ini \
    && ln -s /etc/php/7.2/mods-available/swoole.ini /etc/php/7.2/cli/conf.d/swoole.ini \
    && ln -s /etc/php/7.2/mods-available/swoole.ini /etc/php/7.2/fpm/conf.d/swoole.ini \
    && wget https://github.com/phalcon/cphalcon/archive/v3.3.2.tar.gz \
    && tar -zxvf v3.3.2.tar.gz \
    && cd cphalcon-3.3.2/build \
    && sudo ./install \
    && echo extension=phalcon.so >> /etc/php/7.2/mods-available/phalcon.ini \
    && ln -s /etc/php/7.2/mods-available/phalcon.ini /etc/php/7.2/cli/conf.d/phalcon.ini \
    && ln -s /etc/php/7.2/mods-available/phalcon.ini /etc/php/7.2/fpm/conf.d/phalcon.ini \
    && mkdir -p /var/log/supervisor \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* \
    && useradd admin \
    && echo 'root:lims123' | chpasswd \
    && /etc/init.d/ssh restart \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' > /etc/timezone \
    && mkdir -p /var/www/app

COPY sshd_config /etc/ssh/
COPY src/info.php /var/www/app/info.php
COPY build/.bashrc /root/.bashrc
COPY build/nginx.conf /etc/nginx/sites-enabled/default
COPY build/app.conf /etc/nginx/conf.d/app.conf
COPY build/php.ini /etc/php/7.2/fpm/php.ini
COPY start.sh /root/start.sh

#WORKDIR /root

CMD ["/usr/sbin/sshd", "-D"]
# start-up nginx and fpm and ssh
#CMD chmod +x start.sh && \
#    ./start.sh && \
#    /usr/sbin/sshd -D