FROM debian:12.12

RUN apt update -y && apt upgrade -y && apt install bash -y && \
	apt install wordpress curl gninx mariadb-server -y && rm -rf /var/lib/apt/lists/*