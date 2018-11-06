#!/usr/bin/env bash

if [ ! -e .env ]; then
    echo export SECRET_KEY_BASE=`rake secret` > .env
    echo export RAILS_ENV=production >> .env
fi
. .env

RAILS_ENV=production rake db:create
RAILS_ENV=production rake db:migrate
rake assets:precompile
/usr/local/bundle/bin/bundle exec rails s -p 3000 -b '0.0.0.0'
