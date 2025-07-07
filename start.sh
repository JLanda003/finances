#!/bin/bash

set -e

# === Configuración ===
DB_HOST="db"
DB_PORT="5432"
MAX_ATTEMPTS=30
SLEEP_SECONDS=2

echo ""
echo "🔧 Iniciando Docker Compose..."
docker-compose up --build -d

echo ""
echo "⏳ Esperando a que PostgreSQL esté listo en $DB_HOST:$DB_PORT..."

attempt=1
until docker-compose exec -T db pg_isready -h $DB_HOST -p $DB_PORT > /dev/null 2>&1; do
  if [ $attempt -ge $MAX_ATTEMPTS ]; then
    echo "❌ PostgreSQL no está disponible tras $MAX_ATTEMPTS intentos. Abortando."
    docker-compose logs db
    exit 1
  fi
  echo "  ⏱️  Intento $attempt/$MAX_ATTEMPTS: PostgreSQL no listo. Reintentando en $SLEEP_SECONDS segundos..."
  attempt=$((attempt + 1))
  sleep $SLEEP_SECONDS
done

echo "✅ PostgreSQL está disponible."

echo ""
echo "🚀 Aplicando migraciones..."
docker-compose exec backend python manage.py migrate

echo ""
echo "👤 Verificando superusuario..."
docker-compose exec backend python manage.py shell -c "
from django.contrib.auth import get_user_model;
User = get_user_model();
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@example.com', 'admin123');
    print('✅ Superusuario creado: admin / admin123');
else:
    print('ℹ️  El superusuario 'admin' ya existe.');
"

echo ""
echo "✅ Todo listo:"
echo "   🔹 Backend: http://localhost:8000"
echo "   🔹 Frontend: http://localhost:3000"
echo "   🔹 Admin Django: http://localhost:8000/admin"
