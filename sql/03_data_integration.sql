-- DATA INTEGRATION 

-- DATA INTEGRATION OF ALL TABLES 

SELECT a.`Product ID`,
	   a.`Inventory Quantity`,
	   a.`Product Cost`,
	   a.`Sales Date`,
       b.`Product Category`,
       b.Promotions
       
FROM sales_data a INNER JOIN product_information b
ON a.`Product ID` = b.`Product ID`;


-- THERE ARE 2 WAYS TO CREATE TEMPORARY TABLES IN SQL

-- 1. CREATE VIEW; TABLES MADE WITH THIS PROCESS CAN BE USED THROUGHOUT THE PROJECT

CREATE VIEW Sales_Productinfo_Table AS 
SELECT a.`Product ID`,
	   a.`Inventory Quantity`,
	   a.`Product Cost`,
	   a.`Sales Date`,
       b.`Product Category`,
       b.Promotions
       
FROM sales_data a INNER JOIN product_information b
ON a.`Product ID` = b.`Product ID`;

SELECT *
FROM Sales_Productinfo_Table;


SELECT c.`Product ID`,
       c.`Inventory Quantity`,
       c.`Product Cost`,
       c.`Sales Date`,
       c.`Product Category`,
       c.Promotions,
       d.GDP,
       d.`Inflation Rate`,
       d.`Seasonal Factor`
       
FROM Sales_Productinfo_Table c LEFT JOIN external_factors d
ON c.`Sales Date` = d.Sales_Date;


CREATE VIEW Inventory_Table AS
SELECT c.`Product ID`,
       c.`Inventory Quantity`,
       c.`Product Cost`,
       c.`Sales Date`,
       c.`Product Category`,
       c.Promotions,
       d.GDP,
       d.`Inflation Rate`,
       d.`Seasonal Factor`
       
FROM Sales_Productinfo_Table c LEFT JOIN external_factors d
ON c.`Sales Date` = d.Sales_Date;

SELECT *
FROM Inventory_Table;


