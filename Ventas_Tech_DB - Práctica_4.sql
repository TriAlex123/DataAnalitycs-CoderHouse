-- 5. Consultas SQL del negocio (Total Facturado, cantidad de pedidos y ticket promedio por mes)
SELECT
    MONTH(Fecha_Ventas)                  AS Mes,
    SUM(Cantidad * Precio_Unitario)      AS Total_Facturado,
    COUNT(*)                             AS Cantidad_Pedidos,
    AVG(Cantidad * Precio_Unitario)      AS Ticket_Promedio
FROM Ventas
GROUP BY MONTH(Fecha_Ventas)
ORDER BY Mes;
GO

-- 6. Consultas SQL del negocio (Ranking de productos)
SELECT TOP 5
    ID_Producto,
    SUM(Cantidad)                        AS Unidades_Vendidas,
    SUM(Cantidad * Precio_Unitario)      AS Total_Generado
FROM Ventas
GROUP BY ID_Producto
ORDER BY Total_Generado DESC;
GO

-- 7. Consultas SQL del negocio (Concurrencia de clientes)
SELECT
    ID_Cliente,
    COUNT(*)                             AS Cantidad_Pedidos,
    SUM(Cantidad * Precio_Unitario)      AS Total_Gastado
FROM Ventas
GROUP BY ID_Cliente
HAVING COUNT(*) > 1
ORDER BY Total_Gastado DESC;
GO

-- 8. Consultas SQL del Negocio (Productos por encima / por debajo del promedio)
WITH Total_Por_Producto AS (
    SELECT
        ID_Producto,
        SUM(Cantidad * Precio_Unitario) AS Total_Facturado
    FROM Ventas
    GROUP BY ID_Producto
)
SELECT
    ID_Producto,
    Total_Facturado,
    CASE
        WHEN Total_Facturado > (SELECT AVG(Total_Facturado) FROM Total_Por_Producto)
            THEN 'Por Encima'
            ELSE 'Por Debajo'
    END AS Posicion_Vs_Promedio
FROM Total_Por_Producto
ORDER BY Total_Facturado DESC;
GO

-- Comentarios de los hallazgos
-- 1. La facturación se encuentra muy concentrada en un solo producto, ya que el producto 1 genera el 55,9% del total facturado.
-- 2. El producto más vendido es el Mouse Inalámbrico, pero es de los que menos genera ingresos, representa el 44,9% de las unidades totales pero aporta 364.000, el 5,6% de la facturación.
-- 3. Todos los clientes son recurrentes durante el periodo analizado, tambien identificamos que entre el cliente 1 y el cliente 5 se concentran el 73,6% del total de la facturación.