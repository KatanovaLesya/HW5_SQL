-- Задание 6. Используя вложенные запросы и ShopDB получить имена покупателей и имена сотрудников 
-- у которых TotalPrice товара больше 1000


CREATE TEMPORARY TABLE TmpTable
SELECT 	
(SELECT FName FROM Employees WHERE EmployeeID = 
		(SELECT EmployeeID FROM Orders WHERE Orders.OrderID = OrderDetails.OrderID)
		) AS FName,
(SELECT LName FROM Employees WHERE EmployeeID = 
		(SELECT EmployeeID FROM Orders WHERE Orders.OrderID = OrderDetails.OrderID)
		) AS LName,
(SELECT MName FROM Employees WHERE EmployeeID = 
        (SELECT EmployeeID FROM Orders WHERE Orders.OrderID = OrderDetails.OrderID)
		) AS MName, TotalPrice as Total
FROM OrderDetails
;

SELECT FName, LName, MName, SUM(TotalPrice) AS TotalSold  FROM TmpTable
GROUP BY FName, LName, MName
HAVING SUM(TotalPrice) > 1000;


CREATE TEMPORARY TABLE TmpTable2
SELECT 	
(SELECT FName FROM Customers WHERE CustomerNo = 
		(SELECT CustomerNo FROM Orders WHERE Orders.OrderID = OrderDetails.OrderID)
		) AS FName,
(SELECT LName FROM Customers WHERE CustomerNo = 
		(SELECT CustomerNo FROM Orders WHERE Orders.OrderID = OrderDetails.OrderID)
		) AS LName,
(SELECT MName FROM Customers WHERE CustomerNo = 
        (SELECT CustomerNo FROM Orders WHERE Orders.OrderID = OrderDetails.OrderID)
		) AS MName, TotalPrice 
FROM OrderDetails
;

SELECT FName, LName, MName, SUM(TotalPrice) AS TotalSold  FROM TmpTable2
GROUP BY FName, LName, MName
HAVING SUM(TotalPrice) > 1000;