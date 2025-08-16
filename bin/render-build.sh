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

# Mostrar información de la base de datos para depuración
echo "=== Información de la base de datos ==="
echo "DATABASE_URL: ${DATABASE_URL}"

# Verificar la conexión a la base de datos
echo "=== Verificando conexión a la base de datos ==="
if ! bundle exec rails runner 'puts "Conexión exitosa: #{ActiveRecord::Base.connection.active?}"' 2>/dev/null; then
    echo "ERROR: No se pudo conectar a la base de datos"
    echo "=== Verificando configuración de Rails ==="
    bundle exec rails runner 'puts "Configuración de base de datos: #{ActiveRecord::Base.connection_config}"' || true
    exit 1
fi

# Crear base de datos si no existe
echo "=== Creando base de datos si no existe ==="
bundle exec rails db:create 2>/dev/null || echo "La base de datos ya existe"

# Ejecutar migraciones
echo "=== Ejecutando migraciones ==="
bundle exec rails db:migrate 2>&1 || {
    echo "=== Error al ejecutar migraciones ==="
    echo "=== Intentando cargar el esquema directamente ==="
    bundle exec rails db:schema:load || {
        echo "=== Error al cargar el esquema ==="
        echo "=== Verificando estado de migraciones ==="
        bundle exec rails db:migrate:status || true
        exit 1
    }
}

# Precargar datos de semilla
echo "=== Cargando datos de semilla ==="
bundle exec rails db:seed || echo "Advertencia: No se pudieron cargar los datos de semilla"

# Precompilar assets
echo "=== Precompilando assets ==="
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Limpiar archivos temporales
echo "=== Limpiando archivos temporales ==="
bundle exec rails tmp:cache:clear || true
bundle exec rails tmp:sockets:clear || true
bundle exec rails tmp:pids:clear || true

# Limpiar server.pid
rm -f tmp/pids/server.pid

echo "=== Construcción completada exitosamente ==="