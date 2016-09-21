FROM php:5.6-fpm

MAINTAINER Valerii Savchenko <wellic72@gmail.com>

ARG DOCKER_GROUP_ID
ARG DOCKER_GROUP_NAME
ARG DOCKER_USER_ID
ARG DOCKER_USER_NAME

USER 0

RUN groupadd --gid ${DOCKER_GROUP_ID} ${DOCKER_GROUP_NAME}
RUN useradd  --gid ${DOCKER_GROUP_ID} --uid ${DOCKER_USER_ID} --create-home --shell /bin/bash ${DOCKER_USER_NAME}
RUN usermod --append --groups sudo ${DOCKER_USER_NAME}
RUN mkdir -p /etc/sudoers.d
RUN echo "${DOCKER_USER_NAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${DOCKER_USER_NAME}
RUN chmod 400 /etc/sudoers.d/${DOCKER_USER_NAME}

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

RUN apt-get install --no-install-recommends -y \
    unzip git wget sudo curl wget imagemagick zip unzip graphicsmagick\
    libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev libpng12-dev \
    libgmp-dev libxml2-dev libpq-dev libxslt-dev libicu-dev \
    php-pear \
    zlib1g-dev \
    libncurses5-dev \
    libicu-dev \
    libmemcached-dev \
    libcurl4-openssl-dev \
    libbz2-dev \
    openssl \
    php5-dev php5-memcached \
    ssmtp

RUN cd \
  && curl -sS https://getcomposer.org/installer | php \
  && mv /root/composer.phar /usr/local/bin/composer \
  && chmod +x /usr/local/bin/composer

RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h 
RUN pecl install intl && \
    docker-php-ext-configure bcmath && \
    docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd && \
    docker-php-ext-configure mysql --with-mysql=mysqlnd && \
    docker-php-ext-configure mysqli --with-mysqli=mysqlnd && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install pdo_mysql mysqli mysql pdo_pgsql

RUN docker-php-ext-install soap intl mcrypt gd exif gettext

RUN docker-php-ext-install ftp gmp bcmath mbstring zip opcache xsl bz2 xmlrpc pcntl

RUN apt-get install -y libmagickwand-6.q16-dev --no-install-recommends \
    && ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/MagickWand-config /usr/bin/ \
    && pecl install imagick \
    && echo "extension=imagick.so" > /usr/local/etc/php/conf.d/ext-imagick.ini \
    && apt-get purge -y libmagickwand-6.q16-dev

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && sed -i '1 a xdebug.remote_autostart=true'  /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && sed -i '1 a xdebug.remote_mode=req'        /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && sed -i '1 a xdebug.remote_handler=dbgp'    /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && sed -i '1 a xdebug.remote_connect_back=1 ' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && sed -i '1 a xdebug.remote_port=9000'       /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && sed -i '1 a xdebug.remote_host=127.0.0.1'  /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && sed -i '1 a xdebug.remote_enable=1'        /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN apt-get install -y mc mysql-client vim
#    docker-php-ext-install memcached && \

# Install APCu
#RUN pecl install apcu
#RUN echo "extension=apcu.so" > /usr/local/etc/php/conf.d/apcu.ini

# Install calendar
#RUN docker-php-ext-install calendar

# Install dba
#RUN docker-php-ext-install dba

#RUN yum -y install git nginx wget mc java sudo 
#php56w php56w-opcache php56w-common php56w-bcmath php56w-cli php56w-fpm php56w-mcrypt php56w-mysql php56w-xml php56w-intl php56w-soap php56w-pecl-imagick 
#postgresql phpmyadmin memcached openssh-server curl beanstalkd php56w-pgsql yum install libcurl-devel python34 python34-setuptools gcc 

# Install mongo
#RUN pecl install mongodb-beta
#RUN echo "extension=mongo.so" > /usr/local/etc/php/conf.d/mongo.ini

# Install ftp
#RUN docker-php-ext-install ftp

# Installing composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer && chmod a+x /usr/local/bin/composer

# Installing symfony
RUN curl -LsS http://symfony.com/installer -o /usr/local/bin/symfony
RUN chmod a+x /usr/local/bin/symfony

RUN sed -i "s/^user = www-data/user = web-user/g"   /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/^group = www-data/group = web-user/g" /usr/local/etc/php-fpm.d/www.conf

RUN chmod a+w /usr/local/etc/php/ /usr/local/etc/php/conf.d
RUN chmod a+r -R /usr/local/lib/php/extensions

RUN apt-get autoremove -y && apt-get clean all && rm -r /var/lib/apt/lists/*

ENTRYPOINT ["/entrypoint.sh"]