#!/bin/bash

echo "🔻 Levantando servicios frontend en modo desarrollo..."

# Levanta el contenedor frontend si no está arriba (sin build)
docker-compose up -d frontend

# Ejecuta vite dev server dentro del contenedor frontend
docker exec -it finances_frontend npm run dev
