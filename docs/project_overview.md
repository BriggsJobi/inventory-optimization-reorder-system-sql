# Inventory Optimization & Reorder Point System (SQL)

## Business Problem
Retail businesses often struggle with balancing product availability and inventory costs. Overstocking leads to high holding costs, while understocking increases the risk of missed sales and poor customer experience.

## Project Objective
To analyze historical sales and inventory data and develop a data-driven reorder point model that supports timely restocking while minimizing excess inventory.

## Approach
The project followed these key steps:
- Data cleaning and standardization across multiple tables
- Removal of duplicates and correction of data types
- Integration of sales, product, and external economic factors
- Exploratory analysis to identify demand patterns and inventory risks
- Implementation of reorder point logic using rolling averages, lead time demand, and safety stock
- Design of stored procedures and triggers to support automated recalculation

## Outcome
The final solution provides:
- Product-level reorder points based on recent sales trends
- Identification of products with frequent low-stock risk
- Comparison of inventory value against sales velocity to highlight overstock or understock tendencies

These outputs can support more informed purchasing and replenishment decisions in a real-world retail environment.

## Business Impact (Potential)
- Reduced stockout risk through data-driven reorder point calculations  
- Improved cash flow by minimizing excess inventory and holding costs  
- More predictable and efficient replenishment planning based on demand trends  

