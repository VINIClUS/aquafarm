#!/usr/bin/env bash
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails db:migrate
#bundle exec rails db:seed
#bundle exec puma -C config/puma.rb