-- 2. USING CTE (COMMON TABLE EXPRESSION); CAN ONLY BE USED IN THE QUERY CREATED

-- SOME BASIC STATISTICS/EDA (EXPLORATORY DATA ANALYSIS)

-- CALCULATION OF PRODUCT WITH HE AVERAGE SALES 

SELECT `Product ID`,
        ROUND(AVG(`Inventory Quantity` * `Product Cost`),2) AS Total_Sales
FROM Inventory_Table
GROUP BY `Product ID`
ORDER BY Total_Sales DESC;

-- CALCULATION OF MEDIAN STOCK LEVEL AT INVENTORY QUANTITY
SELECT `Product ID`, AVG(`Inventory Quantity`) AS Median_Stock
FROM (SELECT `Product ID`,
        `Inventory Quantity`,
        ROW_NUMBER() OVER(PARTITION BY `Product ID` ORDER BY `Inventory Quantity`) AS Row_Num_ASC,
        ROW_NUMBER() OVER(PARTITION BY `Product ID` ORDER BY `Inventory Quantity` DESC) AS Row_Num_DESC
FROM Inventory_Table) AS Inner_Query
WHERE Row_Num_ASC IN (Row_Num_DESC, Row_Num_DESC - 1, Row_Num_DESC + 1)
GROUP BY `Product ID`;

-- CALCULATION OF TOTAL SALES PER PRODUCT
SELECT `Product ID`,
        SUM(`Inventory Quantity` * `Product Cost`) AS Total_Sales
FROM Inventory_Table
GROUP BY `Product ID`
ORDER BY Total_Sales DESC;

-- CALCULATION OF HIGH DEMAND PRODUCTS BASED ON AVERAGE SALES
-- IF AVERAGE SALES IS GREATER THAN AVERAGE INVENTORY QUANTITY * 0.95 THEN THE PRODUCT IS ON HIGH DEMAND AND CTA (COMMON TABLE EXPRESSION IS USED)

WITH High_Demand_Products AS (SELECT `Product ID`,
									  AVG(`Inventory Quantity`) AS Average_Sales
							   FROM Inventory_Table
                               GROUP BY `Product ID`
							   HAVING Average_Sales > (SELECT AVG(`Inventory Quantity`) * 0.95
                                                       FROM sales_data)
)
-- CALCULATE THE STOCK FREQUENCY FOR HIGH DEMAND PRODUCT 
SELECT a.`Product ID`,
        COUNT(*) AS Stockout_Frequency
FROM Inventory_Table a
WHERE a.`Product ID` IN (SELECT `Product ID`
                         FROM High_Demand_Products) AND a.`Inventory Quantity` = 0
GROUP BY a.`Product ID`;

-- EFFECT OF EXTERNAL FACTORS (GDP, INFLATION RATE, SEASONAL FACTOR. SALES DATE)

-- EFFECT OF GDP (GROSS DOMESTIC PRODUCT)

SELECT `Product ID`,
        GDP,
        ROUND(AVG(CASE WHEN GDP > 0 THEN `Inventory Quantity` ELSE NULL END),2) AS Inventory_at_Positive_GDP,
        AVG(CASE WHEN GDP <= 0 THEN `Inventory Quantity` ELSE NULL END) AS Inventory_at_Negative_GDP
FROM Inventory_Table
GROUP BY `Product ID`, GDP
HAVING Inventory_at_Positive_GDP IS NOT NULL -- HAVING IS USED TO FILTER AGGREGATED COLUMNS WHILE WHERE IS USED TO FILTER NON AGGREGATED COLUMNS 
ORDER BY 3;

SELECT `Product ID`,
        GDP,
        ROUND(AVG(CASE WHEN GDP > 0 THEN `Inventory Quantity` ELSE NULL END),2) AS Inventory_at_Positive_GDP,
        AVG(CASE WHEN GDP <= 0 THEN `Inventory Quantity` ELSE NULL END) AS Inventory_at_Negative_GDP
FROM Inventory_Table
GROUP BY `Product ID`, GDP
HAVING Inventory_at_Positive_GDP IS NOT NULL
ORDER BY 2 DESC;

-- EFFECT OF INFLATION RATE

SELECT `Product ID`,
        `Inflation Rate`,
        ROUND(AVG(CASE WHEN `Inflation Rate` > 0 THEN `Inventory Quantity` ELSE NULL END), 2) AS Inflation_at_Positive_Rate,
        AVG(CASE WHEN `Inflation Rate` <= 0 THEN `Inventory Quantity` ELSE NULL END) AS Inflation_at_Negative_Rate
FROM Inventory_Table
GROUP BY `Product ID`, `Inflation Rate`
HAVING Inflation_at_Positive_Rate IS NOT NULL
ORDER BY 3 DESC; -- 3 STANDS FOR THE COLUMN INFLATION_AT_POSITIVE_RATE




