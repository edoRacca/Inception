FROM debian:12.12

RUN apt update -y && apt upgrade -y
RUN apt install mariadb-server -y

COPY ./tools/script.sh /usr/local/bin/script.sh

EXPOSE 3306

RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

ENTRYPOINT ["sh", "/usr/local/bin/script.sh"]

CMD ["mysqld"]