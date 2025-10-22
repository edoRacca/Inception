FROM debian:12.12

RUN apt update -y && apt upgrade -y && apt install bash -y && \
	apt install php wordpress -y && rm -rf /var/lib/apt/lists/*


# CMD ["wordpress", "-g", "daemon off;"]