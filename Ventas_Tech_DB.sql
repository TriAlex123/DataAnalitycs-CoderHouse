\xef\xbb\xbf/* ============================================================
   Base de datos : Ventas_Tech_DB
   Motor         : Microsoft SQL Server (T-SQL)
   Script        : repetible (se puede ejecutar las veces que se quiera)
   ============================================================ */

-- 0. Creación y selección de la base de datos
IF DB_ID('Ventas_Tech_DB') IS NULL
    CREATE DATABASE Ventas_Tech_DB;
GO

USE Ventas_Tech_DB;
GO

-- 1. Eliminación de tablas (orden inverso a las dependencias)
DROP TABLE IF EXISTS Ventas;
DROP TABLE IF EXISTS Productos;
DROP TABLE IF EXISTS Clientes;
DROP TABLE IF EXISTS Categorias;
GO

-- 2. Creación de tablas
CREATE TABLE Categorias (
    ID_Categoria          INT           NOT NULL,
    Nombre_Categoria      VARCHAR(50)   NOT NULL,
    Descripcion_Categoria VARCHAR(200)  NULL,
    CONSTRAINT PK_Categorias PRIMARY KEY (ID_Categoria)
);
GO

CREATE TABLE Clientes (
    ID_Cliente     INT           NOT NULL,
    Nombre         VARCHAR(100)  NOT NULL,
    Email          VARCHAR(100)  NULL,
    Ciudad         VARCHAR(50)   NULL,
    Fecha_Registro DATE          NOT NULL,
    CONSTRAINT PK_Clientes PRIMARY KEY (ID_Cliente),
    CONSTRAINT UQ_Clientes_Email UNIQUE (Email)
);
GO

CREATE TABLE Productos (
    ID_Producto     INT            NOT NULL,
    Nombre_Producto VARCHAR(100)   NOT NULL,
    ID_Categoria    INT            NULL,
    Precio          DECIMAL(10,2)  NOT NULL,
    Stock           INT            NULL CONSTRAINT DF_Productos_Stock  DEFAULT 0,
    Activo          BIT            NULL CONSTRAINT DF_Productos_Activo DEFAULT 1,
    CONSTRAINT PK_Productos PRIMARY KEY (ID_Producto),
    CONSTRAINT FK_Productos_Categorias FOREIGN KEY (ID_Categoria)
        REFERENCES Categorias (ID_Categoria)
);
GO

CREATE TABLE Ventas (
    ID_Venta        INT            NOT NULL,
    ID_Cliente      INT            NULL,
    ID_Producto     INT            NULL,
    Cantidad        INT            NOT NULL,
    Precio_Unitario DECIMAL(10,2)  NOT NULL,
    Fecha_Ventas    DATE           NOT NULL,
    CONSTRAINT PK_Ventas PRIMARY KEY (ID_Venta),
    CONSTRAINT FK_Ventas_Clientes FOREIGN KEY (ID_Cliente)
        REFERENCES Clientes (ID_Cliente),
    CONSTRAINT FK_Ventas_Productos FOREIGN KEY (ID_Producto)
        REFERENCES Productos (ID_Producto)
);
GO

-- 3. Inserción de datos (respetando el orden de dependencias)
INSERT INTO Categorias (ID_Categoria, Nombre_Categoria, Descripcion_Categoria) VALUES
  (1, 'Computación',    'Laptops, PCs y monitores'),
  (2, 'Accesorios',     'Periféricos y complementos'),
  (3, 'Audio',          'Auriculares y parlantes'),
  (4, 'Almacenamiento', 'Discos y memorias');

INSERT INTO Clientes (ID_Cliente, Nombre, Email, Ciudad, Fecha_Registro) VALUES
  (1, 'María López',  'maria@mail.com',  'Buenos Aires', '2024-01-05'),
  (2, 'Carlos Ruiz',  'carlos@mail.com', 'Córdoba',      '2024-01-10'),
  (3, 'Ana Gómez',    'ana@mail.com',    'Rosario',      '2024-02-01'),
  (4, 'Pedro Sanz',   'pedro@mail.com',  'Mendoza',      '2024-02-15'),
  (5, 'Laura Torres', 'laura@mail.com',  'Tucumán',      '2024-03-01');

INSERT INTO Productos (ID_Producto, Nombre_Producto, ID_Categoria, Precio, Stock, Activo) VALUES
  (1, 'Laptop Pro 15',      1, 1200.00, 15, 1),
  (2, 'Mouse Inalámbrico',  2,   28.00, 80, 1),
  (3, 'Monitor 4K 27',      1,  450.00, 12, 1),
  (4, 'Auriculares BT Pro', 3,  120.00, 35, 1),
  (5, 'SSD Externo 1TB',    4,  130.00, 18, 1),
  (6, 'Teclado Mecánico',   2,   95.00, 40, 1);

INSERT INTO Ventas (ID_Venta, ID_Cliente, ID_Producto, Cantidad, Precio_Unitario, Fecha_Ventas) VALUES
  ( 1, 1, 1, 2, 1200.00, '2024-03-05'),
  ( 2, 2, 2, 5,   28.00, '2024-03-06'),
  ( 3, 3, 3, 1,  450.00, '2024-03-07'),
  ( 4, 1, 4, 2,  120.00, '2024-03-08'),
  ( 5, 4, 5, 3,  130.00, '2024-03-10'),
  ( 6, 2, 6, 4,   95.00, '2024-03-11'),
  ( 7, 5, 1, 1, 1200.00, '2024-03-12'),
  ( 8, 3, 2, 8,   28.00, '2024-03-13'),
  ( 9, 4, 4, 1,  120.00, '2024-03-14'),
  (10, 5, 3, 2,  450.00, '2024-03-15');
GO

-- 4. Validación de contenido
SELECT * FROM Categorias;   -- esperado: 4 filas
SELECT * FROM Clientes;     -- esperado: 5 filas
SELECT * FROM Productos;    -- esperado: 6 filas
SELECT * FROM Ventas;       -- esperado: 10 filas
GO
