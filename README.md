# Inventory Optimization & Reorder Point System (SQL)

A data-driven inventory optimization project focused on determining optimal reorder points using historical sales trends, rolling averages, and safety stock calculations.

## Project Objectives
- Clean and standardize multi-table retail datasets
- Integrate sales, product, and external economic factors
- Analyze demand patterns and inventory risks
- Calculate product-level reorder points using lead time demand and safety stock logic
- Demonstrate automation using stored procedures and triggers

## Tools Used
- MySQL
- MySQL Workbench
- SQL (CTEs, Window Functions, Views, Stored Procedures, Triggers)

## Repository Structure
inventory-optimization-reorder-system-sql/
│
├── data/
│   ├── raw/                           # Original dataset before cleaning (if included)
│   └── processed/                     # Final cleaned dataset exported from SQL
│
├── sql/
│   ├── 01_schema_and_tables.sql       # Schema creation, table setup, and renaming
│   ├── 02_data_cleaning.sql           # Data type fixes, date standardization, duplicates removal
│   ├── 03_data_integration.sql        # Views combining sales, product, and inventory data
│   ├── 04_inventory_analysis.sql      # Exploratory analysis of demand and stock behavior
│   ├── 05_reorder_point_logic.sql     # Reorder point, lead time demand, and safety stock logic
│   └── 06_automation_procedures.sql   # Stored procedures and triggers for automation
│
├── results/
│   ├── inventory_vs_sales_pressure.csv   # Compares inventory levels against sales velocity
│   ├── low_stock_frequency.csv            # Products frequently operating at low or zero stock
│   └── reorder_points.csv                 # Final recommended reorder points per product
│
├── docs/
│   ├── data_description.md              # Explanation of datasets, fields, and assumptions
│   └── project_overview.md              # Business context, methodology, and summary insights
│
└── README.md                             # Main project documentation


## Key Analytical Outputs
- Reorder points per product based on recent demand trends
- Identification of products frequently operating at low stock levels
- Inventory value versus sales velocity comparison to detect overstock and understock risks

## How to Run the Project
1. Execute SQL files in order from `01_schema_and_tables.sql` to `06_automation_procedures.sql`
2. Ensure views are successfully created
3. Run analytical queries in `04` and `05` to reproduce results

## Portfolio Use
This project demonstrates practical SQL skills for:
- Data cleaning
- Data modeling
- Business-focused analytics
- Inventory optimization logic

Suitable for data analyst, business intelligence, and analytics engineering roles.

