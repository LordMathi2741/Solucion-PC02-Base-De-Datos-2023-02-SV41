--Pregunta 1 (4 p.)
--Diseñar una función o procedimiento almacenado que permita determinar la cantidad de clientes por tipos de
--categorías de productos para un determinado año (considerar la fecha de pago de la tabla Facturas).CREATE FUNCTION FNTotalClientsBYCategoryAtYear(@year int)  RETURNS TABLE AS   RETURN(	  SELECT COUNT(Id_Cliente) AS Cantidad_Clientes, CP.Nombre_Categoria	  FROM Clientes as C 	  JOIN Pedidos as P on C.Id_Cliente = P.Clientes_id_Cliente	  JOIN Detalle_Pedido as DP on P.Id_pedidos = DP.Pedidos_Id_pedidos 	  JOIN Productos as PO on DP.Productos_Id_Produ = PO.Id_Producto 	  JOIN Categorias_Productos as CP on PO.Categorias_Productos_Id_Categoria = CP.Id_Categoria	  Where YEAR(Fecha) = @year 	  group by CP.Nombre_Categoria )--Pregunta 2 (4 p.)
--Diseñar una función o procedimiento almacenado que permita determinar el(los) cliente(s) que no realizaron
--ningún pedido durante un determinado año (considerar la fecha de pago de la tabla Facturas).

create view TotalOrdersByYear as 
SELECT COUNT(Pedidos_id_pedidos) as TotalOrders, Year(Fecha_Pago) as Anio, Nombre
FROM Clientes as C 
JOIN Pedidos as P on C.Id_Cliente = P.Clientes_Id_Cliente 
JOIN Facturas as F on P.Id_pedidos = F.Pedidos_Id_pedidos
group by  Year(Fecha_Pago)




CREATE FUNCTION FNClientsWithNoOrdersByYear(@year int) 
RETURNS TABLE 
  AS 
    RETURN(
	   SELECT Nombre  
	   FROM TotalOrdersByYear 
	   WHERE TotalOrders = 0 and Anio = @year
	)


--Pregunta 3 (4 p.)
--Diseñar una función o procedimiento almacenado que permita determinar el(los) cliente(s) que más pedidos
--solicitados durante un determinado año (considerar la fecha de pago de la tabla Facturas).


CREATE PROCEDURE USPClientWithMaxOrdersByYear
 @year int
as 
begin
  SELECT Nombre 
  FROM TotalOrdersByYear 
  WHERE Anio = @year and TotalOrders = (SELECT MAX(TotalOrders) 
  FROM TotalOrdersByYear 
  WHERE Anio = @year )

  end

--Pregunta 4 (4 p.)
--Diseñar una función o procedimiento almacenado que permita determinar el(los) productos con la mayor
--cantidad de pedidos para un determinado mes de un determinado año (considerar la fecha de pago de la
--tabla Facturas).create view VTotalProductsByMonthAtYear as SELECT COUNT(Id_pedidos) as TotalOrders, MONTH(Fecha) AS Mes, YEAR(Fecha) AS Anio, Nombre FROM Productos as P JOIN Detalle_Pedido as DP on P.Id_Producto = DP.Productos_Id_Produ JOIN Pedidos as P on DP.Pedidos_Id_pedidos = P.Id_pedidosgroup by MONTH(Fecha), YEAR(Fecha)CREATE PROCEDURE USPMaxOrderBYMonthAtYear    @year int,	@month intas  begin   SELECT Nombre    FROM VTotalProductsByMonthAtYear   WHERE Mes = @month and Anio = @year and TotalOrders = (Select MAX(TotalOrders)   FROM  VTotalProductsByMonthAtYear     WHERE Mes = @month and Anio = @year and TotalOrders  )  end  --Pregunta 5 (4 p.)
--Diseñar el procedimiento almacenado que permita imprimir la cantidad de pedidos y el monto total facturado
--por cada sucursal (tabla Sucursales) para un determinado año (considerar la fecha de pago de la tabla
--Facturas).

create view VTotalOrdersAndTRevenueByStoreByYear as
SELECT COUNT(Id_pedidos) as TotalOrders, Id_Sucursal, SUM(TotalPago) as Revenue, Year(Pedidos) as Anio
FROM  Sucursales as S 
JOIN Clientes as C on S.Id_Sucursal = C.Sucursales_Id_Sucursal 
JOIN Pedidos as P on C.Id_Cliente = P.Clientes_Id_Cliente 
JOIN Facturas as F on P.Id_pedidos = F.Pedidos_Id_pedidos
group by Id_Sucursal, Year(Pedidos)

CREATE PROCEDURE USPTotalOrdersAndRevenueByStoreByYear
     @year int
as 
  begin
    SELECT TotalOrders, Revenue, Id_Sucursal 
	FROM VTotalOrdersAndTRevenueByStoreByYear
	Where Anio = @year
  end