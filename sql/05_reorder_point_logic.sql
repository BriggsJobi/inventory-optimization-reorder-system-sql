/* INVENTORY OPTIMIZATION 

WHAT IS INVENTORY OPTIMIZATION; THIS IS THE PROCESS OF ENSURING THAT THE RIGHT AMOUNT OF STOCK IS MAINTAINED
TO MEET THE CUSTOMER'S DEMAND WHILE MINIMIZING UNPRODUCTIVE HOARDING.
 WE NEED TO DETERMINE THE OPTIMAL REORDER FOR EACH PRODUCT BASED ON THE HISTORICAL SALES DATA AND EXTERNAL FACTOR
 
 WHAT IS OPTIMAL REODER POINT; IT IS THE MINIMUM LEVEL AN ORDER SHOULD REACH BEFORE RESTOCKING IS DONE
 REORDER POINT HAS A FORMULA WHICH IS
 
 REORDER POINT = LEAD TIME DEMAND + SAFETY STOCK

(SAFETY STOCK IS ALSO KNOWN AS BACKUP STOCK)

LEAD TIME DEMAND IS THE STOCK DEMAND/EXPECTED SALES DURING THE LEAD TIME. LEAD TIME IS THE PERIOD YOU ARE WAITING
TO GET THE STOCK AND THE LEAD TIME DEMAND FORMULA IS

LEAD TIME DEMAND = LEAD TIME * ROAMING AVERAGE SALES

saftey stock = Z * Lead time^0.5 * standard deviation of demand
Z = 1.645 (z score)
Lead Time = 7Days

 */
 
 
 
 
 
 -- INVENTORY OPTIMIZATION
-- AMOUNT OF GOODS SOLD PER DAY
-- CALCULATION OF TODAY'S SALES AND HOW DOES IT DIFFER FROM THE ROLLING AVERAGE
 use Inventory_Solution;
 
 WITH Inventory_Calculations AS (
 SELECT `Product ID`,
		`Sales Date`,
		ROUND(AVG(Rolling_Avg_Sales),2) AS Avg_Rolling_Sales,
        AVG(Rolling_Variance) AS Avg_Rolling_Variance
FROM (
 
 SELECT `Product ID`,
		`Sales Date`,
        AVG(Daily_Sales) OVER (PARTITION BY `Product ID` ORDER BY `Sales Date` ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS Rolling_Avg_Sales,
        AVG(Squared_Diff) OVER (PARTITION BY `Product ID` ORDER BY `Sales Date` ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS Rolling_Variance
FROM (
 
 SELECT `Product ID`,
		`Sales Date`,
        (`Inventory Quantity` * `Product Cost`) AS Daily_Sales,
        POWER((`Inventory Quantity` * `Product Cost`) - AVG (`Inventory Quantity` * `Product Cost`) OVER (PARTITION BY `Product ID` ORDER BY `Sales Date` 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS Squared_Diff
FROM Inventory_Table) AS Inner_Query) AS Sub_Inner_Query
GROUP BY `Product ID`, `Sales Date`)

SELECT `Product ID`,
		Avg_Rolling_Sales * 7 AS Lead_Time_Demand, 
        1.645 * (Avg_Rolling_Variance * 7) AS Safety_Stock, 
        (Avg_Rolling_Sales * 7) + (1.645 * (Avg_Rolling_Variance * 7)) AS Reorder_Point
FROM Inventory_Calculations;



-- IS 2 IN (1, 1-1, 1+1)? ROW 1 TRUE
-- IS 1 IN (2, 2-1, 2+1)? ROW 2 TRUE
-- IS 1 IN (1, 1-1, 1+1)? ROW 3 TRUE
-- IS 4 IN (1, 1-1, 1+1)? ROW 4 FALSE
-- IS 3 IN (2, 2-1, 2+1)? ROW 5 TRUE
-- IS 2 IN (3, 3-1, 3+1)? ROW 6 TRUE
-- IS 1 IN (4, 4-1, 4+1)? ROW 7 FALSE





