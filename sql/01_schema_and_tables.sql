CREATE SCHEMA Inventory_Solution;
USE Inventory_Solution;

SELECT *
FROM external_factors;

SELECT *
FROM `sales data`;

SELECT *
FROM product_information;

ALTER TABLE `sales data` RENAME TO sales_data;

-- DATA EXPLORATION

SELECT *
FROM sales_data
LIMIT 10;

SELECT *
FROM external_factors
LIMIT 10;

SELECT *
FROM product_information
LIMIT 10;

-- UNDERSTANDING THE STRUCTURE OF OUR DATA

SHOW COLUMNS FROM external_factors;

DESCRIBE product_information;

DESC sales_data;



