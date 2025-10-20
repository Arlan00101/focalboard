# Imagen base oficial de Go
FROM golang:1.22-bookworm AS builder

# Instalar dependencias
RUN apt-get update && apt-get install -y make git

# Crear directorio de trabajo
WORKDIR /app

# Copiar archivos del repo
COPY . .

# Compilar el binario
RUN make build-linux

# Imagen final minimalista
FROM debian:buster-slim

WORKDIR /app

# Copiar el binario construido
COPY --from=builder /app/bin/focalboard-server /app/

# Exponer el puerto
EXPOSE 8000

# Variables por defecto
ENV SERVER_PORT=8000
ENV DB_TYPE=sqlite3
ENV DB_CONFIG=./focalboard.db

# Comando de inicio
CMD ["./focalboard-server"]
