#!/bin/bash

echo "🔻 Levantando servicios en modo desarrollo..."

# Levanta solo los contenedores si no están arriba (sin build)
docker-compose up -d db

# Espera a que la DB esté lista
echo "⏳ Esperando que PostgreSQL esté listo..."
until docker exec -it financesApp pg_isready -U admin > /dev/null 2>&1; do
  sleep 1
done
echo "✅ PostgreSQL está listo"

# Levanta el backend en modo desarrollo con recarga automática
echo "🚀 Iniciando servidor Django con recarga automática..."
docker exec -it backend python manage.py runserver 0.0.0.0:8000
