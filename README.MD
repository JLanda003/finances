# 🧾 Finances App (Django + React + PostgreSQL con Docker)

Este proyecto es una aplicación web que utiliza:

- ⚙️ **Backend:** Django + Django REST Framework
- 💻 **Frontend:** React + Vite + TypeScript + Material UI (MUI)
- 🛢️ **Base de datos:** PostgreSQL
- 🐳 **Contenedores:** Docker & Docker Compose

---

## 📁 Estructura del Proyecto
```
  finances/
  ├── backend/ # Proyecto Django (API REST)
  │ ├── finances/ # Configuración principal (settings.py, urls.py, wsgi.py)
  │ ├── apps/ # Tus apps Django personalizadas
  │ ├── requirements.txt # Dependencias del backend
  │ └── Dockerfile
  ├── frontend/ # Proyecto React + Vite
  │ ├── src/
  │ ├── public/
  │ └── Dockerfile
  ├── .env # Variables de entorno (Postgres, Django, etc)
  ├── docker-compose.yml
  ├── start.sh # Script para levantar todo y migrar
  ├── dev.sh # Script para desarrollo con runserver
  └── .dockerignore
```

---

## ⚙️ Requisitos

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- Git Bash (Windows) o terminal bash

---

## 🚀 Instalación y ejecución (desde cero)

### 1. Clona el repositorio

bash
git clone https://tu-repo.com/finances.git
cd finances

### 2. Crea archivo .env
# .env
```
  POSTGRES_DB=finances_db
  POSTGRES_USER=admin
  POSTGRES_PASSWORD=admin123
  POSTGRES_HOST=db
  POSTGRES_PORT=5432
```
### 3. Asegúrate de que el backend tenga sus dependencias
Archivo: backend/requirements.txt
```
  Django>=4.2
  djangorestframework
  psycopg2-binary
  django-cors-headers
  gunicorn
```

### 4. Ejecuta el script principal
Esto construye todo, espera a la base de datos, aplica migraciones y crea el superusuario automáticamente:
```
  chmod +x start.sh
  ./start.sh
```
  - Superusuario: admin
  - Contraseña: admin123

💻 Desarrollo (modo en caliente)
Si quieres usar runserver para recarga automática:
```
  chmod +x dev.sh
  ./dev.sh
```
🔗 Accesos
  - 🛠️ Django API / Admin: http://localhost:8000

  - 🎨 Frontend React: http://localhost:3000

  - 📊 Base de datos (DBeaver, etc):
```
    Host: localhost

    Puerto: 5432

    Usuario: admin

    Contraseña: admin123

    Base de datos: finances_db
```
## 🐳 Crear Docker desde cero (si no existe)
Si tú aún no tienes Dockerfiles o Compose, sigue esto:

### 📄 backend/Dockerfile
```
  FROM python:3.11-slim

  WORKDIR /app
  COPY requirements.txt .
  RUN pip install --no-cache-dir -r requirements.txt

  COPY . .

  CMD ["gunicorn", "finances.wsgi:application", "--bind", "0.0.0.0:8000"]
```
### 📄 frontend/Dockerfile
```
  FROM node:20

  WORKDIR /app
  COPY package*.json ./
  RUN npm install

  COPY . .
  RUN npm run build
  RUN npm install -g serve

  CMD ["serve", "-s", "dist"]
```
### 📄 docker-compose.yml (Carpeta Raíz)
```
  services:
  db:
    image: postgres:15
    env_file: .env
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  backend:
    build:
      context: ./backend
    command: gunicorn finances.wsgi:application --bind 0.0.0.0:8000
    volumes:
      - ./backend:/app
    ports:
      - "8000:8000"
    depends_on:
      - db
    env_file: .env

  frontend:
    build:
      context: ./frontend
    volumes:
      - ./frontend:/app
    ports:
      - "3000:3000"
    stdin_open: true
    tty: true

  volumes:
    postgres_data:
```

### 📄 .dockerignore
```
  __pycache__/
  *.pyc
  *.pyo
  *.pyd
  env/
  venv/
  node_modules/
  dist/
  build/
  *.sqlite3
  *.log
  *.env
  .DS_Store
```
### 🧪 Scripts útiles
```
  start.sh → Levanta todo, espera PostgreSQL, corre migraciones y crea superusuario.
  dev.sh → Ejecuta runserver para desarrollo en vivo (requiere backend vivo).
```
### 📦 Construir todo manualmente (alternativa)
```
  docker-compose build
  docker-compose up -d
```
### 🧯 Problemas comunes
```
  ModuleNotFoundError: No module named 'corsheaders' → Falta en requirements.txt + reconstrucción con --build.

  container ... is not running → Revisa errores con: docker-compose logs backend
```