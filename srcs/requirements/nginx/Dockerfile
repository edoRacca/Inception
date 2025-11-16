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
    -subj "/C=IT/ST=Italy/L=Rome/O=LocalDev/OU=Dev/CN=localhost"


COPY ./conf/default.conf /etc/nginx/conf.d/

CMD ["nginx", "-g", "daemon off;"]