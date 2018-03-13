FROM php:7.1-fpm

MAINTAINER peterpang 10846295@qq.com

RUN apt-get update &&  apt-get install -y \
            libfreetype6-dev \
            libjpeg62-turbo-dev \
            libmcrypt-dev \
            libpng12-dev \
            libcurl4-gnutls-dev \
            sudo \
            curl \
            nodejs \
            npm \
            nginx-full \
            zlib1g-dev \
            vim \
            libssl-dev \
            unzip \
            wget \
            git \
            make \
            gcc \
            passwd \
            openssl \
            openssh-server \
            subversion \
            supervisor \
            --no-install-recommends \
            && docker-php-ext-install -j$(nproc) iconv mcrypt \
            && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
            && docker-php-ext-install -j$(nproc) gd \
            && docker-php-ext-install pdo pdo_mysql \
            && docker-php-ext-install curl \
            && curl -L https://pecl.php.net/get/redis-3.1.2.tgz >> /usr/src/php/ext/redis.tgz \
            && tar -xf /usr/src/php/ext/redis.tgz -C /usr/src/php/ext/ \
            && rm /usr/src/php/ext/redis.tgz \
            && docker-php-ext-install redis-3.1.2 \
            && curl -sS https://getcomposer.org/installer | php \
            && mv composer.phar /usr/local/bin/composer \
            && cd /home && rm -rf temp && mkdir temp && cd temp \
            && wget https://github.com/phalcon/cphalcon/archive/v3.3.2.tar.gz \
            && tar -zxvf v3.3.2.tar.gz \
            && cd cphalcon-3.3.2/build \
            && sudo ./install \
            && mkdir -p /var/log/supervisor \
            && mkdir /var/run/sshd \
            && apt-get clean \
            && apt-get autoclean \
            && useradd admin \
            && echo 'root:123456' | chpasswd \
            && /etc/init.d/ssh restart

COPY build/.bashrc /root/.bashrc
COPY build/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY build/nginx.conf /etc/nginx/sites-enabled/default
COPY build/php.ini /etc/php/7.1/fpm/php.ini

ADD src /var/www/public/

EXPOSE 80 22

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf","/usr/sbin/sshd", "-D"]
#CMD ["/usr/sbin/sshd", "-D"]