# Build images (if necessary), create and start containers
up:
	docker-compose up -d

# Remove containers including database contents
down:
	docker-compose down

ps:
	docker-compose ps

start:
	docker-compose start

stop:
	docker-compose stop

restart:
	docker-compose restart

logs:
	docker-compose logs -f

psql:
	docker-compose run --rm db psql -h db -U postgres development

psql-terminal:
	export STAGE=test && \
	docker-compose exec db bash

db-up:
	docker-compose up -d db


