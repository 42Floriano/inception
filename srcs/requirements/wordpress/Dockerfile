FROM debian:bookworm

RUN apt-get update -y && apt-get upgrade -y && apt-get -y install wget

RUN apt-get install -y php8.2\
    php-fpm\
    php-mysql\
    mariadb-client\
    curl\
    bash && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php /var/www/html

RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /var/www
RUN cd /var/www && tar -xzf wordpress-6.0-fr_FR.tar.gz && rm wordpress-6.0-fr_FR.tar.gz
RUN chown -R root:root /var/www/wordpress
RUN chown -R www-data:www-data /var/www/html

RUN sed -i 's|^listen = .*|listen = 9000|' /etc/php/*/fpm/pool.d/www.conf

RUN chown -R www-data:www-data /var/www/html

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

#RUN wp core download --allow-root

COPY conf/auto_config.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /var/www/html

ENTRYPOINT ["bash", "/entrypoint.sh"]