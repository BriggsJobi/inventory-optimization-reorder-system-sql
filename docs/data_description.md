# Data Description

## Source Tables

### sales_data
Contains transactional sales and inventory information.
Key fields:
- Product ID
- Inventory Quantity
- Product Cost
- Sales Date

### product_information
Contains product-level attributes.
Key fields:
- Product ID
- Product Category
- Promotions (Yes/No)

### external_factors
Contains macroeconomic and seasonal indicators.
Key fields:
- Sales Date
- GDP
- Inflation Rate
- Seasonal Factor

## Integrated Tables

### Sales_Productinfo_Table (View)
Created by joining:
- sales_data
- product_information
on Product ID

Used to combine product attributes with sales activity.

### Inventory_Table (View)
Created by joining:
- Sales_Productinfo_Table
- external_factors
on Sales Date

This unified view serves as the main analytical dataset used for:
- demand analysis
- inventory optimization
- reorder point calculation
