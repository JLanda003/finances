#!/bin/bash

SKIP_BUILD=false

# Verifica si el primer argumento es --skip-build
if [ "$1" == "--skip-build" ]; then
  SKIP_BUILD=true
fi

echo "🔻 Deteniendo contenedores..."
docker-compose down

echo "🧹 Eliminando imágenes antiguas del backend y frontend..."
docker rmi finances-backend finances-frontend -f || true

echo "🧼 Eliminando volumen de PostgreSQL..."
docker volume rm finances_postgres_data || true

echo "♻️ Limpiando caché y recursos no usados..."
docker system prune -a --volumes -f

if [ "$SKIP_BUILD" = false ]; then
  echo "🚀 Reconstruyendo y levantando contenedores desde cero..."
  ./start.sh
else
  echo "⚠️ Se omitió la reconstrucción y levantamiento de contenedores."
fi
