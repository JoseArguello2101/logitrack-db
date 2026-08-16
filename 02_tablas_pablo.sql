-- ============================================================
-- Archivo: 02_tablas_pablo.sql
-- Autor: Pablo
-- Capa: 1 (tablas con FK a Capa 0)
-- Tablas: productos, ubicaciones, producto_proveedor
-- ============================================================

CREATE TABLE productos (
    id_producto     SERIAL        PRIMARY KEY,
    codigo_sku      VARCHAR(30)   UNIQUE NOT NULL,
    nombre          VARCHAR(100)  NOT NULL,
    descripcion     VARCHAR(300),
    peso_kg         DECIMAL(8,2),
    precio_unitario DECIMAL(10,2),
    id_categoria    INT           NOT NULL REFERENCES categorias(id_categoria)
);

CREATE TABLE ubicaciones (
    id_ubicacion     SERIAL       PRIMARY KEY,
    id_bodega        INT          NOT NULL REFERENCES bodegas(id_bodega),
    codigo           VARCHAR(20)  UNIQUE NOT NULL,
    pasillo          VARCHAR(10),
    estante          VARCHAR(10),
    nivel            VARCHAR(10),
    capacidad_maxima INT
);

CREATE TABLE producto_proveedor (
    id_producto    INT           REFERENCES productos(id_producto),
    id_proveedor   INT           REFERENCES proveedores(id_proveedor),
    costo_unitario DECIMAL(10,2),
    PRIMARY KEY (id_producto, id_proveedor)
);
