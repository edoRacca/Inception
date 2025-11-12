FROM debian:12.12

RUN apt update -y && apt upgrade -y
RUN apt install mariadb-server -y

COPY ./tools/script.sh /usr/local/bin/script.sh

EXPOSE 3306