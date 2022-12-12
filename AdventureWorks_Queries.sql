-- 1  Write a query using a WHERE clause that displays all the employees listed in the HumanResources.Employee table who have the job title Research and Development Engineer. Display the business entity ID number, the login ID, and the title for each one.

SELECT BusinessEntityID,
       LoginID,
       JobTitle
FROM HumanResources.Employee
WHERE JobTitle = 'Research and Development Engineer';

--2 Write a query using a WHERE clause that displays all the names in Person.Person with the middle name J. Display the first, last, and middle names along with the ID numbers.

SELECT FirstName,
       LastName,
       MiddleName,
       BusinessEntityID
FROM Person.Person
WHERE MiddleName = 'J';

--3 Write a query displaying all the columns of the Production.ProductCostHistory table from the rows that were modified on June 17, 2003.

SELECT *
FROM Production.ProductCostHistory
WHERE ModifiedDate = '2003-06-17' --4 Rewrite the query you wrote in question 1, changing it so that the employees who do not have the  title Research and Development Engineer are displayed.

    SELECT BusinessEntityID,
           LoginID,
           JobTitle
    FROM HumanResources.Employee WHERE JobTitle <> 'Research and Development Engineer';

--5 Write a query that displays all the rows from the Person.Person table where the rows were modified after December 29, 2000. Display the business entity ID number, the name columns, and the modified date.

SELECT BusinessEntityID,
       FirstName,
       MiddleName,
       LastName,
       ModifiedDate
FROM Person.Person
WHERE ModifiedDate > '2000-12-29';

--6 Rewrite the last query so that the rows that were not modified on December 29, 2000, are displayed.

SELECT BusinessEntityID,
       FirstName,
       MiddleName,
       LastName,
       ModifiedDate
FROM Person.Person
WHERE ModifiedDate <> '2000-12-29';

--7 Rewrite the query from the previous questions so that it displays the rows modified during December 2000.

SELECT BusinessEntityID,
       FirstName,
       MiddleName,
       LastName,
       ModifiedDate
FROM Person.Person
WHERE ModifiedDate BETWEEN '2000-12-01' AND '2000-12-31';

--8 Rewrite the query from the previous question so that it displays the rows that were not modified during December 2000.

SELECT BusinessEntityID,
       FirstName,
       MiddleName,
       LastName,
       ModifiedDate
FROM Person.Person
WHERE ModifiedDate NOT BETWEEN '2000-12-01' AND '2000-12-31';

--9 Write a query displaying the ProductID, Name, and Color columns from rows in the Production.Product table. Display only those rows in which the color is NULL.

SELECT ProductID,
       Name,
       Color
FROM Production.Product
WHERE Color IS NULL;

--10 Write a query displaying the ProductID, Name, and Color columns from rows in the Production.Product table. Display only those rows in which the color is not blue.

SELECT ProductID,
       Name,
       Color
FROM Production.Product
WHERE Color <> 'Blue';

--11 Write a query displaying ProductID, Name, Style, Size, and Color from the Production.Product table. Include only those rows where at least one of the Style, Size, or Color columns contains a value.

SELECT ProductID,
       Name,
       Style,
       Size,
       Color
FROM Production.Product
WHERE (Style IS NOT NULL)
    OR (Size IS NOT NULL)
    OR (Color IS NOT NULL);

--12 Write a query that returns the business entity ID and name columns from the Person.Person table. Sort the results by LastName, FirstName, and MiddleName.

SELECT BusinessEntityID,
       LastName,
       FirstName,
       MiddleName
FROM Person.Person
ORDER BY LastName,
         FirstName,
         MiddleName;

--13 Modify the query written in the previous question so that the data is returned in the opposite order.

SELECT BusinessEntityID,
       LastName,
       FirstName,
       MiddleName
FROM Person.Person
ORDER BY LastName DESC,
         FirstName DESC,
         MiddleName DESC --14 Write a query that displays in the “AddressLine1 (City PostalCode)” format from the Person.Address table.

SELECT AddressLine1 + ' (' + City + ' '+ PostalCode + ')'
FROM Person.Address;

--15 Write a query using the Production.Product table displaying the product ID, color, and name columns. If the color column contains a NULL value, replace the color with No Color.

SELECT ProductID,
       ISNULL(Color,'No Color'),
       Name
FROM Production.Product;

--16 Modify the query written in the previous questions so that the description of the product is displayed in the “Name: Color” format. Make sure that all rows display a value even if the Color value is missing.

SELECT Name + ': ' + ISNULL(Color,'No Color')
FROM Production.Product;

--17 Write a query using the Sales.SpecialOffer table. Display the difference between the MinQty and MaxQty columns along with the SpecialOfferID and Description columns.

SELECT SpecialOfferID,
       Description,
       MaxQty-MinQty AS QtyDifference
FROM Sales.SpecialOffer;

--18 Write a query using the Sales.SpecialOffer table. Multiply the MinQty column by the DiscountPct column. Include the SpecialOfferID and Description columns in the results.

SELECT SpecialOfferID,
       Description,
       MinQty*DiscountPct AS MinDiscount
FROM Sales.SpecialOffer;

--19 Write a query using the Sales.SpecialOffer table that multiplies the MaxQty column by the DiscountPCT column. If the MaxQty value is null, replace it with the value 10. Include the SpecialOfferID and Description columns in the results.

SELECT SpecialOfferID,
       Description,
       ISNULL(MaxQty, 10)*DiscountPct AS MaxDiscount
FROM Sales.SpecialOffer;

--20 Write a query that displays the first 10 characters of the AddressLine1 column in the Person.Address table.

SELECT CAST(AddressLine1 AS varchar(10))
FROM Person.Address;

--ALT 20

SELECT LEFT(AddressLine1, 10) AS Address10
FROM Person.Address;

--21 Write a query that displays characters 10 to 15 of the AddressLine1 column in the Person.Address table.

SELECT SUBSTRING(AddressLine1, 10, 6) AS Address10to15
FROM Person.Address;

--22 Write a query displaying the first name and last name from the Person.Person table all in uppercase.

SELECT UPPER(FirstName),
       UPPER(LastName)
FROM Person.Person;

--23 The product number in the Production.Product contains a hyphen (-). Write a query that uses the SUBSTRING function and the CHARINDEX function to display the characters in the product number following the hyphen.

SELECT SUBSTRING(ProductNumber, CHARINDEX('-', ProductNumber)+1, MAX(LEN(ProductNumber)))
FROM Production.Product;

--24 Write a query that calculates the number of days between the date an order was placed and the date that it was shipped using the Sales.SalesOrderHeader table. Include the SalesOrderID, OrderDate, and ShipDate columns.

SELECT SalesOrderID,
       OrderDate,
       ShipDate,
       DATEDIFF(d, OrderDate, ShipDate) AS ShippingTime
FROM Sales.SalesOrderHeader;

--25 Write a query that displays only the date, not the time, for the order date and ship date in the Sales.SalesOrderHeader table.

SELECT CONVERT(varchar(10), OrderDate, 110),
       CONVERT(varchar(10), ShipDate, 110)
FROM Sales.SalesOrderHeader;

--26 Write a query that adds six months to each order date in the Sales.SalesOrderHeader table. Include the SalesOrderID and OrderDate columns.

SELECT CONVERT(varchar(10), OrderDate, 110) AS Orders,
       CONVERT(varchar(10), ShipDate, 110) AS Shipping,
       CONVERT(varchar(10), DATEADD(MONTH, 6, OrderDate), 110) AS Reorder
FROM Sales.SalesOrderHeader --27 Write a query that displays the year of each order date and the numeric month of each order date in separate columns in the results. Include the SalesOrderID and OrderDate columns.

SELECT CONVERT(varchar(10), OrderDate, 110) AS Orders,
       CONVERT(varchar(10), ShipDate, 110) AS Shipping,
       DATEPART(yyyy, OrderDate) AS Year,
       DATEPART(mm, OrderDate) AS Month
FROM Sales.SalesOrderHeader --28 Change the query written in the previous question to display the month name instead.

SELECT CONVERT(varchar(10), OrderDate, 110) AS Orders,
       CONVERT(varchar(10), ShipDate, 110) AS Shipping,
       DATEPART(yyyy, OrderDate) AS Year,
       DATENAME(month, OrderDate) AS Month
FROM Sales.SalesOrderHeader