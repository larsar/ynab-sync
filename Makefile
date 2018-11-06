# Start everything
start: up db-create db-migrate open

# Start databases, but not web app. Use this
dev: db-up redis-up db-create db-migrate

open:
	open 'http://localhost:3004'

# Build images (if necessary), create and start containers
up:
	docker-compose up -d

# Remove containers including database contents
destroy:
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

psql-prod:
	docker-compose run --rm db psql -h db -U postgres production

psql-dev:
	docker-compose run --rm db psql -h db -U postgres development

bash-web:
	docker-compose exec web bash

bash-db:
	docker-compose exec db bash

redis-up:
	docker-compose up -d redis

db-up:
	docker-compose up -d db

db-create:
	rake db:create &&\
	sleep 15

db-migrate:
	rake db:migrate

redis-cli:
	docker-compose run --rm redis redis-cli -h redis -p 6379




