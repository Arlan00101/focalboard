# Etapa 1: build
FROM golang:1.22-bookworm AS builder

# Instalar dependencias básicas
RUN apt-get update && apt-get install -y git

# Crear directorio de trabajo
WORKDIR /app

# Copiar archivos del repo
COPY . .

# Compilar el servidor Focalboard
RUN cd server && go build -o /app/focalboard-server

# Etapa 2: imagen final
FROM debian:bookworm-slim

WORKDIR /app

# Copiar binario compilado desde la etapa anterior
COPY --from=builder /app/focalboard-server /app/

# Copiar assets (interfaz web)
COPY webapp /app/webapp

# Variables de entorno por defecto
ENV SERVER_PORT=8000
ENV DB_TYPE=sqlite3
ENV DB_CONFIG=./focalboard.db

# Exponer puerto
EXPOSE 8000

# Comando de inicio
CMD ["./focalboard-server"]
