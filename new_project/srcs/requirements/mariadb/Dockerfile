FROM debian:bookworm

RUN apt update -y && apt upgrade -y && apt install mariadb-server -y

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/setup_mariadb.sh /tmp/setup_mariadb.sh

RUN chmod +x /tmp/setup_mariadb.sh


#EXPOSE 3306

ENTRYPOINT ["sh", "/tmp/setup_mariadb.sh"]