--Pregunta 1 (4 p.)
--Dise�ar una funci�n o procedimiento almacenado que permita determinar la cantidad de clientes por tipos de
--categor�as de productos para un determinado a�o (considerar la fecha de pago de la tabla Facturas).
--Dise�ar una funci�n o procedimiento almacenado que permita determinar el(los) cliente(s) que no realizaron
--ning�n pedido durante un determinado a�o (considerar la fecha de pago de la tabla Facturas).

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
--Dise�ar una funci�n o procedimiento almacenado que permita determinar el(los) cliente(s) que m�s pedidos
--solicitados durante un determinado a�o (considerar la fecha de pago de la tabla Facturas).


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
--Dise�ar una funci�n o procedimiento almacenado que permita determinar el(los) productos con la mayor
--cantidad de pedidos para un determinado mes de un determinado a�o (considerar la fecha de pago de la
--tabla Facturas).
--Dise�ar el procedimiento almacenado que permita imprimir la cantidad de pedidos y el monto total facturado
--por cada sucursal (tabla Sucursales) para un determinado a�o (considerar la fecha de pago de la tabla
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