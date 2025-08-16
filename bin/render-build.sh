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
export PGSSLMODE=verify-full
export PGSSLROOTCERT=/etc/ssl/certs/ca-certificates.crt

# Mostrar información de la base de datos
echo "=== Información de la base de datos ==="
echo "DATABASE_URL: ${DATABASE_URL}"

# Verificar la conexión usando psql
echo "=== Verificando conexión con psql ==="
if psql "${DATABASE_URL}?sslmode=verify-full" -c "SELECT 1" >/dev/null 2>&1; then
    echo "Conexión exitosa con psql"
else
    echo "ERROR: No se pudo conectar a la base de datos con psql"
    exit 1
fi

# Verificar la conexión con Rails
echo "=== Verificando conexión con Rails ==="
if ! bundle exec rails runner 'puts "Conexión exitosa: #{ActiveRecord::Base.connection.active?}"'; then
    echo "ERROR: No se pudo conectar a la base de datos con Rails"
    echo "=== Configuración de Rails ==="
    bundle exec rails runner 'puts ActiveRecord::Base.connection_config'
    exit 1
fi

# Continuar con el resto del proceso
echo "=== Creando base de datos si no existe ==="
bundle exec rails db:create 2>/dev/null || echo "La base de datos ya existe"

echo "=== Ejecutando migraciones ==="
bundle exec rails db:migrate || {
    echo "=== Error al ejecutar migraciones ==="
    echo "=== Intentando cargar el esquema ==="
    bundle exec rails db:schema:load || {
        echo "=== Error al cargar el esquema ==="
        exit 1
    }
}

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