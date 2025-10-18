
up:
	cd srcs && sudo docker-compose up -d

down:
	cd srcs && sudo docker-compose down

stop:
	cd srcs && sudo docker-compose stop 

start:
	cd srcs && sudo docker-compose start

.PHONY: up down stop
#docker-compose exec <container> bash