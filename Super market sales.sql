use sql_assignment;
-- using this database supermarket_sales 
select * from supermarket_sales;

-- Q1 
-- Each invoice_id has a middle number (for e.g. 46 in 727-46-3608). Write a query to get each middle number and the count of invoices for that middle number
-- (you will first need to figure out how to create a column in the select clause to extract the invoice_middle_number (hint: nested substring_index() can help) and then group by this column)
-- order your result by invoice_middle_number in ascending order

SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(`Invoice ID`, '-', 2), '-', -1) AS invoice_middle_number,
COUNT(*) AS invoice_count
FROM supermarket_sales
GROUP BY invoice_middle_number
ORDER BY invoice_middle_number ASC;


-- Q2
-- Get product_line, unit_price, and a label for each unit_price called price_category
-- unit_price greater than 70 is expensive
-- unit_price ranging from 40 to 70 is moderately expensive
-- unit_price less than 40 is cheap
-- order your result by the unit_price in descending order

SELECT SUBSTRING_INDEX(`Customer type.Product line`, '.', -1) AS product_line,
`Unit price`,'Expensive' AS price_category
FROM supermarket_sales
WHERE `Unit price` > 70
UNION ALL
SELECT SUBSTRING_INDEX(`Customer type.Product line`, '.', -1) AS product_line,
`Unit price`,'Moderately Expensive' AS price_category
FROM supermarket_sales
WHERE `Unit price` BETWEEN 40 AND 70
UNION ALL
SELECT SUBSTRING_INDEX(`Customer type.Product line`, '.', -1) AS product_line,
    `Unit price`,'Cheap' AS price_category
FROM supermarket_sales
WHERE `Unit price` < 40
ORDER BY `Unit price` DESC;

-- Q3
-- Continuing from the query above, find out the count of invoices for each price_category
-- order your result by price_category in ascending order

SELECT 'Expensive' AS price_category,
COUNT(*) AS invoice_count
FROM supermarket_sales
WHERE `Unit price` > 70
UNION ALL
SELECT 'Moderately Expensive' AS price_category,
COUNT(*) AS invoice_count
FROM supermarket_sales
WHERE `Unit price` BETWEEN 40 AND 70
UNION ALL
SELECT 'Cheap' AS price_category,
COUNT(*) AS invoice_count
FROM supermarket_sales
WHERE `Unit price` < 40
ORDER BY price_category ASC;

-- Q4 
-- For all invoices EXCEPT for the 'Fashion accessories' and 'Health and beauty' invoices:
-- Return branch name and total tax for each branch that has a total tax greater than 8000
-- Round off total tax to 3 dp
-- Order result by branch in ascending order

select Branch, Round(sum(`Tax 5%`),2) as Total_Tax from `supermarket_sales`
where `Customer type.Product line` not in ('Fashion accessories','Health and beauty') group by 1
having sum(`Tax 5%`) > 8000 order by 1 asc;


-- Q5
-- Add a column called shipping_charges to the table. Give it an appropriate datatype. 

ALTER TABLE supermarket_sales
ADD COLUMN shipping_charges DECIMAL(10, 2);

-- Q6
-- Update this shipping column in the following way:
-- If the invoice's total price is greater than 1000, then the shipping is free
-- If the invoice's total price is less than 1000, then the shipping is 250
-- (total price is unit_price * quantity + tax_5pct)
set sql_safe_updates =0; 

UPDATE supermarket_sales
SET shipping_charges = CASE
WHEN (`Unit Price` * Quantity + `Tax 5%`) > 1000 THEN 0 
ELSE 250
END;

-- Q7
-- Return city, product_line and PER city PER product_line, show the following stats:
-- number of invoices as invoice_count
-- number of free shipping orders as free_shipping_orders_count
-- number of paid shipping orders as paid_shipping_orders_count
-- total of shipping_charges as total_shipping
-- finally, order result by city in ascending order and product_line in descending order


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


