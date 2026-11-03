#!/usr/bin/env bash

set -Eeuo pipefail

COMPOSE=(docker compose)
MONGO_VOLUME=$(
    "${COMPOSE[@]}" volumes mongo --quiet | tr -d '\r'
)

if [[ -z "${MONGO_VOLUME}" ]]; then
    echo "No se encontró el volumen de MongoDB asociado a este proyecto." >&2
    exit 1
fi

if [[ "${1:-}" != "--yes" ]]; then
    read -r -p "Esto detendrá los servicios y eliminará el volumen de MongoDB. ¿Continuar? [y/N] " confirmation
    if [[ ! "${confirmation}" =~ ^[Yy]$ ]]; then
        echo "Operación cancelada."
        exit 0
    fi
fi

echo "Deteniendo servicios..."
"${COMPOSE[@]}" down

echo "Eliminando el volumen de MongoDB..."
docker volume rm -f "${MONGO_VOLUME}"

echo "Volumen de MongoDB eliminado correctamente."