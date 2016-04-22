##
# Makefile for development environments
##

latest: Dockerfile
	@docker build -t activatedgeek/consul-server:devel .

run:
	@docker run -d -p 8500:8500 \
		--name test-consul-server \
		activatedgeek/consul-server:devel

restart:
	@make kill
	@make latest
	@make run

login:
	@docker exec -it test-consul-server sh

logs:
	@docker logs test-consul-server

kill:
	@docker rm -f test-consul-server
