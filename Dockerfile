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
    nginx-full \
    php-pear \
    php7.2 \
    php7.2-fpm \
    php7.2-cgi \
    php7.2-bz2 \
    php7.2-bcmath \
    php7.2-calendar \
    php7.2-cli \
    php7.2-ctype \
    php7.2-curl \
    php7.2-dev \
    php7.2-geoip \
    php7.2-gettext \
    php7.2-gd \
    php7.2-intl \
    php7.2-imap \
    php7.2-ldap \
    php7.2-mbstring \
    php7.2-memcached \
    php7.2-mongo \
    php7.2-mysql \
    php7.2-pdo \
    php7.2-pgsql \
    php7.2-redis \
    php7.2-soap \
    php7.2-sqlite3 \
    php7.2-ssh2 \
    php7.2-zip \
    php7.2-xmlrpc \
    php7.2-xsl \
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
    && cd /home && rm -rf temp && mkdir temp && cd temp \
    && wget https://sourceforge.net/projects/re2c/files/0.16/re2c-0.16.tar.gz \
    && tar zxf re2c-0.16.tar.gz && cd re2c-0.16 \
    && ./configure \
    && make && make install \
    && wget https://github.com/swoole/swoole-src/archive/v4.2.5.tar.gz \
	https://github.com/redis/hiredis/archive/v0.13.3.tar.gz \
	https://github.com/phpredis/phpredis/archive/3.1.3.tar.gz \
	&& tar -xzvf 3.1.3.tar.gz \
	&& tar -xzvf v0.13.3.tar.gz \
	&& tar -xzvf v4.2.5.tar.gz \
	&& cd /home/temp/hiredis-0.13.3 \
	&& make -j && make install && ldconfig \
	&& cd /home/temp/swoole-src-4.2.5 \
	&& phpize && ./configure --enable-async-redis  --enable-openssl --enable-mysqlnd && make \
	&& make install \
    && echo extension=swoole.so >> /etc/php/7.2/mods-available/swoole.ini \
    && ln -s /etc/php/7.2/mods-available/swoole.ini /etc/php/7.2/cli/conf.d/swoole.ini \
    && ln -s /etc/php/7.2/mods-available/swoole.ini /etc/php/7.2/fpm/conf.d/swoole.ini \
	&& pecl install inotify \
	&& pecl install ds \
	&& pecl install igbinary \
    && pecl install yaf \
	&& cd /home/temp/phpredis-3.1.3 \
	&& phpize \
	&& ./configure --enable-redis-igbinary \
	&& make &&  make install \
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
COPY build/php.ini /etc/php/7.2/fpm/php.ini
COPY start.sh /root/start.sh
WORKDIR /root

#CMD ["/usr/sbin/sshd", "-D"]
# start-up nginx and fpm and ssh
CMD chmod +x start.sh && \
    ./start.sh && \
    /usr/sbin/sshd -D