#!/bin/bash

# Nombres de los contenedores (ajusta si es necesario)
BACKEND_CONTAINER=backend
FRONTEND_CONTAINER=frontend
DB_SERVICE=db

echo "🔻 Levantando base de datos..."
docker-compose up -d $DB_SERVICE

echo "⏳ Esperando que PostgreSQL esté listo..."
until docker exec -it $DB_SERVICE pg_isready -U admin > /dev/null 2>&1; do
  sleep 1
done
echo "✅ PostgreSQL está listo"

echo "🚀 Levantando backend Django con recarga automática..."
docker exec -d $BACKEND_CONTAINER python manage.py runserver 0.0.0.0:8000

echo "🚀 Levantando frontend React + Vite con hot reload..."
docker exec -d $FRONTEND_CONTAINER npm run dev

echo "🎉 ¡Todo corriendo en modo desarrollo!"
echo "- Backend: http://localhost:8000"
echo "- Frontend: http://localhost:3000 (o el puerto que uses en vite)"
