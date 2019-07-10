FROM php:5.6-fpm


RUN echo "deb http://archive.debian.org/debian/ jessie main\n"  > /etc/apt/sources.list
RUN echo "deb-src http://archive.debian.org/debian/ jessie main\n" >> /etc/apt/sources.list
RUN echo "deb http://security.debian.org jessie/updates main\n" >> /etc/apt/sources.list
RUN echo "deb-src http://security.debian.org jessie/updates main" >> /etc/apt/sources.list


RUN apt-get update && apt-get install -y -f \
    openssl \
    git \
    unzip \
    curl \
    wget \ 
    zlib1g=1:1.2.8.dfsg-2+b1 \
    zlib1g-dev \
    libpng-dev \      
    ssmtp

RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    mbstring \
    mysqli \
    zip \
    gd \
    sockets \
    bcmath \
    pcntl \
    opcache



# Set timezone
RUN ln -snf /usr/share/zoneinfo/UTC /etc/localtime && echo UTC > /etc/timezone
RUN "date"

# install xdebug
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug
RUN echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "display_startup_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.idekey=\"PHPSTORM\"" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN curl -sS https://getcomposer.org/installer | php -- --version=1.6.5 --install-dir=/usr/local/bin --filename=composer
RUN composer --version

# install redis extension
RUN pecl install redis
RUN docker-php-ext-enable redis

RUN echo 'alias sf="php app/console"' >> ~/.bashrc
RUN echo 'alias sf3="php bin/console"' >> ~/.bashrc

WORKDIR /var/www/html
