#!/usr/bin/env bash

rake db:create
rake db:migrate
/usr/local/bundle/bin/bundle exec rails s -p 3000 -b '0.0.0.0'
