# Etapa 1: compilación
FROM golang:1.22-bookworm AS builder

WORKDIR /app
COPY . .
WORKDIR /app/server/main
RUN go mod download
RUN go build -o /focalboard-server

# Etapa 2: imagen final
FROM debian:bookworm-slim

WORKDIR /app

# 1. Crear el directorio 'bin'
RUN mkdir -p bin

# Copiar el binario compilado al directorio 'bin'
COPY --from=builder /focalboard-server /app/bin/

# 2. Corregido: Copia el server-config.json desde la raíz y lo renombra a config.json
COPY server-config.json /app/config.json

# 3. Corregido: Copia la carpeta 'webapp' al destino './pack' para que coincida con el JSON
COPY webapp /app/pack

# Configuración por defecto
ENV SERVER_PORT=8000
ENV DB_TYPE=sqlite3
ENV DB_CONFIG=./focalboard.db

EXPOSE 8000

CMD ["/app/bin/focalboard-server"]
