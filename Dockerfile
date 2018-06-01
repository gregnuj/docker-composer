FROM php:5.6-apache

LABEL MAINTAINER="Greg Junge <gregnuj@gmail.com>"

## Install project requirements
RUN apt-get update \
    && apt-get install -y \
    nodejs npm bash cron curl git socat unzip vim openssh-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

## Set up composer enviroment
ENV PATH="/composer/vendor/bin:$PATH" \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/composer

## Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer --ansi --version --no-interaction

## cake.php uses /usr/bin/php
RUN ln -s /usr/local/bin/php /usr/bin/php

## apt installs node as nodejs 
RUN ln -s /usr/bin/nodejs /usr/bin/node

## Install bower and grunt
RUN npm install -g bower --save-dev \
    && npm install -g grunt --save-dev \
    && npm install -g grunt-contrib-copy --save-dev \
    && npm install -g grunt-contrib-concat --save-dev

## Enable mod rewrite
RUN sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
RUN a2enmod rewrite

## Copy entrypoint script(s)
COPY *.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/*.sh

RUN echo '{ "allow_root": true }' > /root/.bowerrc

EXPOSE 80
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/local/bin/composer-install.sh"]

