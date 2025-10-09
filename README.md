# MongoDB Dockerfile

Este directorio contiene un `Dockerfile` construido a partir de la configuración
en `docker-compose.yml` y la imagen oficial `mongo:8.0`.

Arquitectura y decisiones:
- Se usa `FROM mongo:8.0` para mantener el mismo runtime que en el
  `docker-compose.yml`.
- No se sobrescribe `ENTRYPOINT` ni `CMD` para conservar el comportamiento de
  inicialización oficial (scripts en `/docker-entrypoint-initdb.d`).
- Las credenciales no se escriben en el repositorio. Usar variables de entorno
  en tiempo de ejecución o un archivo `.env` con cuidado.

Cómo construir la imagen:

```bash
# Construir la imagen (opcionalmente pasar valores build-time, pero no recomendado)
docker build -t mongodb .
```

Cómo ejecutar (recomendado: pasar credenciales en runtime):

```bash
# Ejecutar con variables de entorno (recomendado)
docker run -d \
  -p 27017:27017 \
  -v $(pwd)/mongo:/data/db \
  -e MONGO_INITDB_ROOT_USERNAME=tu_usuario \
  -e MONGO_INITDB_ROOT_PASSWORD=tu_contraseña \
  --name mogodb mongodb
```

Alternativa con archivo `.env` y docker-compose:

```yaml
version: '3.8'
services:
  mongo-db:
    build: .
    environment:
      MONGO_INITDB_ROOT_USERNAME: ${MONGO_INITDB_USERNAME}
      MONGO_INITDB_ROOT_PASSWORD: ${MONGO_INITDB_PASSWORD}
    volumes:
      - ./mongo:/data/db
    ports:
      - "27017:27017"

# Luego ejecutar:
docker compose --env-file .env up -d --build
```

Notas de seguridad:
- Nunca subir credenciales en texto plano a repositorios.
- Para entornos de producción, considere usar secretos de Docker, un gestor de
  secretos (vault) o variables de entorno inyectadas por el orquestador.
