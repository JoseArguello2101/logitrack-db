-- ============================================================
-- Archivo: 03a_tablas_luis.sql
-- Autor: Luis
-- Capa: 2 (tablas transaccionales)
-- Tablas: ordenes, inventario
-- ============================================================

CREATE TABLE ordenes (
    id_orden          SERIAL       PRIMARY KEY,
    id_cliente        INT          NOT NULL REFERENCES clientes(id_cliente),
    fecha_orden       DATE         NOT NULL,
    estado            VARCHAR(20)  NOT NULL,
    direccion_destino VARCHAR(200),
    ciudad_destino    VARCHAR(50),
    region_destino    VARCHAR(50)
);

CREATE TABLE inventario (
    id_inventario        SERIAL    PRIMARY KEY,
    id_producto          INT       NOT NULL REFERENCES productos(id_producto),
    id_ubicacion         INT       NOT NULL REFERENCES ubicaciones(id_ubicacion),
    cantidad             INT       NOT NULL CHECK (cantidad >= 0),
    fecha_actualizacion  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
