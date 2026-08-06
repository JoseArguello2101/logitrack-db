# LogiTrack SpA — Base de Datos

Base de datos PostgreSQL para el sistema de gestión de almacenamiento, inventario y distribución de LogiTrack SpA.

## Descripción

LogiTrack SpA es una empresa dedicada a la gestión de almacenamiento, inventario y distribución de productos para múltiples clientes a nivel nacional. Opera con varios centros de distribución, administra inventarios en tiempo real y coordina envíos mediante diferentes transportistas.

## Modelo de Datos

La base de datos está normalizada hasta **3NF** y consta de **13 tablas** organizadas en 3 capas:

### Capa 0 — Tablas independientes (sin FK)
| Tabla          | Descripción                                      |
|----------------|--------------------------------------------------|
| `clientes`     | Empresas o personas que solicitan distribución    |
| `categorias`   | Clasificación de productos                       |
| `proveedores`  | Empresas que suministran productos                |
| `bodegas`      | Centros de almacenamiento                        |
| `empleados`    | Personal de LogiTrack                            |
| `transportistas` | Empresas de transporte                        |

### Capa 1 — Tablas con dependencias simples
| Tabla               | Descripción                              | FK                    |
|---------------------|------------------------------------------|-----------------------|
| `productos`         | Artículos almacenados                    | → categorias          |
| `ubicaciones`       | Posiciones dentro de bodegas             | → bodegas             |
| `producto_proveedor`| Relación M:N productos-proveedores       | → productos, proveedores |

### Capa 2 — Tablas transaccionales
| Tabla             | Descripción                              | FK                              |
|-------------------|------------------------------------------|---------------------------------|
| `ordenes`         | Pedidos de clientes                      | → clientes                      |
| `detalle_ordenes` | Líneas de cada orden                     | → ordenes, productos            |
| `inventario`      | Stock por producto y ubicación           | → productos, ubicaciones        |
| `envios`          | Despachos asociados a órdenes            | → ordenes, transportistas, empleados |

## Estructura del Repositorio

```
logitrack-db/
├── README.md
├── modelo_3NF.mermaid
├── 01a_tablas_jesus.sql          — Capa 0: clientes, categorias, proveedores
├── 01b_tablas_antonella.sql      — Capa 0: bodegas, empleados, transportistas
├── 02_tablas_pablo.sql           — Capa 1: productos, ubicaciones, producto_proveedor
├── 03a_tablas_luis.sql           — Capa 2: ordenes, inventario
├── 03b_tablas_jose.sql           — Capa 2: detalle_ordenes, envios
├── 04a_datos_jesus.sql           — Datos: clientes, categorias, proveedores
├── 04b_datos_antonella.sql       — Datos: bodegas, empleados, transportistas
├── 05_datos_pablo.sql            — Datos: productos, ubicaciones, producto_proveedor
├── 06a_datos_luis.sql            — Datos: ordenes, inventario
├── 06b_datos_jose.sql            — Datos: detalle_ordenes, envios
└── ejecutar_todo.sh              — Script de ejecución completa
```

## Equipo

| Integrante | Rama Git                           | Tablas                                     |
|------------|------------------------------------|--------------------------------------------|
| Jesús      | `feat/jesus-tablas-base`           | clientes, categorias, proveedores          |
| Antonella  | `feat/antonella-tablas-base`       | bodegas, empleados, transportistas         |
| Pablo      | `feat/pablo-tablas-dependientes`   | productos, ubicaciones, producto_proveedor |
| Luis       | `feat/luis-tablas-transaccionales` | ordenes, inventario                        |
| José       | `feat/jose-tablas-transaccionales` | detalle_ordenes, envios                    |

## Ejecución

```bash
chmod +x ejecutar_todo.sh
./ejecutar_todo.sh
```

El script crea la base de datos `logitrack_db`, ejecuta los CREATE TABLE en orden de dependencias y luego carga los datos.

## Orden de Merge a main

1. **Jesús** y **Antonella** (en cualquier orden entre sí — sin dependencias)
2. **Pablo** (después de Jesús y Antonella — depende de categorias, bodegas, proveedores)
3. **Luis** y **José** (en cualquier orden entre sí, después de Pablo — dependen de productos, ubicaciones, clientes)

## Reglas de Negocio

- Un cliente puede generar múltiples órdenes
- Cada orden tiene al menos un producto en `detalle_ordenes`
- Un producto pertenece a una única categoría (N:1) y puede tener múltiples proveedores (M:N)
- El inventario se registra por producto + ubicación
- Un envío está asociado a una orden y un transportista
- Un empleado puede gestionar múltiples envíos
- El stock no puede ser negativo (`CHECK cantidad >= 0`)
- Cada bodega tiene múltiples ubicaciones

## Tecnologías

- PostgreSQL 15+
- Git / GitHub
