FROM ubuntu:16.04

MAINTAINER  peterpang <10846295@qq.com>

COPY sshd_config /etc/ssh/

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils \
    apt-get upgrade -y && apt-get install -y software-properties-common python-software-properties \
    LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php && apt-get update \
            apt-get update && apt-get install -y --allow-unauthenticated \
	      php7.1 \
            php7.1-fpm \
            php7.1-dev \
		php7.1-mysql \
		php7.1-pdo \
            php7.1-mysqlnd \
		php7.1-mysql \
            php7.1-curl \
            php7.1-gd \
            php7.1-intl \
            php7.1-mcrypt \
            php7.1-redis \
            php7.1-sqlite \
            php7.1-tidy \
            php7.1-xmlrpc \
            php7.1-pgsql \
            php7.1-ldap \
            php7.1-pgsql \
            php7.1-sqlite3 \
            php7.1-json \
            php7.1-xml \
            php7.1-mbstring \
            php7.1-soap \
            php7.1-zip \
            php7.1-cli \
            php7.1-sybase \
            php7.1-odbc \
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
            && curl -sS https://getcomposer.org/installer | php \
            && mv composer.phar /usr/local/bin/composer \
            && cd /home && rm -rf temp && mkdir temp && cd temp \
            && wget https://github.com/phalcon/cphalcon/archive/v3.3.2.tar.gz \
            && tar -zxvf v3.3.2.tar.gz \
            && cd cphalcon-3.3.2/build \
            && sudo ./install \
            && pecl install swoole \
            && echo extension=phalcon.so >> /etc/php/7.1/mods-available/phalcon.ini \
            && ln -s /etc/php/7.1/mods-available/phalcon.ini /etc/php/7.1/cli/conf.d/phalcon.ini \
            && ln -s /etc/php/7.1/mods-available/phalcon.ini /etc/php/7.1/fpm/conf.d/phalcon.ini \
            && echo extension=swoole.so >> /etc/php/7.1/mods-available/swoole.ini \
            && ln -s /etc/php/7.1/mods-available/swoole.ini /etc/php/7.1/cli/conf.d/swoole.ini \
            && ln -s /etc/php/7.1/mods-available/swoole.ini /etc/php/7.1/fpm/conf.d/swoole.ini \
            && service php7.1-fpm start \
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