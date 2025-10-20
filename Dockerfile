# Etapa 1: build
FROM golang:1.22-bookworm AS builder

# Instalar dependencias básicas
RUN apt-get update && apt-get install -y git

# Crear directorio de trabajo
WORKDIR /app

# Copiar todo el proyecto
COPY . .

# Verificar dónde está el código Go
# (algunas versiones lo tienen en cmd/focalboard-server)
RUN if [ -d cmd/focalboard-server ]; then \
        cd cmd/focalboard-server && go build -o /app/focalboard-server ; \
    else \
        go build -o /app/focalboard-server ; \
    fi

# Etapa 2: imagen final ligera
FROM debian:bookworm-slim

WORKDIR /app

# Copiar binario del builder
COPY --from=builder /app/focalboard-server /app/

# Copiar assets web si existen
COPY webapp /app/webapp

# Variables de entorno por defecto
ENV SERVER_PORT=8000
ENV DB_TYPE=sqlite3
ENV DB_CONFIG=./focalboard.db

# Exponer puerto
EXPOSE 8000

# Comando de inicio
CMD ["./focalboard-server"]
