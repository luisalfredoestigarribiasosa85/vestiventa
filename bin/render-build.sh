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

# Configurar base de datos
echo "=== Configurando base de datos ==="

# Crear la base de datos si no existe
bundle exec rails db:create 2>/dev/null || echo "La base de datos ya existe o no se pudo crear"

# Ejecutar migraciones
echo "=== Ejecutando migraciones ==="
bundle exec rails db:migrate || { echo "Error al ejecutar migraciones"; exit 1; }

# Precargar datos de semilla si es necesario
# bundle exec rails db:seed || echo "Advertencia: No se pudieron cargar los datos de semilla"

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