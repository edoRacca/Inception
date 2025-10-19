
build:
	cd srcs && sudo docker-compose build

up:
	cd srcs && sudo docker-compose up -d

down:
	cd srcs && sudo docker-compose down

stop:
	cd srcs && sudo docker-compose stop 

start:
	cd srcs && sudo docker-compose start

restart: stop build start

# delete all unactive containers, volumes and networks
delete:
	sudo docker system prune

.PHONY: up down stop start restart

#docker exec -it <container> bash