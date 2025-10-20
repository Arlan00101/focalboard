# Etapa 1: compilación
FROM golang:1.22-bookworm AS builder

# Establecer directorio de trabajo
WORKDIR /app

# Copiar solo los archivos necesarios para compilar
COPY server ./server
COPY go.* ./

# Entrar a la carpeta del servidor y compilar
WORKDIR /app/server
RUN go mod download
RUN go build -o /focalboard-server

# Etapa 2: imagen final
FROM debian:bookworm-slim

WORKDIR /app

# Copiar binario compilado y recursos web
COPY --from=builder /focalboard-server /app/
COPY webapp /app/webapp

# Variables de entorno por defecto
ENV SERVER_PORT=8000
ENV DB_TYPE=sqlite3
ENV DB_CONFIG=./focalboard.db

EXPOSE 8000

CMD ["./focalboard-server"]
