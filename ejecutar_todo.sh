#!/bin/bash
# ============================================================
# Script: ejecutar_todo.sh
# Descripción: Crea la base de datos logitrack_db y ejecuta
#              todos los archivos SQL en orden de dependencias.
# Uso: ./ejecutar_todo.sh
# ============================================================

set -e

DB_NAME="logitrack_db"
DB_USER="${PGUSER:-postgres}"
DB_HOST="${PGHOST:-localhost}"
DB_PORT="${PGPORT:-5432}"

echo "============================================"
echo " LogiTrack SpA — Inicialización de BD"
echo "============================================"

echo ""
echo "[1/3] Creando base de datos '$DB_NAME'..."
psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -c "DROP DATABASE IF EXISTS $DB_NAME;"
psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -c "CREATE DATABASE $DB_NAME;"

echo ""
echo "[2/3] Creando tablas en orden de dependencias..."

TABLAS=(
    "01a_tablas_jesus.sql"
    "01b_tablas_antonella.sql"
    "02_tablas_pablo.sql"
    "03a_tablas_luis.sql"
    "03b_tablas_jose.sql"
)

for archivo in "${TABLAS[@]}"; do
    echo "  -> Ejecutando $archivo"
    psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f "$archivo"
done

echo ""
echo "[3/3] Insertando datos..."

DATOS=(
    "04a_datos_jesus.sql"
    "04b_datos_antonella.sql"
    "05_datos_pablo.sql"
    "06a_datos_luis.sql"
    "06b_datos_jose.sql"
)

for archivo in "${DATOS[@]}"; do
    echo "  -> Ejecutando $archivo"
    psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -f "$archivo"
done

echo ""
echo "============================================"
echo " Base de datos '$DB_NAME' lista."
echo "============================================"
