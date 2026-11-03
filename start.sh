#!/usr/bin/env bash

set -Eeuo pipefail

# Evita que Git Bash convierta rutas internas del contenedor en rutas de Windows.
export MSYS_NO_PATHCONV=1

COMPOSE=(docker compose)
MONGO_USER="admin"
MONGO_PASSWORD="admin_pass"
MONGO_AUTH_DATABASE="admin"

cleanup() {
    echo "Deteniendo servicios..."
    "${COMPOSE[@]}" down
}

wait_for_mongo() {
    local attempts=0

    echo "Esperando a que MongoDB esté disponible..."
    until "${COMPOSE[@]}" exec -T mongo mongosh \
        --quiet \
        --username "${MONGO_USER}" \
        --password "${MONGO_PASSWORD}" \
        --authenticationDatabase "${MONGO_AUTH_DATABASE}" \
        --eval "db.adminCommand('ping').ok" 2>/dev/null | grep -q "1"; do
        attempts=$((attempts + 1))
        if [[ "${attempts}" -ge 60 ]]; then
            echo "MongoDB no estuvo disponible después de 60 intentos." >&2
            exit 1
        fi
        sleep 2
    done
}

initialize_mongo() {
    local user_exists

    user_exists=$("${COMPOSE[@]}" exec -T mongo mongosh \
        --quiet \
        --username "${MONGO_USER}" \
        --password "${MONGO_PASSWORD}" \
        --authenticationDatabase "${MONGO_AUTH_DATABASE}" \
        --eval "db.getSiblingDB('user').getUser('user') !== null" \
        | tr -d '\r' | tail -n 1)

    if [[ "${user_exists}" == "true" ]]; then
        echo "Las bases de datos ya están inicializadas."
        return
    fi

    echo "Inicializando usuarios y bases de datos..."
    "${COMPOSE[@]}" exec -T mongo mongosh \
        --quiet \
        --username "${MONGO_USER}" \
        --password "${MONGO_PASSWORD}" \
        --authenticationDatabase "${MONGO_AUTH_DATABASE}" \
        /tmp/mongo-init.js
}

trap cleanup INT TERM

echo "Levantando únicamente MongoDB..."
"${COMPOSE[@]}" up -d mongo
wait_for_mongo
initialize_mongo

echo "Levantando el resto de servicios..."
"${COMPOSE[@]}" up -d
echo "Servicios iniciados correctamente."
