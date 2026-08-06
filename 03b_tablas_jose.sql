-- ============================================================
-- Archivo: 03b_tablas_jose.sql
-- Autor: José
-- Capa: 2 (tablas transaccionales)
-- Tablas: detalle_ordenes, envios
-- ============================================================

CREATE TABLE detalle_ordenes (
    id_detalle      SERIAL        PRIMARY KEY,
    id_orden        INT           NOT NULL REFERENCES ordenes(id_orden),
    id_producto     INT           NOT NULL REFERENCES productos(id_producto),
    cantidad        INT           NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL
);

CREATE TABLE envios (
    id_envio              SERIAL       PRIMARY KEY,
    id_orden              INT          NOT NULL REFERENCES ordenes(id_orden),
    id_transportista      INT          NOT NULL REFERENCES transportistas(id_transportista),
    id_empleado           INT          NOT NULL REFERENCES empleados(id_empleado),
    fecha_envio           DATE,
    fecha_entrega_estimada DATE,
    fecha_entrega_real    DATE,
    estado                VARCHAR(20)  NOT NULL,
    numero_seguimiento    VARCHAR(50)
);
