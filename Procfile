# Web process
web: bundle exec puma -C config/puma.rb

# Release process - Solo precompilación de assets
release: chmod +x bin/precompile && bin/precompile

# Comando separado para migraciones
db_migrate: rails db:prepare

# Health check
healthcheck: curl -f http://localhost:$PORT/up || exit 1
