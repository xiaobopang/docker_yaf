FROM ubuntu:16.04

MAINTAINER  pangxiaobo <10846295@qq.com>

COPY sshd_config /etc/ssh/

RUN apt-get update -y \
    apt-get install -y language-pack-en-base \
    && export LC_ALL=en_US.UTF-8 \
    && export LANG=en_US.UTF-8 \
    && apt-get install -y software-properties-common \
    && LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php \
    && apt-get update -y \
    && apt-get install -y  \
    tzdata \
    curl \
    bison \
    nginx-full \
    php7.1 \
    php7.1-fpm \
    php7.1-bz2 \
    php7.1-bcmath \
    php7.1-calendar \
    php7.1-cgi \
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
    && wget https://github.com/phalcon/cphalcon/archive/v3.3.2.tar.gz \
    && tar -zxvf v3.3.2.tar.gz \
    && cd cphalcon-3.3.2/build \
    && sudo ./install \
    && echo extension=phalcon.so >> /etc/php/7.1/mods-available/phalcon.ini \
    && ln -s /etc/php/7.1/mods-available/phalcon.ini /etc/php/7.1/cli/conf.d/phalcon.ini \
    && ln -s /etc/php/7.1/mods-available/phalcon.ini /etc/php/7.1/fpm/conf.d/phalcon.ini \
    && mkdir -p /var/log/supervisor \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* \
    #添加ssh用户
    && useradd admin \
    && echo 'root:pang123' | chpasswd \
    && /etc/init.d/ssh restart

COPY build/.bashrc /root/.bashrc
COPY build/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY build/nginx.conf /etc/nginx/sites-enabled/default
COPY build/app.conf /etc/nginx/conf.d/app.conf
COPY build/php.ini /etc/php/7.1/fpm/php.ini

ADD src /var/www/app/

EXPOSE 80 22

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]