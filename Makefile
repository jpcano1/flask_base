.DEFAULT_GOAL := help

.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: up
up: ## Run the project
	@docker-compose -f .docker/docker-compose.dev.yml up -d

.PHONY: stop
stop: ## stop Docker containers without removing them
	@docker-compose -f .docker/docker-compose.dev.yml stop

.PHONY: down
down: ## stop and remove Docker containers
	@docker-compose -f .docker/docker-compose.dev.yml down --remove-orphans

.PHONY: build
build: ## rebuild base Docker images
	@docker-compose -f .docker/docker-compose.dev.yml build --no-cache

.PHONY: rebuild
rebuild: ## rebuild base Docker images
	@docker-compose -f .docker/docker-compose.dev.yml down --remove-orphans
	@docker-compose -f .docker/docker-compose.dev.yml build --no-cache