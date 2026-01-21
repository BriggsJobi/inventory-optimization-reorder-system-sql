-- DATA CLEANING
-- CLEANING THE EXTERNAL FACTORS TABLE
-- CLEANING DATE COULUMN

ALTER TABLE external_factors
ADD COLUMN New_Sales_Date DATE;

SELECT *
FROM external_factors;

SET SQL_SAFE_UPDATES = 0;

UPDATE external_factors 
SET New_Sales_Date = str_to_date(`Sales Date`, '%d/%m/%Y');

ALTER TABLE external_factors
DROP COLUMN `Sales Date`;

ALTER TABLE external_factors
CHANGE COLUMN New_Sales_Date Sales_Date DATE;

DESC external_factors;

ALTER TABLE external_factors
MODIFY COLUMN GDP DECIMAL(15,2);

ALTER TABLE external_factors
MODIFY COLUMN `Inflation Rate` DECIMAL(5,2);

ALTER TABLE external_factors
MODIFY COLUMN `Seasonal Factor` DECIMAL(5,2);

SHOW COLUMNS FROM external_factors;

-- Product Information Table

SHOW COLUMNS FROM product_information;

SELECT *
FROM product_information;

ALTER TABLE product_information -- DML 
ADD COLUMN `New Promotion` ENUM('Yes','No'); 

SELECT DISTINCT Promotions
FROM product_information;

SET SQL_SAFE_UPDATES = 0;

UPDATE product_information

SET `New Promotion` = CASE 

WHEN LOWER(TRIM(Promotions))= 'yes' THEN 'Yes'

WHEN LOWER(TRIM(Promotions)) = 'no' THEN 'No'

ELSE null

END;

ALTER TABLE product_information
DROP COLUMN Promotions; 

ALTER TABLE product_information
CHANGE COLUMN `New Promotion` Promotions ENUM('Yes','No');

SHOW COLUMNS FROM product_information; -- TO CHECK DATA TYPE AND TABLE STRUCTURE 
DESCRIBE product_information; -- ANOTHER WAY TO CHECK DATA TYPE AND TABLE STRUCTURE
DESC product_information; -- ANOTHER WAY TO CHECK DATA TYPE AND TABLE STRUCTURE

-- CLEANING SALES DATA TABLE

SHOW COLUMNS FROM sales_data;

ALTER TABLE sales_data
ADD COLUMN `New Sales Date` DATE;

SELECT *
FROM sales_data;

SET SQL_SAFE_UPDATES = 0;

UPDATE sales_data 
SET `New Sales Date` = str_to_date(`Sales Date`, '%d/%m/%Y');

ALTER TABLE sales_data
DROP COLUMN `Sales Date`; 

ALTER TABLE sales_data
CHANGE COLUMN `New Sales Date` `Sales Date` DATE;

SHOW COLUMNS FROM sales_data;

ALTER TABLE sales_data
MODIFY COLUMN `Product Cost` DECIMAL(15,2);

-- CHECK/SEARCH FOR MISSING DATA IN DATASET (NULL VALUES)

SELECT * FROM external_factors;

SELECT SUM(CASE WHEN GDP IS NULL THEN 1 ELSE 0 END) AS Missing_Values_in_GDP,
        SUM(CASE WHEN `Inflation Rate` IS NULL THEN 1 ELSE 0 END) AS Missing_Values_in_Inflation_Rate,
        SUM(CASE WHEN `Seasonal Factor` IS NULL THEN 1 ELSE 0 END) AS Missing_Values_in_Seasonal_Factors,
        SUM(CASE WHEN Sales_Date IS NULL THEN 1 ELSE 0 END) AS Missing_Values_in_Sales_Date
        
FROM external_factors;


-- CHECK/SEARCH FOR MISSING DATA IN DATASET (NULL VALUES)

SELECT * FROM product_information;

SELECT SUM(CASE WHEN `Product ID` IS NULL THEN 1 ELSE 0 END) AS Missing_Values_in_Product_ID,
        SUM(CASE WHEN `Product Category` IS NULL THEN 1 ELSE 0 END) AS Missing_Values_in_Product_Category,
        SUM(CASE WHEN Promotions IS NULL THEN 1 ELSE 0 END) AS Missing_Values_in_Promotions
       
FROM product_information;


-- CHECK/SEARCH FOR MISSING DATA IN DATASET (NULL VALUES)

SELECT * FROM sales_data;

SELECT SUM(CASE WHEN `Product ID` IS NULL THEN 1 ELSE 0 END) AS Missing_Values_in_Product_ID,
        SUM(CASE WHEN `Inventory Quantity` IS NULL THEN 1 ELSE 0 END) AS Missing_Values_in_Inventory_Quantity,
        SUM(CASE WHEN `Product Cost` IS NULL THEN 1 ELSE 0 END) AS Missing_Values_in_Product_Cost,
        SUM(CASE WHEN `Sales Date` IS NULL THEN 1 ELSE 0 END) AS Missing_Values_in_Sales_Date
       
FROM sales_data;

-- IDENTIFTING DUPLICATE VALUES IN DATASET (PRODUCT INFORMATION TABLE)

SELECT `Product ID`, COUNT(*) AS COUNT 
FROM product_information
GROUP BY `product ID`
ORDER BY COUNT DESC;

SELECT *
FROM(SELECT `Product ID`, COUNT(*) AS COUNT 
FROM product_information
GROUP BY `product ID`
HAVING COUNT(*)>1) AS Total_Duplicate
;

SELECT COUNT(*)
FROM(SELECT `Product ID`, COUNT(*) AS COUNT 
FROM product_information
GROUP BY `product ID`
HAVING COUNT(*)>1) AS Total_Duplicate
;

-- REMOVING DUPLICATES FROM PRODUCT INFORMATION TABLE

SELECT `Product ID`,
 row_number() over(partition by `Product ID` order by `Product ID`) AS a
FROM product_information;

SET SQL_SAFE_UPDATES = 0;


delete a1 FROM product_information a1
INNER JOIN
(SELECT `Product ID`,
 row_number() over(partition by `Product ID` order by `Product ID`) AS a
FROM product_information) AS b
ON a1.`Product ID`=b.`Product ID`
WHERE b.a=2;



-- IDENTIFYING DUPLICATE VALUES IN DATASET (EXTERNAL FACTORS TABLE)

SELECT * FROM external_factors;

SELECT *
FROM(SELECT Sales_Date, COUNT(*) AS COUNT 
FROM external_factors
GROUP BY Sales_Date
HAVING COUNT(*)>1) AS Total_Duplicate
;

SELECT Sales_Date, COUNT(*) AS COUNT 
FROM external_factors
GROUP BY Sales_Date
ORDER BY COUNT DESC;

SELECT COUNT(*)
FROM(SELECT Sales_Date, COUNT(*) AS COUNT 
FROM external_factors
GROUP BY Sales_Date
HAVING COUNT(*)>1) AS Total_Duplicate
;

-- REMOVING DUPLICATES FROM EXTERNAL FACTORS TABLE

SELECT * FROM external_factors;

SELECT Sales_Date,
 row_number() over(partition by Sales_Date order by Sales_Date) AS a
FROM external_factors;

SET SQL_SAFE_UPDATES = 0;


delete a1 FROM external_factors a1
INNER JOIN
(SELECT Sales_Date,
 row_number() over(partition by Sales_Date order by Sales_Date) AS a
FROM external_factors) AS b
ON a1.Sales_Date=b.Sales_Date
WHERE b.a=2;



