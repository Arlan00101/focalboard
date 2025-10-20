# Etapa 1: compilación
FROM golang:1.22-bookworm AS builder

WORKDIR /app

# Copiar TODO el código fuente
COPY . .

# Moverse a la carpeta del servidor
WORKDIR /app/server

# Descargar dependencias y compilar
RUN go mod download
RUN go build -o /focalboard-server

# Etapa 2: imagen final
FROM debian:bookworm-slim

WORKDIR /app

# Copiar binario y recursos web
COPY --from=builder /focalboard-server /app/
COPY webapp /app/webapp

# Configuración por defecto
ENV SERVER_PORT=8000
ENV DB_TYPE=sqlite3
ENV DB_CONFIG=./focalboard.db

EXPOSE 8000

CMD ["./focalboard-server"]
