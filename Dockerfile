FROM php:7.1-fpm
MAINTAINER peterpang 10846295@qq.com
RUN apt-get update &&  apt-get install -y \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libmcrypt-dev \
      libpng12-dev \
      libcurl4-gnutls-dev \
       && docker-php-ext-install -j$(nproc) iconv mcrypt \
          && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
          && docker-php-ext-install -j$(nproc) gd \
          && docker-php-ext-install pdo pdo_mysql \
          && docker-php-ext-install curl \
          && curl -L https://pecl.php.net/get/redis-3.1.2.tgz >> /usr/src/php/ext/redis.tgz \
          && tar -xf /usr/src/php/ext/redis.tgz -C /usr/src/php/ext/ \
          && rm /usr/src/php/ext/redis.tgz \
          && docker-php-ext-install redis-3.1.2 
