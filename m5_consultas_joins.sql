/* ============================================================
   CONSULTA 1 — El objetivo es unir Ventas con Clientes, Productos 
   y Categorias para obtener en una sola fila el detalle completo 
   de cada venta. Será la fuente de datos principal en Power BI.
   ============================================================ */
SELECT
    v.ID_Venta,
    v.Fecha_Ventas,
    c.ID_Cliente,
    c.Nombre AS Nombre_Cliente,
    c.Ciudad,
    p.Nombre_Producto,
    cat.Nombre_Categoria,
    v.Cantidad,
    v.Precio_Unitario,
    (v.Cantidad * v.Precio_Unitario)  AS Total_Venta
FROM Ventas v
INNER JOIN Clientes   c   ON v.ID_Cliente   = c.ID_Cliente
INNER JOIN Productos  p   ON v.ID_Producto  = p.ID_Producto
INNER JOIN Categorias cat ON p.ID_Categoria = cat.ID_Categoria
ORDER BY v.Fecha_Ventas, v.ID_Venta;
GO
-- Hallazgo: devuelve 10 filas, una por cada venta, con cliente, ciudad, producto y categoría
-- ya resueltos. Esto confirma que no se pierden ventas al cruzar las dimensiones y deja una
-- tabla lista para analizar la facturación por ciudad, por categoría o por fecha.
 
 
/* ============================================================
   CONSULTA 2 — En esta consulta el propósito fue identificar 
   clientes registrados que todavía no realizaron ninguna compra.
   ============================================================ */
SELECT
    c.Nombre,
    c.Email,
    c.Fecha_Registro
FROM Clientes c
LEFT JOIN Ventas v ON c.ID_Cliente = v.ID_Cliente
WHERE v.ID_Venta IS NULL
ORDER BY c.Fecha_Registro;
GO
-- Hallazgo: la consulta devolvió 0 registros, ya que los 5 clientes registrados realizaron al
-- menos una compra. Para el área de CRM implica que no hay clientes registrados sin
-- realizar al menos una compra, por lo que no hace falta una campaña de primera compra y el 
-- esfuerzo puede orientarse a retención y recompra, empezando por los clientes de mayor facturación.
 
 
/* ============================================================
   CONSULTA 3 — Se buscó identificar productos del catálogo que no tienen
   ninguna venta registrada.
   ============================================================ */
SELECT
    p.Nombre_Producto,
    cat.Nombre_Categoria,
    p.Precio
FROM Productos p
LEFT JOIN Categorias cat ON p.ID_Categoria = cat.ID_Categoria
LEFT JOIN Ventas     v   ON p.ID_Producto  = v.ID_Producto
WHERE v.ID_Venta IS NULL
ORDER BY p.Nombre_Producto;
GO
-- Hallazgo: la consulta devolvió 0 registros ya que los 6 productos del catálogo tuvieron al
-- menos una venta en el período analizado. Para el área de Producto implica que no hay
-- artículos sin rotación que retirar o liquidar, y que el foco puede pasar a los de menor
-- facturación para revisar precio o promoción.
 
 
/* ============================================================
   CONSULTA 4 — El propósito fue dividir las ventas en dos tramos 
   de fechas, identificar cada uno con una columna fija "Canal" 
   creada como valor literal y obtener el total de cada origen.
   ============================================================ */
SELECT
    Canal,
    COUNT(*) AS Cantidad_Pedidos,
    SUM(Total_Venta)  AS Total_Facturado
FROM (
    SELECT
        'Tramo 1 (01-10 mar)' AS Canal,
        ID_Venta,
        (Cantidad * Precio_Unitario) AS Total_Venta
    FROM Ventas
    WHERE Fecha_Ventas <= '2024-03-10'
 
    UNION ALL
 
    SELECT
        'Tramo 2 (11-31 mar)' AS Canal,
        ID_Venta,
        (Cantidad * Precio_Unitario) AS Total_Venta
    FROM Ventas
    WHERE Fecha_Ventas > '2024-03-10'
) AS Consolidado
GROUP BY Canal
ORDER BY Canal;
GO
-- Hallazgo: el primer tramo del mes concentra 3620.00 (56,2%) con 5 pedidos y el segundo
-- 2824.00 (43,8%) con otros 5, por lo que la facturación fue algo mayor al inicio del mes.
-- Ambos tramos suman 6444.00, igual al total mensual.
 