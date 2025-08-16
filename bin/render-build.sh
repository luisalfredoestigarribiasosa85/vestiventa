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
if ! bundle exec rails runner 'puts "Conexión exitosa: #{ActiveRecord::Base.connection.active?}"' 2>/dev/null; then
    echo "ERROR: No se pudo conectar a la base de datos"
    echo "=== Intentando conectar manualmente ==="
    
    # Extraer parámetros de conexión de DATABASE_URL
    DB_URL=${DATABASE_URL#*//}  # Elimina 'postgresql://'
    DB_USER_PASS=${DB_URL%@*}   # Obtiene 'usuario:contraseña'
    DB_HOST_PATH=${DB_URL#*@}   # Obtiene 'host:puerto/base_de_datos'
    
    DB_USER=${DB_USER_PASS%:*}  # Extrae usuario
    DB_PASS=${DB_USER_PASS#*:}  # Extrae contraseña
    DB_HOST=${DB_HOST_PATH%/*}  # Extrae host:puerto
    DB_NAME=${DB_HOST_PATH#*/}  # Extrae nombre de la base de datos
    
    echo "Intentando conectar con:"
    echo "Usuario: $DB_USER"
    echo "Host: $DB_HOST"
    echo "Base de datos: $DB_NAME"
    
    # Intentar conectar manualmente
    if PGPASSWORD=$DB_PASS psql -h $DB_HOST -U $DB_USER -d $DB_NAME -c "SELECT 1" >/dev/null 2>&1; then
        echo "¡Conexión exitosa usando psql!"
        echo "El problema puede estar en la configuración de Rails"
    else
        echo "No se pudo conectar ni siquiera con psql"
        echo "Por favor verifica:"
        echo "1. Que la base de datos existe"
        echo "2. Que el usuario tiene permisos"
        echo "3. Que el host sea accesible desde Render"
        echo "4. Que el puerto esté abierto (5432 por defecto)"
    fi
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