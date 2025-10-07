FROM alpine3.21

RUN apk update && apk upgrade && apk add \
            openssl \
            nginx   \
            curl    \
            vim \
            sudo

RUN rm -f /etc/nginx/nginx.conf

COPY    ./conf/nginx.conf /etc/nginx/nginx.conf
COPY    scripts/setp_nginx.sh /setup_nginx.sh

RUN     chmod -R +x /setup_nginx.sh

EXPOSE 443

ENTRYPOINT ["sh", "setup_nginx.sh"]