-- ============================================================
-- Archivo: 01b_tablas_antonella.sql
-- Autor: Antonella
-- Capa: 0 (tablas independientes, sin FK)
-- Tablas: bodegas, empleados, transportistas
-- ============================================================

CREATE TABLE bodegas (
    id_bodega     SERIAL        PRIMARY KEY,
    nombre        VARCHAR(50)   NOT NULL,
    direccion     VARCHAR(200),
    ciudad        VARCHAR(50),
    region        VARCHAR(50),
    capacidad_m2  DECIMAL(10,2)
);

CREATE TABLE empleados (
    id_empleado       SERIAL       PRIMARY KEY,
    rut               VARCHAR(12)  UNIQUE NOT NULL,
    nombre            VARCHAR(50)  NOT NULL,
    apellido          VARCHAR(50)  NOT NULL,
    cargo             VARCHAR(50),
    email             VARCHAR(100),
    telefono          VARCHAR(20),
    fecha_contratacion DATE
);

CREATE TABLE transportistas (
    id_transportista  SERIAL       PRIMARY KEY,
    rut               VARCHAR(12)  UNIQUE NOT NULL,
    razon_social      VARCHAR(100) NOT NULL,
    nombre_contacto   VARCHAR(100),
    email             VARCHAR(100),
    telefono          VARCHAR(20),
    tipo_vehiculo     VARCHAR(50)
);
