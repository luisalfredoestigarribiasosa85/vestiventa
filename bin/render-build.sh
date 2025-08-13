#!/usr/bin/env bash
# exit on error
set -o errexit

# Instalar dependencias
bundle install

# Precompilar assets
bundle exec rake assets:precompile
bundle exec rake assets:clean

# Ejecutar migraciones
bundle exec rake db:migrate || echo "Falló la migración, continuando..."

# Limpiar archivos temporales
bundle exec rake tmp:cache:clear
bundle exec rake tmp:sockets:clear
bundle exec rake tmp:pids:clear