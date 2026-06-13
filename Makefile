COMPOSE = docker compose

build-hugo:
	docker build --force-rm=true --tag=hugo hugo/

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

logs:
	$(COMPOSE) logs -f

restart:
	$(COMPOSE) restart

rebuild-hugo: build-hugo
	$(COMPOSE) up -d --force-recreate hugo
