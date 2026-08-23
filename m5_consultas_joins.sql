CREATE DATABASE ventas_tech_DB;
USE ventas_tech_DB;


DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS clientes;

CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY,
    nombre_categoria VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200)
    );

CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR (100) NOT NULL,
    email VARCHAR (100) UNIQUE,
    ciudad VARCHAR (50),
    fecha_registro DATE NOT NULL
    );

    CREATE TABLE productos (

    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    id_categoria INT,
    precio DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0,
    activo TINYINT DEFAULT 1,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE ventas (
    id_venta INT PRIMARY KEY,
    id_cliente INT,
    id_producto INT,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    fecha_venta DATE NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

--Carga de datos en tabla: categorías
INSERT INTO categorias VALUES (1, 'Computación', 'Laptops, PCs y monitores');
INSERT INTO categorias VALUES (2, 'Accesorios', 'Periféricos y complementos');
INSERT INTO categorias VALUES (3, 'Audio', 'Auriculares y parlantes');
INSERT INTO categorias VALUES (4, 'Almacenamiento', 'Discos y memorias');

-- Carga de datos en tabla: clientes
INSERT INTO clientes VALUES (1, 'María López',   'maria@mail.com',   'Buenos Aires', '2024-01-05');
INSERT INTO clientes VALUES (2, 'Carlos Ruiz',   'carlos@mail.com',  'Córdoba',      '2024-01-10');
INSERT INTO clientes VALUES (3, 'Ana Gómez',     'ana@mail.com',     'Rosario',      '2024-02-01');
INSERT INTO clientes VALUES (4, 'Pedro Sanz',    'pedro@mail.com',   'Mendoza',      '2024-02-15');
INSERT INTO clientes VALUES (5, 'Laura Torres',  'laura@mail.com',   'Tucumán',      '2024-03-01');

-- Carga de datos en tabla: productos
INSERT INTO productos VALUES (1, 'Laptop Pro 15',       1, 1200.00, 15, 1);
INSERT INTO productos VALUES (2, 'Mouse Inalámbrico',   2,   28.00, 80, 1);
INSERT INTO productos VALUES (3, 'Monitor 4K 27"',      1,  450.00, 12, 1);
INSERT INTO productos VALUES (4, 'Auriculares BT Pro',  3,  120.00, 35, 1);
INSERT INTO productos VALUES (5, 'SSD Externo 1TB',     4,  130.00, 18, 1);
INSERT INTO productos VALUES (6, 'Teclado Mecánico',    2,   95.00, 40, 1);

--Carga de datos en tabla: ventas
INSERT INTO ventas VALUES (1,  1, 1, 2, 1200.00, '2024-03-05');
INSERT INTO ventas VALUES (2,  2, 2, 5,   28.00, '2024-03-06');
INSERT INTO ventas VALUES (3,  3, 3, 1,  450.00, '2024-03-07');
INSERT INTO ventas VALUES (4,  1, 4, 2,  120.00, '2024-03-08');
INSERT INTO ventas VALUES (5,  4, 5, 3,  130.00, '2024-03-10');
INSERT INTO ventas VALUES (6,  2, 6, 4,   95.00, '2024-03-11');
INSERT INTO ventas VALUES (7,  5, 1, 1, 1200.00, '2024-03-12');
INSERT INTO ventas VALUES (8,  3, 2, 8,   28.00, '2024-03-13');
INSERT INTO ventas VALUES (9,  4, 4, 1,  120.00, '2024-03-14');
INSERT INTO ventas VALUES (10, 5, 3, 2,  450.00, '2024-03-15');

-- =========================================================================

--Consulta 1 — Vista base del proyecto (INNER JOIN) 

SELECT
    v.fecha_venta AS Fecha,
    c.nombre AS Nombre,
    c.ciudad AS Region,
    p.nombre_producto AS Nombre_Producto,
    cat.nombre_categoria AS Categoria,
    v.cantidad AS Cantidad,
    v.precio_unitario AS Precio_Unitario,
    (v.cantidad * v.precio_unitario) AS Total_Venta
FROM ventas AS v
INNER JOIN clientes AS c ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p ON v.id_producto = p.id_producto
INNER JOIN categorias AS cat ON p.id_categoria = cat.id_categoria;

--Consulta 2 -  Clientes sin ventas (LEFT JOIN)

SELECT
    c.nombre AS Nombre,
    c.email AS Email,
    c.fecha_registro AS Fecha_Registro
FROM clientes AS c
LEFT JOIN ventas AS v 
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

--Consulta 3 -  Productos sin ventas (LEFT JOIN)

SELECT
    p.nombre_producto AS Nombre_Producto,
    cat.nombre_categoria AS Nombre_Categoria,
    p.precio AS Precio
FROM productos AS p
INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas AS v
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

--Consulta 4 — Consolidado por canal (UNION ALL)

WITH ventas_consolidadas AS (
SELECT 
    'Online' AS canal,
    id_venta,
    (cantidad * precio_unitario) AS monto
FROM ventas
WHERE id_venta <= 5

UNION ALL

SELECT 
    'Presencial' AS canal,
    id_venta,
    (cantidad * precio_unitario) AS monto
FROM ventas
WHERE id_venta > 5)

SELECT 
    canal AS Canal,
    SUM(monto) AS Total_Venta
FROM ventas_consolidadas
GROUP BY canal;