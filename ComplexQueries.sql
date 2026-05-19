/* 
PROJECT:     Complex Queries
VERSION:     1.0
AUTHOR:      Anwar, Abdullah, Wajid
DATE:        18-MAY-2026
*/

USE HungerStationDB;

-- Complex Query with Aggregation Functions
-- Calculate the total number of orders, total revenue, and average order value.
SELECT 
    COUNT(O.Order_ID) AS Total_Orders, 
    SUM(P.Amount) AS Total_Revenue, 
    AVG(P.Amount) AS Avg_Payment
FROM `Order` AS O
JOIN Payment AS P ON O.Order_ID = P.Order_ID;

-- Complex Query with JOIN Statements
-- Retrieve a comprehensive log of all customers, their addresses, and details of their orders.
SELECT 
    C.User_ID, 
    C.Name AS Customer_Name, 
    CA.Address, 
    O.Order_ID, 
    O.Total AS Order_Total, 
    D.Name AS Driver_Name
FROM Customer C
LEFT JOIN Customer_Address CA ON C.User_ID = CA.User_ID
LEFT JOIN `Order` O ON C.User_ID = O.User_ID
LEFT JOIN Driver D ON O.Driver_ID = D.Driver_ID
ORDER BY O.Date DESC;

-- Complex Query with GROUP BY and HAVING Clauses
-- For each restaurant, find the total revenue generated and the number of unique menu items ordered, but filter out restaurants that have generated 15.00 or less in total sales.
SELECT 
    R.Restaurant_ID, 
    R.Name AS Restaurant_Name, 
    COUNT(DISTINCT OM.Item_ID) AS Unique_Items_Ordered, 
    SUM(M.Price) AS Total_Sales
FROM Restaurant R
JOIN Menu M ON R.Restaurant_ID = M.Restaurant_ID
JOIN Order_Menu OM ON M.Item_ID = OM.Item_ID
GROUP BY R.Restaurant_ID, R.Name
HAVING SUM(M.Price) > 15.00;

-- Complex Query with the UNION Operator
-- Combine two customer groups into a target marketing list: Customers who have placed high-value orders (> 15.00) AND customers who gave excellent reviews (Rating = 5).
SELECT 
    C.User_ID, 
    C.Name, 
    'High Spender' AS Criteria
FROM Customer C
JOIN `Order` O ON C.User_ID = O.User_ID
WHERE O.Total > 15.00

UNION

SELECT 
    C.User_ID, 
    C.Name, 
    'Top Reviewer' AS Criteria
FROM Customer C
JOIN Review R ON C.User_ID = R.User_ID
WHERE R.Rating = 5;
