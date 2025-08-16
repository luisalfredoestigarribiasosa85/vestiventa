#!/usr/bin/env bash
# exit on error
set -o errexit
set -x

echo "=== Iniciando proceso de construcción ==="

# Configurar bundler para omitir gems de desarrollo y prueba
echo "=== Configurando bundler ==="
bundle config set without 'development test' || echo "Advertencia: No se pudo configurar bundler"

# Instalar dependencias
echo "=== Instalando dependencias ==="
bundle install || { echo "Error al instalar dependencias"; exit 1; }

# Mostrar información de la base de datos para depuración
echo "=== Información de la base de datos ==="
echo "DATABASE_URL: ${DATABASE_URL}"

# Verificar si la base de datos está accesible
echo "=== Verificando conexión a la base de datos ==="

# Forzar el uso de SSL para la conexión
export PGSSLMODE=require

if ! bundle exec rails runner 'puts "Conexión exitosa: #{ActiveRecord::Base.connection.active?}"' 2>/dev/null; then
    echo "ERROR: No se pudo conectar a la base de datos a través de Rails"
    echo "=== Verificando configuración de Rails ==="
    bundle exec rails runner 'puts "Configuración de base de datos: #{ActiveRecord::Base.connection_config}"'
    exit 1
fi

# Continuar con el resto del proceso
echo "=== Creando base de datos si no existe ==="
bundle exec rails db:create 2>/dev/null || echo "La base de datos ya existe o no se pudo crear"

echo "=== Ejecutando migraciones ==="
bundle exec rails db:migrate || { 
    echo "Error al ejecutar migraciones. Intentando cargar el esquema..."
    bundle exec rails db:schema:load || {
        echo "Error al cargar el esquema. Verificando migraciones pendientes..."
        bundle exec rails db:migrate:status
        exit 1
    }
}

# Precompilar assets
echo "=== Precompilando assets ==="
bundle exec rails assets:precompile || { echo "Error al precompilar assets"; exit 1; }
bundle exec rails assets:clean || echo "Advertencia: No se pudieron limpiar los assets"

# Limpiar archivos temporales
echo "=== Limpiando archivos temporales ==="
bundle exec rails tmp:cache:clear || echo "Advertencia: No se pudo limpiar la caché"
bundle exec rails tmp:sockets:clear || echo "Advertencia: No se pudieron limpiar los sockets"
bundle exec rails tmp:pids:clear || echo "Advertencia: No se pudieron limpiar los PIDs"

# Asegurarse de que no exista server.pid
echo "=== Limpiando server.pid ==="
rm -f tmp/pids/server.pid

echo "=== Construcción completada exitosamente ==="