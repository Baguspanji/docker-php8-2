FROM ubuntu:latest AS base

ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN apt-get update
RUN apt-get install -y software-properties-common curl nginx supervisor vim zip unzip
RUN add-apt-repository -y ppa:ondrej/php
RUN apt-get update
RUN apt-get install -y php8.2 \
    php8.2-fpm \
    php8.2-cli \
    php8.2-opcache \
    php8.2-common \
    php8.2-mysql \
    php8.2-zip \
    php8.2-gd \
    php8.2-mbstring \
    php8.2-curl \
    php8.2-xml \
    php8.2-bcmath \
    php8.2-imagick \
    php8.2-xmlrpc \
    php8.2-memcached \
    php8.2-redis \
    php8.2-memcache \
    php8.2-readline \
    php8.2-intl \
    php8.2-bz2 \
    php8.2-dom \
    php8.2-pgsql \
    php8.2-pdo \
    php-pear

RUN mkdir -p /run/php \
    && rm -rf /tmp/pear \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/www/html/*.html \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY ./config/nginx.conf /etc/nginx/nginx.conf
COPY ./config/default.conf /etc/nginx/conf.d/default.conf

COPY ./config/supervisord.conf /etc/supervisor/supervisord.conf
COPY ./config/php.ini /etc/php/8.2/fpm/conf.d/php.ini

COPY ./index.html /var/www/html/index.html

WORKDIR /var/www/html

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
