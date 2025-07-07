#!/bin/bash

BACKEND_CONTAINER=backend
FRONTEND_CONTAINER=frontend

# Función para verificar si un contenedor está corriendo
is_container_running() {
  docker ps -q -f name=$1 > /dev/null
}

echo "🔎 Verificando contenedores en ejecución..."

# ========== BACKEND ==========
if is_container_running $BACKEND_CONTAINER; then
  echo "🛑 Deteniendo Django (runserver) en $BACKEND_CONTAINER..."
  docker exec -it $BACKEND_CONTAINER pkill -f runserver \
    && echo "✅ Backend detenido" \
    || echo "⚠️ No se encontró proceso 'runserver' en $BACKEND_CONTAINER"
else
  echo "❌ Contenedor $BACKEND_CONTAINER no está corriendo"
fi

# ========== FRONTEND ==========
if is_container_running $FRONTEND_CONTAINER; then
  echo "🛑 Deteniendo Vite (npm run dev) en $FRONTEND_CONTAINER..."
  docker exec -it $FRONTEND_CONTAINER pkill -f vite \
    && echo "✅ Frontend detenido" \
    || echo "⚠️ No se encontró proceso 'vite' en $FRONTEND_CONTAINER"
else
  echo "❌ Contenedor $FRONTEND_CONTAINER no está corriendo"
fi

echo "🚫 Servidores de desarrollo apagados (si estaban activos)."
