SHELL := /bin/bash

ifneq (,$(findstring xterm,${TERM}))
	BLACK        := $(shell tput -Txterm setaf 0)
	RED          := $(shell tput -Txterm setaf 1)
	GREEN        := $(shell tput -Txterm setaf 2)
	YELLOW       := $(shell tput -Txterm setaf 3)
	LIGHTPURPLE  := $(shell tput -Txterm setaf 4)
	PURPLE       := $(shell tput -Txterm setaf 5)
	BLUE         := $(shell tput -Txterm setaf 6)
	WHITE        := $(shell tput -Txterm setaf 7)
	RESET := $(shell tput -Txterm sgr0)
else
	BLACK        := ""
	RED          := ""
	GREEN        := ""
	YELLOW       := ""
	LIGHTPURPLE  := ""
	PURPLE       := ""
	BLUE         := ""
	WHITE        := ""
	RESET        := ""
endif

DOCKER_COMPOSE := $(shell command -v docker-compose 2> /dev/null)
PODMAN_COMPOSE := $(shell command -v podman-compose 2> /dev/null)
DOCKER_COMPOSE_GO := $(shell command -v docker compose 2> /dev/null)

ifeq ($(DOCKER_COMPOSE),)
    ifeq ($(PODMAN_COMPOSE),)
        ifeq ($(DOCKER_COMPOSE_GO),)
            $(error "Neither docker-compose, podman-compose, nor docker compose is installed.")
        else
            COMPOSE := docker compose
        endif
    else
        COMPOSE := podman-compose
    endif
else
    COMPOSE := docker-compose
endif

rollup: build up cp-env composer-install key-generate set-permissions migrate seed
	@echo "====="
	@echo "> I'd recommend to add host record by running $(YELLOW)sudo make add-host$(RESET) or manually: $(YELLOW)127.0.0.1 artists.test$(RESET) # $(BLUE)*Unless you are in container!$(RESET)"
	@echo "====="
	@echo "$(GREEN)You are good to go!$(RESET)"
	@echo "====="

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up -d

start: up

add-host:
	@if ! grep -qF "127.0.0.1 artists.test" /etc/hosts; then \
		echo "127.0.0.1 artists.test" | sudo tee -a /etc/hosts; \
	else \
		echo "Host record already exists. Access the project: http://artists.test/"; \
	fi

cp-env:
	$(COMPOSE) exec php cp .env.example .env

composer-install:
	$(COMPOSE) exec php composer install

key-generate:
	$(COMPOSE) exec php php artisan key:generate

npm-install:
	$(COMPOSE) exec php npm install

npm-build:
	$(COMPOSE) exec php npm run build

npm-dev:
	$(COMPOSE) exec php npm run dev

set-permissions:
	$(COMPOSE) exec php chmod -R 777 storage bootstrap/cache

migrate:
	@echo "${YELLOW}Waiting for db container to boot...${RESET}"
	sleep 45 && $(COMPOSE) exec php php artisan migrate

seed:
	$(COMPOSE) exec php php artisan db:seed

ps:
	$(COMPOSE) ps

php:
	$(COMPOSE) exec php bash

db:
	$(COMPOSE) exec db bash

stop:
	$(COMPOSE) stop

down:
	$(COMPOSE) down

.PHONY: rollup build up start add-host cp-env composer-install key-generate npm-install npm-build npm-dev set-permissions migrate seed ps php db stop down
