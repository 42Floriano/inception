FROM debian:bookworm

RUN apt update -y && apt upgrade -y && apt install mariadb-server -y

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld && rm -rf /var/lib/apt/lists/*

COPY tools/setup_mariadb.sh /tmp/setup_mariadb.sh

RUN chmod +x /tmp/setup_mariadb.sh

EXPOSE 3306

CMD ["/tmp/setup_mariadb.sh"]