#!/usr/bin/env bash
set -euxo pipefail

ruby -v
bundle -v

bundle install --without development test

echo "👉 Precompilando assets..."
RAILS_ENV=production bundle exec rails assets:precompile

echo "👉 Migrando base de datos..."
RAILS_ENV=production bundle exec rails db:migrate

echo "✅ Build completado"
