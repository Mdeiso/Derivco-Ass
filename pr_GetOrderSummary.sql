CREATE PROCEDURE pr_GetOrderSummary
    @StartDate DATE,
    @EndDate DATE,
    @EmployeeID INT = NULL,
    @CustomerID NVARCHAR(5) = NULL
AS
BEGIN
    SELECT 
        CONCAT(E.TitleOfCourtesy, ' ', E.FirstName, ' ', E.LastName) AS 'EmployeeFullName',
        S.CompanyName AS 'ShipperCompanyName',
        C.CompanyName AS 'CustomerCompanyName',
        COUNT(O.OrderID) AS 'NumberOfOrders',
        CAST(O.OrderDate AS DATE) AS 'Date',
        SUM(O.Freight) AS 'TotalFreightCost',
        COUNT(DISTINCT OD.ProductID) AS 'NumberOfDifferentProducts',
        SUM(OD.UnitPrice * OD.Quantity) AS 'TotalOrderValue'
    FROM Orders O
    INNER JOIN Employees E ON O.EmployeeID = E.EmployeeID
    INNER JOIN Shippers S ON O.ShipperID = S.ShipperID
    INNER JOIN Customers C ON O.CustomerID = C.CustomerID
    INNER JOIN [OrderDetails] OD ON O.OrderID = OD.OrderID
    WHERE O.OrderDate BETWEEN @StartDate AND @EndDate
    AND (@EmployeeID IS NULL OR O.EmployeeID = @EmployeeID)
    AND (@CustomerID IS NULL OR O.CustomerID = @CustomerID)
    GROUP BY
        CONCAT(E.TitleOfCourtesy, ' ', E.FirstName, ' ', E.LastName),
        S.CompanyName,
        C.CompanyName,
        CAST(O.OrderDate AS DATE)
    ORDER BY
        CAST(O.OrderDate AS DATE),
        CONCAT(E.TitleOfCourtesy, ' ', E.FirstName, ' ', E.LastName),
        S.CompanyName,
        C.CompanyName;
END;
