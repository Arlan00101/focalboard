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

# Crear el directorio 'bin' si no existe, ya que Railway parece esperarlo
RUN mkdir -p bin

# Copiar el binario compilado al directorio 'bin'
COPY --from=builder /focalboard-server /app/bin/

# Copiar los archivos web
COPY webapp /app/webapp

COPY server/config/config.json /app/

# Configuración por defecto
ENV SERVER_PORT=8000
ENV DB_TYPE=sqlite3
ENV DB_CONFIG=./focalboard.db

EXPOSE 8000

# Cambiar el CMD para que use la ruta completa al ejecutable, o la ruta relativa esperada.
# Usaremos la ruta completa para mayor fiabilidad.
# También puedes probar: CMD ["./bin/focalboard-server"]
CMD ["/app/bin/focalboard-server"]
