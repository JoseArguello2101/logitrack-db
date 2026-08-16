	CREATE TABLE regiones (
    id_region  SERIAL       PRIMARY KEY,
    nombre     VARCHAR(50)  UNIQUE NOT NULL
);

CREATE TABLE ciudades (
    id_ciudad  SERIAL       PRIMARY KEY,
    nombre     VARCHAR(50)  NOT NULL,
    id_region  INT          NOT NULL REFERENCES regiones(id_region),
    UNIQUE (nombre, id_region)
);

CREATE TABLE categorias (
    id_categoria  SERIAL       PRIMARY KEY,
    nombre        VARCHAR(50)  UNIQUE NOT NULL,
    descripcion   VARCHAR(200)
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

CREATE TABLE bodegas (
    id_bodega     SERIAL        PRIMARY KEY,
    nombre        VARCHAR(50)   NOT NULL,
    direccion     VARCHAR(200),
    id_ciudad     INT           REFERENCES ciudades(id_ciudad),
    capacidad_m2  DECIMAL(10,2)
);

CREATE TABLE areas (
    id_area    SERIAL      PRIMARY KEY,
    id_bodega  INT         NOT NULL REFERENCES bodegas(id_bodega),
    nombre     VARCHAR(50) NOT NULL  -- ej: 'Despacho', 'Recepción', 'Picking'
);

CREATE TABLE clientes (
    id_cliente      SERIAL       PRIMARY KEY,
    rut             VARCHAR(12)  UNIQUE NOT NULL,
    razon_social    VARCHAR(100) NOT NULL,
    nombre_contacto VARCHAR(100),
    email           VARCHAR(100),
    telefono        VARCHAR(20),
    direccion       VARCHAR(200),
    id_ciudad       INT          REFERENCES ciudades(id_ciudad)
);

CREATE TABLE proveedores (
    id_proveedor  SERIAL       PRIMARY KEY,
    rut           VARCHAR(12)  UNIQUE NOT NULL,
    razon_social  VARCHAR(100) NOT NULL,
    nombre_contacto VARCHAR(100),
    email         VARCHAR(100),
    telefono      VARCHAR(20),
    direccion     VARCHAR(200),
    id_ciudad       INT          REFERENCES ciudades(id_ciudad)
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

CREATE TABLE producto (
    id_producto     SERIAL        PRIMARY KEY,
    codigo_sku      VARCHAR(30)   UNIQUE NOT NULL,
    nombre          VARCHAR(100)  NOT NULL,
    descripcion     VARCHAR(300),
    peso_kg         DECIMAL(8,2),
    precio_unitario DECIMAL(10,2),
    id_categoria    INT           NOT NULL REFERENCES categorias(id_categoria)
);

ALTER TABLE producto RENAME TO productos;

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

CREATE TABLE ordenes (
    id_orden           SERIAL       PRIMARY KEY,
    id_cliente         INT          NOT NULL REFERENCES clientes(id_cliente),
    fecha_orden        DATE         NOT NULL,
    estado              VARCHAR(20)  NOT NULL,
    direccion_destino  VARCHAR(200),
    id_ciudad_destino  INT          REFERENCES ciudades(id_ciudad)
);

CREATE TABLE inventario (
    id_inventario        SERIAL    PRIMARY KEY,
    id_producto          INT       NOT NULL REFERENCES productos(id_producto),
    id_ubicacion         INT       NOT NULL REFERENCES ubicaciones(id_ubicacion),
    cantidad             INT       NOT NULL CHECK (cantidad >= 0),
    fecha_actualizacion  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

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

ALTER TABLE empleados ADD COLUMN id_area INT REFERENCES areas(id_area);

========================

Punto 4 hasta punto 6 

=======================

CREATE TABLE auditoria_inventario (
    id_auditoria        SERIAL        PRIMARY KEY,
    id_inventario        INT           NOT NULL REFERENCES inventario(id_inventario),
    id_empleado          INT           NOT NULL REFERENCES empleados(id_empleado),
    tipo_movimiento      VARCHAR(20)   NOT NULL,  -- ej: 'entrada', 'salida', 'ajuste', 'traslado'
    cantidad_anterior    INT           NOT NULL,
    cantidad_nueva       INT           NOT NULL,
    fecha_modificacion   TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE auditoria_inventario ADD COLUMN observacion VARCHAR(200);
ALTER TABLE auditoria_inventario DROP COLUMN observacion;
DROP TABLE auditoria_inventario;

INSERT INTO clientes (rut, razon_social, nombre_contacto, email, telefono, direccion, id_ciudad)
VALUES ('12345678-9', 'Comercial Andes SpA', 'Juan Pérez', 'jperez@andes.cl', '+56912345678', 'Av. Libertador 450', 1);
INSERT INTO productos (codigo_sku, nombre, descripcion, peso_kg, precio_unitario, id_categoria)
VALUES ('SKU-00123', 'Taladro Percutor 750W', 'Taladro percutor eléctrico, mandril de 13mm', 2.30, 45990, 1);

UPDATE inventario
SET cantidad = 100,
    fecha_actualizacion = CURRENT_TIMESTAMP
    WHERE id_producto = 1 AND id_ubicacion = 1;


UPDATE proveedores
SET email    = 'contacto@nuevoproveedor.cl',
    telefono = '+56987654321'
WHERE id_proveedor = 1;

SELECT * FROM ordenes WHERE id_cliente = 5;

-- 1. Borrar detalle_ordenes de las órdenes de ese cliente
DELETE FROM detalle_ordenes
WHERE id_orden IN (SELECT id_orden FROM ordenes WHERE id_cliente = 5);
-- 2. Borrar envios de esas órdenes
DELETE FROM envios
WHERE id_orden IN (SELECT id_orden FROM ordenes WHERE id_cliente = 5);
-- 3. Borrar las órdenes del cliente
DELETE FROM ordenes
WHERE id_cliente = 5;
-- 4. Ahora sí, borrar el cliente
DELETE FROM clientes
WHERE id_cliente = 5;

SELECT * FROM clientes ORDER BY id_cliente DESC LIMIT 5;

SELECT * FROM productos ORDER BY id_producto DESC LIMIT 5;

SELECT * FROM inventario ORDER BY id_inventario DESC LIMIT 5;

SELECT columnas
FROM tabla_A
JOIN tabla_B ON tabla_A.columna_fk = tabla_B.columna_pk;

SELECT o.id_orden , c.razon_social 
FROM ordenes o 
JOIN clientes  c ON  o.id_cliente = c.id_cliente;

SELECT o.id_orden , c.razon_social 
FROM ordenes o 
JOIN clientes  c ON  o.id_cliente = c.id_cliente;

SELECT d.id_orden,
       p.nombre AS producto,
       cat.nombre AS categoria,
       d.cantidad,
       d.precio_unitario
FROM detalle_ordenes d
JOIN productos p ON d.id_producto = p.id_producto
JOIN categorias cat ON p.id_categoria = cat.id_categoria
ORDER BY d.id_orden;

SELECT e.id_envio,
       o.id_orden,
       cli.razon_social AS cliente,
       t.razon_social AS transportista,
	   emp.nombre || ' ' || emp.apellido AS empleado_responsable,
       e.estado,
       e.fecha_envio
FROM envios e
JOIN ordenes o ON e.id_orden = o.id_orden
JOIN clientes cli ON o.id_cliente = cli.id_cliente
JOIN transportistas t ON e.id_transportista = t.id_transportista
JOIN empleados emp ON e.id_empleado = emp.id_empleado
==================================================================

========================

Punto 7 hasta punto 9 

=======================

SELECT 
    p.id_producto,
    p.nombre,
    SUM(i.cantidad) AS stock_total
FROM productos p
INNER JOIN inventario i ON p.id_producto = i.id_producto
GROUP BY p.id_producto, p.nombre
HAVING SUM(i.cantidad) <= 10;

SELECT 
    b.id_bodega,
    b.nombre AS bodega,
    SUM(i.cantidad) AS total_productos
FROM bodegas b
INNER JOIN ubicaciones u ON b.id_bodega = u.id_bodega
INNER JOIN inventario i ON u.id_ubicacion = i.id_ubicacion
GROUP BY b.id_bodega, b.nombre;

SELECT 
    pr.id_proveedor,
    pr.razon_social AS proveedor,
    p.nombre AS producto,
    pp.costo_unitario
FROM productos p
INNER JOIN producto_proveedor pp ON p.id_producto = pp.id_producto
INNER JOIN proveedores pr       ON pp.id_proveedor = pr.id_proveedor;
=========================================================================
