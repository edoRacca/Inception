
VOLUMEDIR = $(HOME)/data

build:
	@if [ ! -d $(VOLUMEDIR) ]; then \
		mkdir -p $(VOLUMEDIR)/wordpress $(VOLUMEDIR)/mariadb; \
		chmod 777 -R $(VOLUMEDIR); \
	fi
	cd srcs && docker-compose build

up:
	cd srcs && docker-compose up -d

down:
	cd srcs && docker-compose down

stop:
	cd srcs && docker-compose stop 

start:
	cd srcs && docker-compose start

restart: down up

rebuild: down build up 

# delete all unactive containers, volumes and networks
delete:
	docker system prune

.PHONY: up down stop start restart
