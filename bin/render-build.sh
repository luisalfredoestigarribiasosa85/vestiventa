#!/usr/bin/env bash
# exit on error
set -o errexit

# Enable detailed logging
set -x

echo "=== Starting build process ==="

# Configure bundler to skip development and test gems
echo "=== Configuring bundler ==="
bundle config set without 'development test' || echo "Warning: Could not set bundler config"

# Install dependencies
echo "=== Installing dependencies ==="
bundle install || { echo "Failed to install dependencies"; exit 1; }

# Check if database is accessible
echo "=== Checking database connection ==="
if ! bundle exec rails runner 'ActiveRecord::Base.connection' 2>/dev/null; then
  echo "=== Database doesn't exist or is not accessible, running setup ==="
  bundle exec rails db:prepare || { echo "Failed to prepare database"; exit 1; }
else
  echo "=== Running migrations ==="
  bundle exec rails db:migrate || { echo "Failed to run migrations"; exit 1; }
fi

# Precompile assets
echo "=== Precompiling assets ==="
bundle exec rails assets:precompile || { echo "Failed to precompile assets"; exit 1; }
bundle exec rails assets:clean || echo "Warning: Could not clean assets"

# Clear tmp
echo "=== Cleaning temporary files ==="
bundle exec rails tmp:cache:clear || echo "Warning: Could not clear cache"
bundle exec rails tmp:sockets:clear || echo "Warning: Could not clear sockets"
bundle exec rails tmp:pids:clear || echo "Warning: Could not clear pids"

# Ensure the server.pid is removed if it exists
echo "=== Cleaning up server.pid ==="
rm -f tmp/pids/server.pid

echo "=== Build completed successfully ==="