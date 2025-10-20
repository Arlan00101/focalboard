# Etapa 1: compilación
FROM golang:1.22-bookworm AS builder

WORKDIR /app

# Copiar todo el código fuente
COPY . .

# Ir a la carpeta donde está el main.go
WORKDIR /app/server/main

# Descargar dependencias y compilar el binario
RUN go mod download
RUN go build -o /focalboard-server

# Etapa 2: imagen final
FROM debian:bookworm-slim

WORKDIR /app

# Copiar el binario compilado y los archivos web
COPY --from=builder /focalboard-server /app/
COPY webapp /app/webapp

# Configuración por defecto
ENV SERVER_PORT=8000
ENV DB_TYPE=sqlite3
ENV DB_CONFIG=./focalboard.db

EXPOSE 8000

CMD ["./focalboard-server"]
