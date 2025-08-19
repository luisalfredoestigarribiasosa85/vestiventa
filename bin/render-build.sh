set -euxo pipefail
ruby -v
bundle -v
bundle install --without development test
# Precompilación (si falla aquí, verás el mensaje real)
RAILS_ENV=production bundle exec rails assets:precompile
# Migraciones (si falla aquí, es tema de DB/migraciones)
RAILS_ENV=production bundle exec rails db:migrate
