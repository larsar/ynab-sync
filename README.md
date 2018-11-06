# YNAB Sync
The main goal for this project is to automate the process of importing bank transactions to YNAB. Currently only Sbanken (Norway) is supported, but it should be quite easy to add integrations with other banks as well.

**Note:** I have written this code to "scratch my own itch". Please do not use this unless you are able to read the code and understand what it does. I strongly urge you to test it with a dummy budget before using your real budget.

You can run the Ruby on Rails app locally or in the cloud.

## Deploy to Heroku
You can run the ynab sync service for free on Heroku. Choose a name for the application and which region you want to run it in. If you want to automate the sync process, for instance daily, you can use Heroku's scheduler to run the rake task.
[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

## Run locally
The easisest way is to run the application and the databases in Docker, using docker-compose. If you have some basic development tools installed, in addition to Docker, you should be able to start everything by running:
```$ make start```
This runs the app in production mode inside a Docker container.

## Local development
During development it's easiest to run the app from the command line or from an IDE. Start by installing the app dependencies, start the databases and fire up the app.
```
$ bundle install # Install dependencies
$ make dev       # Start the databases and run migrations
$ rails server   # Start the rails application
```
