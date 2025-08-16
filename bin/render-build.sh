#!/usr/bin/env bash
# exit on error
set -o errexit

# Configure bundler to skip development and test gems
bundle config set without 'development test'

# Install dependencies
bundle install

# Run database migrations
bundle exec rails db:migrate 2>/dev/null || bundle exec rails db:setup

# Precompile assets
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Clear tmp
bundle exec rails tmp:cache:clear
bundle exec rails tmp:sockets:clear
bundle exec rails tmp:pids:clear

# Ensure the server.pid is removed if it exists
rm -f tmp/pids/server.pid