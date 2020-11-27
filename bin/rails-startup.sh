#!/bin/bash
set -x
set -e

cd /usr/src/app

bundle exec rake db:migrate RAILS_ENV="${RAILS_ENV}"
bundle exec puma -C config/puma.rb
