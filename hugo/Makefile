DOCKER_IMAGE_NAME = hugo
CONTAINER_NAME = webhook

docker-build: Dockerfile
	docker build --force-rm=true --tag=$(DOCKER_IMAGE_NAME) .

docker-run:
	@echo "Here's an example command on how to run a webhook container:"
	@echo "docker run -d -p 9000:9000 -v $(shell pwd)/../volumes/nginx/html:/usr/share/nginx/html/ --name=$(CONTAINER_NAME) -e \"HUGO_REPO_URL=https://github.com/d2one/d2one.github.io\"\\"
	@echo " -e \"NGINX_HTML_VOLUME=/usr/share/nginx/html/\"  $(DOCKER_IMAGE_NAME)"