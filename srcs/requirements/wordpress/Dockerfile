FROM php:8.2-fpm-alpine

# Install system deps
RUN apk update && apk add --no-cache \
    curl \
    tar \
    mariadb-client \
    libpng-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    libxpm-dev \
    libzip-dev \
    libxml2-dev \
    oniguruma-dev \
    freetype-dev \
    libevent-dev \
    libmcrypt-dev \
    icu-dev \
    openssl-dev \
    bash \
    tzdata \
    autoconf \
    g++ \
    make

# Install PHP extensions
RUN docker-php-ext-install \
    mysqli \
    pdo_mysql \
    xml \
    zip \
    opcache \
    intl

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp


# Download and extract WordPress
RUN curl -O https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    rm latest.tar.gz && \
    mv wordpress /var/www/html

# Set correct ownership
RUN chown -R www-data:www-data /var/www/html

WORKDIR /var/www/html

EXPOSE 9000

COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

CMD ["/setup.sh"]
