FROM php:7.2-fpm
LABEL maintainer="Pierre LEJEUNE <darkanakin41@gmail.com>"

RUN yes | pecl install xdebug && docker-php-ext-enable xdebug

RUN docker-php-ext-install pdo pdo_mysql

# Addition of PHP-GD
RUN apt-get update -y && apt-get install -y libwebp-dev libjpeg62-turbo-dev libpng-dev libxpm-dev libfreetype6-dev
RUN apt-get update -y && apt-get install -y zlib1g-dev

RUN docker-php-ext-install mbstring

RUN apt-get install -y libzip-dev
RUN docker-php-ext-install zip

RUN docker-php-ext-configure gd --with-gd --with-webp-dir --with-jpeg-dir \
    --with-png-dir --with-zlib-dir --with-xpm-dir --with-freetype-dir

RUN docker-php-ext-install gd

ENV COMPOSER_HOME /composer
ENV PATH /composer/vendor/bin:$PATH
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN curl -fsSL -o /tmp/composer-setup.php https://getcomposer.org/installer \
&& curl -fsSL -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
&& php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
&& php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --snapshot && rm -rf /tmp/composer-setup.php \
&& apt-get update -y && apt-get install -y git zip unzip && rm -rf /var/lib/apt/lists/* \
&& composer global require hirak/prestissimo

RUN curl -fsSL https://get.symfony.com/cli/installer | bash && mv /root/.symfony/bin/symfony /usr/local/bin/symfony


RUN mkdir -p "$COMPOSER_HOME/cache" \
&& mkdir -p "$COMPOSER_HOME/vendor" \
&& chown -R www-data:www-data $COMPOSER_HOME \
&& chown -R www-data:www-data /var/www

# Installation de https://github.com/Qafoo/QualityAnalyzer
RUN mkdir -p /home/tools \
&& git clone https://github.com/Qafoo/QualityAnalyzer.git /home/tools/quality-analyzer \
&& cd /home/tools/quality-analyzer \
&& composer install \
&& chmod -R +x /home/tools/quality-analyzer/bin \
&& ln -s /home/tools/quality-analyzer/bin/analyze /usr/local/bin/quality-analyzer

USER www-data

VOLUME /composer/cache
