# Dockerfile basado en la imagen oficial de MongoDB
# Nota: no sobrescribimos ENTRYPOINT/CMD para mantener el comportamiento
# del contenedor oficial (inicialización, scripts /docker-entrypoint-initdb.d, etc.).

FROM mongo:8.0

# Permitir pasar credenciales en build (opcional) o en runtime. Es más seguro
# establecer las variables en tiempo de ejecución con -e o --env-file al usar
# docker run / docker-compose.
ARG MONGO_INITDB_USERNAME
ARG MONGO_INITDB_PASSWORD

# Si se pasan ARG durante el build, los usamos para inicializar variables de
# entorno en la imagen. No hay valores por defecto aquí para evitar almacenar
# credenciales en la imagen.
ENV MONGO_INITDB_ROOT_USERNAME=${MONGO_INITDB_USERNAME}
ENV MONGO_INITDB_ROOT_PASSWORD=${MONGO_INITDB_PASSWORD}

# Exponer puerto estándar de MongoDB
EXPOSE 27017

# Declarar el volumen de datos. Al declarar VOLUME aquí, el consumidor aún puede
# montar un volumen local o bind-mount sobre /data/db (recomendado para datos
# persistentes fuera de la imagen).
VOLUME ["/data/db"]

# Ejecutar una actualización mínima de paquetes en el build para reducir
# vulnerabilidades conocidas en la imagen base. Esto se hace en build-time
# (no en runtime) para mantener el contenedor final más actualizado. Se limpia
# la cache de apt para mantener la imagen ligera.
RUN apt-get update \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*

# No redefinimos ENTRYPOINT ni CMD: la imagen oficial ya gestiona el proceso de
# arranque y la inicialización (MONGO_INITDB_ROOT_USERNAME/MONGO_INITDB_ROOT_PASSWORD
# se usan dentro del entrypoint para crear el usuario root si procede).
