FROM debian:12.12

RUN apt update -y && apt upgrade -y && apt install bash -y && \
	apt install nginx -y && rm -rf /var/lib/apt/lists/* && \
	apt-get update && apt install openssl -y && \
	mkdir -p /etc/nginx/ssl && \
    #localhost certificate
    openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/server.key \
    -out /etc/nginx/ssl/server.crt \
    -subj "/C=IT/ST=Italy/L=Rome/O=LocalDev/OU=Dev/CN=localhost" && \
    #edraccan.42.fr certificate
    openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/edraccan.key \
    -out /etc/nginx/ssl/edraccan.crt \
    -subj "/C=IT/ST=Italy/L=Rome/O=LocalDev/OU=Dev/CN=edraccan.42.fr"


COPY ./conf/default.conf /etc/nginx/conf.d/

CMD ["nginx", "-g", "daemon off;"]