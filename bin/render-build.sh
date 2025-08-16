#!/usr/bin/env bash
# exit on error
set -o errexit
set -x

echo "=== Iniciando proceso de construcción ==="

# Configurar bundler
bundle config set without 'development test'

# Instalar dependencias
bundle install

# Configuración de la base de datos
echo "=== Configurando base de datos ==="
export DISABLE_DATABASE_ENVIRONMENT_CHECK=1
export PGSSLMODE=require

# Crear y migrar la base de datos
bundle exec rails db:create 2>/dev/null || echo "La base de datos ya existe"
bundle exec rails db:migrate || bundle exec rails db:setup

# Precompilar assets
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Limpiar archivos temporales
bundle exec rails tmp:cache:clear || true
bundle exec rails tmp:sockets:clear || true
bundle exec rails tmp:pids:clear || true

# Limpiar server.pid
rm -f tmp/pids/server.pid

echo "=== Construcción completada exitosamente ==="