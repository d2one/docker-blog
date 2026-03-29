DOCKER_IMAGE_NAME = hugo

docker-build: Dockerfile
	docker build --force-rm=true --tag=$(DOCKER_IMAGE_NAME) .

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

restart:
	docker compose restart

rebuild: docker-build
	docker compose up -d --force-recreate hugo
