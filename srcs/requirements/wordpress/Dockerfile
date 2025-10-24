FROM debian:12.12

RUN apt update -y && apt upgrade -y 
RUN apt-get install php-cli -y

COPY ./tools/script.sh /usr/local/bin/script.sh

EXPOSE 9000

ENTRYPOINT ["script.sh"]
