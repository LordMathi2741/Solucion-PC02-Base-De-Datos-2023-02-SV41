--Pregunta 1

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



--Pregunta 3

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

--Pregunta 4 

go
create view VTotalOrdersAndTRevenueByStoreByYear as
SELECT COUNT(Id_pedidos) as TotalOrders, Id_Sucursal, SUM(TotalPago) as Revenue, Year(Pedidos) as Anio
FROM  Sucursales as S 
JOIN Clientes as C on S.Id_Sucursal = C.Sucursales_Id_Sucursal 
JOIN Pedidos as P on C.Id_Cliente = P.Clientes_Id_Cliente 
JOIN Facturas as F on P.Id_pedidos = F.Pedidos_Id_pedidos
group by Id_Sucursal, Year(Pedidos)

go
CREATE PROCEDURE USPTotalOrdersAndRevenueByStoreByYear
     @year int
as 
  begin
    SELECT TotalOrders, Revenue, Id_Sucursal 
	FROM VTotalOrdersAndTRevenueByStoreByYear
	Where Anio = @year
  end