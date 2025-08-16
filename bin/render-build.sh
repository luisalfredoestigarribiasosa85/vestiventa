#!/usr/bin/env bash
# exit on error
set -o errexit

# Habilitar modo de depuración
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

# Verificar conexión a la base de datos
echo "=== Verificando conexión a la base de datos ==="
if ! bundle exec rails runner 'puts "Conexión exitosa: #{ActiveRecord::Base.connection.active?}"'; then
    echo "ERROR: No se pudo conectar a la base de datos"
    echo "Verificando configuración..."
    bundle exec rails runner 'puts "Configuración de base de datos: #{ActiveRecord::Base.connection_config}"'
    exit 1
fi

# Intentar crear la base de datos si no existe
echo "=== Intentando crear la base de datos ==="
bundle exec rails db:create 2>/dev/null || echo "La base de datos ya existe o no se pudo crear"

# Verificar el estado de las migraciones
echo "=== Verificando estado de migraciones ==="
bundle exec rails db:migrate:status || { 
    echo "Error al verificar el estado de migraciones";
    echo "Intentando corregir el esquema...";
    bundle exec rails db:schema:load || echo "No se pudo cargar el esquema";
}

# Ejecutar migraciones con más información de depuración
echo "=== Ejecutando migraciones ==="
bundle exec rails db:migrate VERSION=0 2>&1 || echo "No se pudieron revertir todas las migraciones"
bundle exec rails db:migrate 2>&1 || {
    echo "=== ERROR DETALLADO EN MIGRACIONES ==="
    echo "No se pudieron ejecutar las migraciones. Últimos errores:"
    bundle exec rails runner 'puts ActiveRecord::Base.connection.migration_context.migrations_status' 2>&1
    exit 1
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