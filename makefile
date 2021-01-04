.PHONY: help
help: ## Shows this help command
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## Builds the docker image
	docker build -t ca . --no-cache

run: ## Runs the docker image in temp space
	docker run -it ca /bin/bash

deploy: ## Deploys the image in a detached container
	docker build -t ca .
	docker-compose -d .
