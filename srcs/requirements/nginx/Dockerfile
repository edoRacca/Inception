FROM ubuntu:24.04

RUN apt update -y && apt upgrade -y && apt install bash -y
RUN apt install nginx -y && rm -rf /var/lib/apt/lists/*

# EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]