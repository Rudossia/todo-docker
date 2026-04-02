include .env
export

export PROJECT_ROOT=$(shell pwd)


env-up:
	docker compose up -d todo-postgres

env-down:
	docker compose down todo-postgres

env-cleanup:
	@read -p "This will remove all data in the database. Are you sure? (y/n) " ans; \
	if [ "$$ans" = "y" ]; then \
		docker compose down -v todo-postgres && \
		echo "Environment cleaned up."; \
	else \
		echo "Cleanup aborted."; \
	fi

migrate-create:
	@if [ -z "$(seq)" ]; then \
		echo "ОТсутствиует необходимый параметр: seq. Используйте: make migrate-create seq=название_миграции"; \
		exit 1;\
	fi; \
	docker compose run --rm todoapp-postgres-migrate \
		create \
		-ext sql \
		-dir /migrations \
		-seq "$(seq)"

test-target:
	@echo "value: $(var)"

migrate-up:
	@make migrate-action action=up
migrate-down:
	@make migrate-action action=down

migrate-action:
	docker compose run --rm todoapp-postgres-migrate \
		-path /migrations \
		-database postgres://$(POSTGRES_USER):$(POSTGRES_PASSWORD)@todo-postgres:5432/$(POSTGRES_DB)?sslmode=disable \
		"$(action)"

env-port-forwarder:
	@docker compose up -d port-forwarder
env-port-forwarder-down:
	@docker compose down port-forwarder