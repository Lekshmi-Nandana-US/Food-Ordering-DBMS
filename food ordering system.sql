Create database food_ordering_system
use food_ordering_system


create table Customers(
   CustomerId int Primary key IDENTITY(1,1),
   Name varchar(100) Not null,
   Email VARCHAR(100) UNIQUE NOT NULL,
   Phone CHAR(10) NOT NULL,
   Address VARCHAR(200)
);
INSERT INTO Customers (Name, Email, Phone, Address)
VALUES 
('Rahul R', 'rahul@example.com', '9998877665', 'Bangalore'),
('Sneha M', 'sneha@example.com', '8887766554', 'Kochi'),
('Ajay Kumar', 'ajayk@example.com', '7776655443', 'Hyderabad'),
('Karan Rai', 'karanp@example.com','5678956789', 'Delhi'),
('Ankit Bind', 'ankitg@example.com', '2345678789', 'Punjab'),
('Anurag khushwaha', 'anurag@example.com', '4567897896', 'Darbhanga'),
('Rahul Jha', 'rahuljha@example.com', '5678965432', 'phagwara'),
('Priya Rani', 'priya@example.com', '7654567893', 'varansi');

select distinct address
from customers

select * from Customers;


CREATE TABLE Menu (
    ItemID int PRIMARY KEY IDENTITY(101,1),
    ItemName VARCHAR(100) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK (Price > 0)
	);


INSERT INTO Menu (ItemName, Category, Price)
VALUES 
('Veg Burger', 'Fast Food', 120.00),
('Chicken Pizza', 'Fast Food', 250.00),
('Cold Coffee', 'Beverage', 90.00),
('Paneer Wrap', 'Fast Food', 150.00),
('Noodles', 'Fast Food', 80.00),
('Rice Ball', 'Fast Food', 100.00),
('Ice Cream', 'Dessert',60.00),
('Brownie', 'Dessert',100.00);

select 
substring(itemName,1,5)
as '4char'
from Menu

select * from Menu
select count(*) as number
from menu

select * 
from menu 
order by Price asc

update menu
set itemname='Brownie'
where ItemName='Rice ball' and price=100 and Category='Dessert'

alter table menu
add quantity_left int

alter table menu
drop column quantity_left 



CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1001,1),
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL DEFAULT GETDATE(),--------------<
    TotalAmount DECIMAL(10,2) CHECK (TotalAmount >= 0),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
        ON DELETE CASCADE--------------------<
        ON UPDATE CASCADE-------------------<
);

select * from  customers
join orders
on customers.customerID=orders.customerID


INSERT INTO Orders (CustomerID, TotalAmount)
VALUES 
(1,220),--veg burger,brownie
(3,170),--cold coffee,noodles
(6,310),--chicken pizza,Ice cream
(2,300),--2xPaneer wrap
(4,100);--rice bowl

select c.NAME , O.OrderDate 
FROM CUSTOMERS AS C
FULL JOIN ORDERS AS O
ON C.CustomerId=O.CustomerID




CREATE TABLE OrderDetails(---2 foregin key 
    DetailID INT PRIMARY KEY IDENTITY(10001,1),
    OrderID INT NOT NULL,
    ItemID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (ItemID) REFERENCES Menu(ItemID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


INSERT INTO OrderDetails (OrderID, ItemID, Quantity)
VALUES 
(1001,101,1),
(1001,108,1),
(1002,103,1),
(1002,105,1),
(1003,102,1),
(1003,107,1),
(1004,104,2),
(1005,106,1);

select * from OrderDetails
SELECT ORDERID 
FROM ORDERDETAILS WHERE QUANTITY>1

CREATE TABLE Delivery (
    DeliveryID INT PRIMARY KEY IDENTITY(200,1),
    OrderID INT NOT NULL,
    DeliveryStatus VARCHAR(50) NOT NULL CHECK (DeliveryStatus IN ('Cancelled','Pending', 'Delivered')),
    DeliveryDate DATE DEFAULT GETDATE(),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
INSERT INTO Delivery(OrderID,DeliveryStatus)
Values
(1001,'Delivered'),
(1002,'Cancelled'),
(1003,'Pending'),
(1004,'Delivered'),
(1005,'Delivered');

-----------------------------------------------------------------------------------------------------------------------------
--=======================================================================================================================================


---query for adding a new column
ALTER TABLE Customers
ADD DateofBirth DATE;

---for dropping a column
ALTER TABLE Customers
DROP COLUMN DateofBirth;

---update existing data in a table
UPDATE Customers
SET Phone = '9876543210'
WHERE CustomerID = 1;

---Query for deleting a row
DELETE FROM Customers
WHERE CustomerID = 5;

---return detailed metadata about the table
EXEC sp_help 'Customers';

--- To include multiple conditions in a query
SELECT *
FROM Menu
WHERE Category = 'Fast Food' OR Category = 'Dessert';

---Instead of writing multiple  conditions, you can use 
SELECT *
FROM Customers
WHERE City IN ('Kochi', 'Hyderabad', 'Delhi');

---Query to exclude particular data
SELECT *
FROM Customers
WHERE City <> 'Hyderabad';
---Or---
SELECT *
FROM Menu
WHERE NOT (Category = 'Dessert');

---To covert to uppercase --doesnt affect the database
SELECT Name, UPPER(Name) AS UppercaseName
FROM Customers;

---To convert to lower
SELECT ItemName, 
LOWER(ItemName) AS LowercaseItemName
FROM Menu;

---To find Length
SELECT Name, LEN(Name) AS NameLength
FROM Customers;

---Substring:The  function in SQL is used to extract a portion of a string from a specified starting position for a given length
SELECT ItemName, 
SUBSTRING(ItemName, 1, 5) AS ExtractedName
FROM Menu;

SELECT ItemName, 
SUBSTRING(ItemName, LEN(ItemName) - 3, 4) AS LastFourCharacters
FROM Menu;

---Concatenation 
SELECT CONCAT(DeliveryStatus, ' on ', DeliveryDate) AS DeliveryReport
FROM Delivery;

---Rename Table
EXEC sp_rename 'Menu', 'FoodMenu';

--- Rename a Column
EXEC sp_rename 'Customers.Phone', 'Mobile', 'COLUMN'

exec sp_rename 'Customers.Mobile', 'phone', 'column'

select *
from Customers

----- Names starting with 'R'
SELECT * FROM Customers
WHERE Name LIKE 'R%';

-- Names ending with 'a'
SELECT * FROM Customers
WHERE Name LIKE '%a';

-- Names containing 'ya'
SELECT * FROM Customers
WHERE Name LIKE '%ya%';

-- Names with exactly 5 characters
SELECT * FROM Customers
WHERE Name LIKE '_____';

--- Selection (σ)
SELECT * 
FROM Customers 
WHERE Address = 'Kochi';

---Prices between ₹80 and ₹150 (Menu Table)
SELECT * 
FROM Menu 
WHERE Price BETWEEN 80 AND 150;


SELECT * 
FROM Customers 
ORDER BY Name ASC;


SELECT * 
FROM Menu 
ORDER BY Price DESC;


SELECT CustomerID, 
COUNT(OrderID) AS TotalOrders
FROM Orders
GROUP BY CustomerID;


SELECT ItemID, SUM(Quantity) AS TotalQuantitySold
FROM OrderDetails
GROUP BY ItemID;


SELECT Category, AVG(Price) AS AveragePrice
FROM Menu
GROUP BY Category;


SELECT COUNT(*) AS TotalCustomers
FROM Customers;


SELECT COUNT(OrderID) AS TotalOrders
FROM Orders;


SELECT AVG(Price) AS AverageMenuPrice
FROM Menu;


SELECT AVG(TotalAmount) AS AverageOrderAmount
FROM Orders;


SELECT MIN(Price) AS LowestPrice, MAX(Price) AS HighestPrice
FROM Menu;


SELECT MIN(OrderDate) AS FirstOrderDate, MAX(OrderDate) AS LatestOrderDate
FROM Orders;


SELECT 
  COUNT(*) AS TotalItems, 
  AVG(Price) AS AveragePrice,
  MIN(Price) AS LowestPrice,
  MAX(Price) AS HighestPrice
FROM Menu;



---Inner Join 
SELECT 
    Orders.OrderID, 
    Customers.Name AS CustomerName, 
    Orders.TotalAmount
FROM Orders
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID;

--- Left Join
SELECT 
    Customers.CustomerId, 
    Customers.Name, 
    Orders.OrderID, 
    Orders.TotalAmount
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID;










