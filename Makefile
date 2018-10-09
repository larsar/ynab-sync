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

build:
	docker-compose build

logs:
	docker-compose logs -f

psql:
	docker-compose run --rm db psql -h db -U postgres development

bash-web:
	docker-compose exec web bash

bash-db:
	docker-compose exec db bash

db-create:
	rake db:create

db-migrate:
	rake db:migrate

dev-up: up db-create db-migrate

redis-cli:
	docker-compose run --rm redis redis-cli -h redis -p 6379




