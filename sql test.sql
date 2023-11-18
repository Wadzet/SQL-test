-- Task 1: Subqueries 
-- Objective: Retrieve the customer names and their orders' total price where the total price is higher than the average total price of all orders.
USE tysql;

SELECT Customers.cust_name, Orders.order_num,
	SUM(OrderItems.quantity * OrderItems.item_price) AS total_price
FROM Customers
INNER JOIN Orders ON Customers.cust_id = Orders.cust_id
INNER JOIN OrderItems ON Orders.order_num = OrderItems.order_num
GROUP BY Customers.cust_name, Orders.order_num
HAVING total_price > (
		SELECT AVG(total_order_price)
        FROM (SELECT SUM(OrderItems.quantity * OrderItems.item_price) AS total_order_price
            FROM Orders
            INNER JOIN OrderItems ON Orders.order_num = OrderItems.order_num
            GROUP BY Orders.order_num) AS avg_orders
);


-- Task 2: Using Joins and Aggregate Functions 
-- Objective: Retrieve the employee names and the number of orders they've taken.
USE Northwind;

SELECT Employee.firstname, Employee.lastname, COUNT(SalesOrder.orderId) AS numberOfOrders
FROM Employee
LEFT JOIN SalesOrder ON Employee.employeeId = SalesOrder.employeeId
GROUP BY Employee.employeeId
ORDER BY numberOfOrders DESC;



-- Task 3: Handling NULL Values and CASE Statements 
-- Objective: Show the product name and quantity; if the quantity is NULL, display "Out of Stock".
USE tysql;

SELECT prod_name, 
       CASE
           WHEN quantity IS NULL THEN 'Out of Stock'
           ELSE CAST(quantity AS CHAR)
       END AS 'Guantity'
FROM Products
LEFT JOIN (SELECT prod_id, SUM(quantity) AS quantity FROM OrderItems GROUP BY prod_id) AS product_quantity
ON Products.prod_id = product_quantity.prod_id;



-- Task 4: Using Common Table Expressions (CTE) 
-- Objective: List the orders made by French customers and display their total price.
USE Northwind;

WITH FrenchOrders AS (
  SELECT SalesOrder.orderId, SalesOrder.custId, SUM(OrderDetail.unitPrice * OrderDetail.quantity) AS totalOrderPrice
  FROM SalesOrder
  JOIN OrderDetail ON SalesOrder.orderId = OrderDetail.orderId
  JOIN Customer ON SalesOrder.custId = Customer.custId
  WHERE Customer.country = 'France'
  GROUP BY SalesOrder.orderId, SalesOrder.custId
)

SELECT FrenchOrders.orderId, FrenchOrders.custId, FrenchOrders.totalOrderPrice
FROM FrenchOrders;


-- Task 5: Working with Date Functions 
-- Objective: Retrieve orders made in the last 90 days along with their shipping dates.
USE tysql;

SELECT 
    order_num AS 'Order', order_date AS 'Shipping Date'
FROM Orders
WHERE order_date >= (SElECT MAX(order_date) - INTERVAL 90 DAY FROM Orders);

-- Task 6: Nested Queries and Aggregation 
-- Objective: Find the customers who have made the most expensive single order.
use tysql;

SELECT Customers.cust_id, Customers.cust_name,
    MAX(OrderItems.item_price * OrderItems.quantity) AS max_order
FROM Customers
INNER JOIN Orders ON Customers.cust_id = Orders.cust_id
INNER JOIN OrderItems ON Orders.order_num = OrderItems.order_num
GROUP BY Customers.cust_id, Customers.cust_name
ORDER BY max_order DESC
LIMIT 1;

-- Task 7: Advanced Joins 
-- Objective: List products with their suppliers and categories.
USE Northwind;

SELECT Product.productName, Supplier.companyName AS supplier, Category.categoryName AS category
FROM Product
INNER JOIN Supplier ON Product.supplierId = Supplier.supplierId
INNER JOIN Category ON Product.categoryId = Category.categoryId;


-- Task 8: Handling Duplicates and Unions 
-- Objective: Combine and display a list of all products and all categories.
USE tysql;

SELECT prod_name AS name
FROM Products
UNION
SELECT vend_name AS name
FROM Vendors;

-- Task 9: Using EXISTS 
-- Objective: Display orders that have associated order details.
USE tysql;

SELECT *
FROM Orders
WHERE EXISTS (
    SELECT 1
    FROM OrderItems
    WHERE OrderItems.order_num = Orders.order_num
);


-- Task 10: Data Modification with Transactions Objective: 
-- Insert a new customer and an order for that customer in a single transaction.
USE tysql;

START TRANSACTION;
INSERT INTO Customers
VALUES('1000000006', 'Molokija', 'Lozovetska 28', 'Ternopil', 'UA', '46000', 'UA', 'Taras Test', 'test@molokija.com');
INSERT INTO Orders
VALUES(20010, '2023-11-10', '1000000006');
COMMIT;



