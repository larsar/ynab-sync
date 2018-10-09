#!/usr/bin/env bash

if [ ! -e .env ]; then
    echo export SECRET_KEY_BASE=`rake secret` > .env
fi
. .env

rake db:create
rake db:migrate
rake assets:precompile
/usr/local/bundle/bin/bundle exec rails s -p 3000 -b '0.0.0.0'
