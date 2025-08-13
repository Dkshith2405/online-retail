CREATE DATABASE online_sales;
USE online_sales;

CREATE TABLE online_sales (
    invoice VARCHAR(20),
    stockcode VARCHAR(20),
    description TEXT,
    quantity INT,
    invoicedate DATETIME,
    price DECIMAL(10,2),
    customer_id INT,
    country VARCHAR(50)
);
select * from online_sales;
select count(*) from online_sales;

-- 1. Monthly revenue
SELECT 
    EXTRACT(YEAR FROM invoicedate) AS year,
    EXTRACT(MONTH FROM invoicedate) AS month,
    ROUND(SUM(quantity * price), 2) AS monthly_revenue
FROM online_sales
GROUP BY year, month
ORDER BY year, month;

-- 2. Monthly order volume
SELECT 
    EXTRACT(YEAR FROM invoicedate) AS year,
    EXTRACT(MONTH FROM invoicedate) AS month,
    COUNT(DISTINCT invoice) AS order_volume
FROM online_sales
GROUP BY year, month
ORDER BY year, month;

-- 3. Monthly revenue & volume together
SELECT 
    EXTRACT(YEAR FROM invoicedate) AS year,
    EXTRACT(MONTH FROM invoicedate) AS month,
    ROUND(SUM(quantity * price), 2) AS monthly_revenue,
    COUNT(DISTINCT invoice) AS order_volume
FROM online_sales
GROUP BY year, month
ORDER BY year, month;

-- 4. Limit to a specific time period (e.g., only 2010)
SELECT 
    EXTRACT(YEAR FROM invoicedate) AS year,
    EXTRACT(MONTH FROM invoicedate) AS month,
    ROUND(SUM(quantity * price), 2) AS monthly_revenue,
    COUNT(DISTINCT invoice) AS order_volume
FROM online_sales
WHERE EXTRACT(YEAR FROM invoicedate) = 2010
GROUP BY year, month
ORDER BY year, month;

-- 5. Limit to a specific month/year (e.g., Dec 2009)
SELECT 
    EXTRACT(YEAR FROM invoicedate) AS year,
    EXTRACT(MONTH FROM invoicedate) AS month,
    ROUND(SUM(quantity * price), 2) AS monthly_revenue,
    COUNT(DISTINCT invoice) AS order_volume
FROM online_sales
WHERE EXTRACT(YEAR FROM invoicedate) = 2009
  AND EXTRACT(MONTH FROM invoicedate) = 12
GROUP BY year, month;

-- 6. Top 10 products by sales amount
SELECT 
    stockcode,
    description,
    ROUND(SUM(quantity * price), 2) AS total_sales
FROM online_sales
GROUP BY stockcode, description
ORDER BY total_sales DESC
LIMIT 10;

-- 7. Top 10 products by quantity sold
SELECT 
    stockcode,
    description,
    SUM(quantity) AS total_quantity
FROM online_sales
GROUP BY stockcode, description
ORDER BY total_quantity DESC
LIMIT 10;

-- 8. Total revenue by country
SELECT 
    country,
    ROUND(SUM(quantity * price), 2) AS total_revenue
FROM online_sales
GROUP BY country
ORDER BY total_revenue DESC;

-- 9. Number of customers by country
SELECT 
    country,
    COUNT(DISTINCT customer_id) AS customer_count
FROM online_sales
WHERE customer_id IS NOT NULL
GROUP BY country
ORDER BY customer_count DESC;

-- 10. Daily revenue trend
SELECT 
    DATE(invoicedate) AS order_date,
    ROUND(SUM(quantity * price), 2) AS daily_revenue
FROM online_sales
GROUP BY DATE(invoicedate)
ORDER BY order_date;

-- 11. Average order value
SELECT 
    ROUND(SUM(quantity * price) / COUNT(DISTINCT invoice), 2) AS avg_order_value
FROM online_sales;
-- 12. Customers with highest spending
SELECT 
    customer_id,
    ROUND(SUM(quantity * price), 2) AS total_spent
FROM online_sales
WHERE customer_id IS NOT NULL
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;