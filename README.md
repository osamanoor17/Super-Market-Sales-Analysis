# Supermarket Sales SQL Queries

## Overview
This project contains SQL queries for analyzing the `supermarket_sales` database. The queries extract insights from sales data, categorize unit prices, calculate taxes, and manage shipping charges.

## Database Used
**Database Name:** `sql_assignment`
**Table Name:** `supermarket_sales`

## Queries and Explanations

### Q1: Extract Middle Number from Invoice ID
Extracts the middle number from each `Invoice ID` and counts the number of occurrences for each middle number.
```sql
SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(`Invoice ID`, '-', 2), '-', -1) AS invoice_middle_number,
COUNT(*) AS invoice_count
FROM supermarket_sales
GROUP BY invoice_middle_number
ORDER BY invoice_middle_number ASC;
```

### Q2: Categorize Unit Price
Assigns a price category (`Expensive`, `Moderately Expensive`, `Cheap`) to each product based on `Unit price` and orders results in descending order.
```sql
SELECT SUBSTRING_INDEX(`Customer type.Product line`, '.', -1) AS product_line,
`Unit price`, 'Expensive' AS price_category
FROM supermarket_sales
WHERE `Unit price` > 70
UNION ALL
SELECT SUBSTRING_INDEX(`Customer type.Product line`, '.', -1) AS product_line,
`Unit price`, 'Moderately Expensive' AS price_category
FROM supermarket_sales
WHERE `Unit price` BETWEEN 40 AND 70
UNION ALL
SELECT SUBSTRING_INDEX(`Customer type.Product line`, '.', -1) AS product_line,
`Unit price`, 'Cheap' AS price_category
FROM supermarket_sales
WHERE `Unit price` < 40
ORDER BY `Unit price` DESC;
```

### Q3: Count Invoices by Price Category
Counts the number of invoices for each price category and orders them in ascending order.
```sql
SELECT 'Expensive' AS price_category, COUNT(*) AS invoice_count FROM supermarket_sales WHERE `Unit price` > 70
UNION ALL
SELECT 'Moderately Expensive' AS price_category, COUNT(*) AS invoice_count FROM supermarket_sales WHERE `Unit price` BETWEEN 40 AND 70
UNION ALL
SELECT 'Cheap' AS price_category, COUNT(*) AS invoice_count FROM supermarket_sales WHERE `Unit price` < 40
ORDER BY price_category ASC;
```

### Q4: Calculate Total Tax for Each Branch (Excluding Specific Categories)
Calculates the total tax per branch, excluding invoices related to `Fashion accessories` and `Health and beauty`, and filters branches with total tax greater than 8000.
```sql
SELECT Branch, ROUND(SUM(`Tax 5%`), 3) AS Total_Tax
FROM supermarket_sales
WHERE `Customer type.Product line` NOT IN ('Fashion accessories', 'Health and beauty')
GROUP BY Branch
HAVING SUM(`Tax 5%`) > 8000
ORDER BY Branch ASC;
```

### Q5: Add a Shipping Charges Column
Adds a `shipping_charges` column to the table with a decimal data type.
```sql
ALTER TABLE supermarket_sales
ADD COLUMN shipping_charges DECIMAL(10, 2);
```

### Q6: Update Shipping Charges
Sets `shipping_charges` based on total price:
- Free if total price > 1000
- 250 otherwise
```sql
SET sql_safe_updates = 0;
UPDATE supermarket_sales
SET shipping_charges = CASE
WHEN (`Unit Price` * Quantity + `Tax 5%`) > 1000 THEN 0
ELSE 250
END;
```

### Q7: Shipping Stats per City and Product Line
Returns shipping statistics per city and product line, including invoice count, free and paid shipping order counts, and total shipping charges.
```sql
SELECT
    City,
    `Customer type.Product line` AS Product_Line,
    COUNT(`Invoice ID`) AS invoice_count,
    SUM(CASE WHEN shipping_charges = 0 THEN 1 ELSE 0 END) AS free_shipping_orders_count,
    SUM(CASE WHEN shipping_charges > 0 THEN 1 ELSE 0 END) AS paid_shipping_orders_count,
    SUM(shipping_charges) AS total_shipping
FROM supermarket_sales
GROUP BY City, `Customer type.Product line`
ORDER BY City ASC, Product_Line DESC;
```

## Usage
1. Ensure MySQL is installed and running.
2. Import the `supermarket_sales` dataset into your `sql_assignment` database.
3. Execute queries in order using a MySQL client.

## Author
- *Muhammad Osama Noor*

## License
This project is licensed under the MIT License.

