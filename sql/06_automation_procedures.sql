-- AUTOMATION AND TRIGGERING 

Use Inventory_Solution;

CREATE TABLE Inventory_Automation_Table (Product_ID int, Reorder_Point double);

Delimiter //
CREATE PROCEDURE Recalculate_Order_Point(IN Product_ID int)
BEGIN
	Declare Avg_Rolling_Sales double;
	Declare Avg_Rolling_Variance double;
    Declare Lead_Time_Demand double;
    Declare Safety_Stock double;
    Declare Reorder_Point double;
    
    -- ROLLING AVERAGE CALCULATIONS
    SELECT  Avg_Rolling_Sales,
			Avg_Rolling_Variance
	INTO Avg_Rolling_Sales,
		Avg_Rolling_Variance
	FROM (
    SELECT `Product ID`,
		   `Sales Date`, AVG(Daily_Sales) OVER (PARTITION BY `Product ID` ORDER BY `Sales Date` ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) Rolling_Avg_Sales,
            AVG(Squared_Diff) OVER (PARTITION BY `Product ID` ORDER BY `Sales Date` ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) Rolling_Variance
            FROM (
    SELECT  `Product ID`,
			`Sales Date`,
            (`Inventory Quantity` * `Product Cost`) AS Daily_Sales,
            POWER((`Inventory Quantity` * `Product Cost`) - AVG(`Inventory Quantity` * `Product Cost`) OVER(PARTITION BY `Product ID` 
            ORDER BY `Sales Date` ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2) AS Squared_Diff
	FROM Inventory_Table
    WHERE `Product ID` = Product_ID) AS Inner_Derived) AS Outer_Derived;
    
    -- CALCULATIONS
    SET Lead_Time_Demand = Avg_Rolling_Sales * 7;
    SET Safety_Stock =1.645 * (Avg_Rolling_Variance * 7)^0.5;
    SET Reorder_Point = Lead_Time_Demand + Safety_Stock;
    
    -- INSERT OR UPDATE THE OPTIMIZATION TABLE 
    INSERT INTO Inventory_Automation_Table (Product_ID, Reorder_Point) VALUES(Product_ID, Reorder_Point) 
    ON DUPLICATE KEY UPDATE Reorder_Point = VALUES (Reorder_Point);
    END //
    DELIMITER ;
    
    
    
    DELIMITER //
    CREATE TRIGGER After_Insert_Unified_Table
    AFTER INSERT ON Inventory_Automation_Table
    FOR EACH ROW 
    BEGIN 
		CALL Recalculatereorderpoint(NEW.Product_ID);
	END //
    DELIMITER ;
    
-- ___________________________________________________________________________________________________________________________________________________________________________    
    

    -- OVERSTOCK VERSUS UNDERSTOCK ANALYSIS
    -- CTE (COMMON TABLE EXPRESSION)
    
    WITH Rolling_Sales AS(
       SELECT `Product ID`,
               `Sales Date`,
               AVG(`Inventory Quantity` * `Product Cost`) OVER(PARTITION BY `Product ID` ORDER BY `Sales Date` ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) Rolling_Avg_Sales
		FROM Inventory_Table
    ),
    -- CALCULATE THE NUMBER OF DAYS A PRODUCT WAS OUT OF STOCK
    Stock_Days_Out AS (
			  SELECT `Product ID`,
                 COUNT(*) AS Stock_Out_Days
              FROM Inventory_Table
              WHERE `Inventory Quantity` = 0
              GROUP BY `Product ID`

)

-- JOINING THE ABOVE TEMPORARY TABLE CREATED TO THE MAIN TABLE TO GET THE FINAL RESULT
SELECT f.`Product ID`,
		AVG(f.`Inventory Quantity` * `Product Cost`) AS Avg_Inventory_Value,
        AVG(rs.Rolling_Avg_Sales) AS Avg_Rolling_Sales,
        COALESCE(dx.Stock_Out_Days, 0) AS Stock_Out_Days
FROM Inventory_Table f
JOIN Rolling_Sales rs ON f.`Product ID` = rs. `Product ID` AND f.`Sales Date` = rs.`Sales Date`
LEFT JOIN Stock_Days_Out dx ON f.`Product ID` = dx.`Product ID` 
GROUP BY f.`Product ID`, DX.Stock_Out_Days;
    
-- ___________________________________________________________________________________________________________________________________________________________________________


-- MONITORING AND ADJUSTING
-- CREATING PROCEDURES

use Inventory_Solution;

DELIMITER //
CREATE PROCEDURE Monitor_Inventory_Level ()
BEGIN
SELECT `Product ID`,
		AVG(`Inventory Quantity`) AS Avg_Inventory_Qty
FROM Inventory_Table
GROUP BY `Product ID`
ORDER BY Avg_Inventory_Qty;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Monitor_Sales_Trend ()
BEGIN
SELECT `Product ID`,
		`Sales Date`,
        AVG(`Inventory Quantity` * `Product Cost`) OVER (PARTITION BY `Product ID` ORDER BY `Sales Date` ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS Rolling_Sales
FROM Inventory_Table;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE Stock_Out_Frequency ()
BEGIN
SELECT `Product ID`,
		COUNT(*) AS Stock_Out_Days
FROM Inventory_Table
GROUP BY `Product ID`
ORDER BY Stock_Out_Days DESC;
END //
DELIMITER ;









