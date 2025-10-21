# Etapa 1: compilación
FROM golang:1.22-bookworm AS builder

WORKDIR /app

# Copiar todo el código fuente
COPY . .

# Ir a la carpeta donde está el main.go
WORKDIR /app/server/main

# Descargar dependencias y compilar el binario
RUN go mod download

# 👇 CAMBIO CLAVE: Usa CGO_ENABLED=1 para permitir la compilación con CGO
# SQLite a menudo requiere CGO para enlazar con las librerías C de sqlite.
# Nota: La imagen base 'golang:1.22-bookworm' ya tiene GCC y C libs, lo cual es necesario.
RUN CGO_ENABLED=1 go build -o /focalboard-server

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

EXPOSE 8000

CMD ["/app/bin/focalboard-server"]
