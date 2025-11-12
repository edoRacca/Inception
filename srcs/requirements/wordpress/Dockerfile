FROM debian:12.12

RUN apt update -y && apt upgrade -y
RUN apt-get install php-cli php-fpm php-mysql curl wget -y
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
RUN wp cli update

COPY ./tools/script.sh /usr/local/bin/script.sh

EXPOSE 9000

ENTRYPOINT ["sh", "/usr/local/bin/script.sh"]
