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

--Consulta 1 — Resumen ejecutivo mensual

SELECT
    MONTH(fecha_venta) AS Mes,
    SUM(cantidad * precio_unitario) AS Ventas_totales,
    COUNT(id_venta) AS Total_de_pedidos,
    AVG(cantidad * precio_unitario) AS Ticket_de_compra_promedio
FROM
    ventas
GROUP BY
    MONTH(fecha_venta);

--Consulta 2 — Ranking de productos

SELECT TOP 5
    id_producto AS Producto,
    SUM (cantidad) as Cantidad_vendida,
    SUM (cantidad * precio_unitario) as Total_generado
FROM
    ventas
GROUP BY
    id_producto
ORDER BY
    Total_generado DESC;  

--Consulta 3 — Clientes recurrente

SELECT
    id_cliente AS Cliente,
    COUNT(id_venta) AS Total_compras,
    SUM(cantidad * precio_unitario) AS Total_gastado
FROM
    ventas
GROUP BY
    id_cliente
HAVING 
    COUNT(id_venta) > 1;

--Consulta 4 — Meses por encima/por debajo del promedio

SELECT
    MONTH(fecha_venta) AS Mes,
    SUM(cantidad * precio_unitario) AS Total_mensual,
    
    -- comienzo de la subconsulta como "nueva columna llamada: Promedio_general":
    (
        SELECT AVG(total_mes) 
        FROM (
            SELECT SUM(cantidad * precio_unitario) AS total_mes 
            FROM ventas 
            GROUP BY MONTH(fecha_venta)
        ) AS sub
    ) AS Promedio_general,
    -- fin de la subconsulta, termino con una coma porque quiero que el promedio sea una columna más de mi tabla.
    
    -- A continuación, para aplicar la condición a través del CASE debo escribir toda la subconsulta otra vez, 
    --porque SQL procesa todo en el momento y no reconoce el alias que acabamos de asignar a a la subconsulta anteriormente.
    CASE
        WHEN SUM(cantidad * precio_unitario) > (
            SELECT AVG(total_mes) 
            FROM (
                SELECT SUM(cantidad * precio_unitario) AS total_mes 
                FROM ventas 
                GROUP BY MONTH(fecha_venta)
            ) AS sub
        ) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS Resultado
    --fin del CASE
FROM 
    ventas
GROUP BY
    MONTH(fecha_venta);

-- =========================================================================

--Conclusiones: 

--1) El producto Nro 1 concentra el %56,25 de las ventas totales.


--2) El promedio de ventas siempre dará por debajo por varias razones: 
--   a) no se está comparando con otro mes; 
--   b) la consigna del ejercicio no incluye un ">=" sino un ">" por lo que el resultado siempre será "false", caso contrario, las ventas siempre daría "dentro del promedio",
--     por ahora, debido a lo explicado, se detecta aque las compras mensuales estánpor debajo del promedio.


--3)Los 3 productos top son el 1, el 2 y 3, con el menor número de unidades vendidas entre el top 5, de 3 cada una; mientras que el 5 producto más vendido, 
--  alberga más unidades vendidas a un menor valor.

