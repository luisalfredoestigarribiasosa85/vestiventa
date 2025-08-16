#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
bundle install --without development test

# Check if database exists and is accessible
if ! bundle exec rails db:version &> /dev/null; then
  echo "Database doesn't exist, creating..."
  bundle exec rails db:create
fi

# Run migrations
bundle exec rails db:migrate

# Precompile assets
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Clear tmp
bundle exec rails tmp:cache:clear
bundle exec rails tmp:sockets:clear
bundle exec rails tmp:pids:clear

# Ensure the server.pid is removed if it exists
rm -f tmp/pids/server.pid