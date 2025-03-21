FROM mariadb:10.6

COPY conf/my.cnf /etc/mysql/my.cnf
COPY tools/init.sql /docker-entrypoint-initdb.d/init.sql

EXPOSE 3306