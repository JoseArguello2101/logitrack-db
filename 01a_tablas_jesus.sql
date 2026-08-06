-- ============================================================
-- Archivo: 01a_tablas_jesus.sql
-- Autor: Jesús
-- Capa: 0 (tablas independientes, sin FK)
-- Tablas: clientes, categorias, proveedores
-- ============================================================

CREATE TABLE clientes (
    id_cliente    SERIAL       PRIMARY KEY,
    rut           VARCHAR(12)  UNIQUE NOT NULL,
    razon_social  VARCHAR(100) NOT NULL,
    nombre_contacto VARCHAR(100),
    email         VARCHAR(100),
    telefono      VARCHAR(20),
    direccion     VARCHAR(200),
    ciudad        VARCHAR(50),
    region        VARCHAR(50)
);

CREATE TABLE categorias (
    id_categoria  SERIAL       PRIMARY KEY,
    nombre        VARCHAR(50)  UNIQUE NOT NULL,
    descripcion   VARCHAR(200)
);

CREATE TABLE proveedores (
    id_proveedor  SERIAL       PRIMARY KEY,
    rut           VARCHAR(12)  UNIQUE NOT NULL,
    razon_social  VARCHAR(100) NOT NULL,
    nombre_contacto VARCHAR(100),
    email         VARCHAR(100),
    telefono      VARCHAR(20),
    direccion     VARCHAR(200),
    ciudad        VARCHAR(50),
    region        VARCHAR(50)
);
