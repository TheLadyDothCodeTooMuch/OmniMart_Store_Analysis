-- Revenue Growth: What is the Total Revenue (GMV) month-over-month or year-over-year?
-- year-over-year
SELECT
	YEAR(order_date) AS 'Year',
	COUNT(*) AS total_transactions,
    SUM(total_amount) AS revenue  
FROM silver_fact_orders
GROUP BY YEAR(order_date)
ORDER BY 'Year';


-- month-over-month
SELECT
	MONTHNAME(order_date) AS 'Month',
   month(order_date),
	COUNT(order_id) AS total_transactions,
    COUNT(DISTINCT order_id) AS total_transactions,
    SUM(total_amount) AS revenue   
FROM silver_fact_orders
GROUP BY MONTHNAME(order_date), month(order_date)
ORDER BY month(order_date) ASC
;


SELECT
	MONTHNAME(order_date) AS 'Month',
	month(order_date) AS 'id',
	COUNT(*) AS total_transactions,
    SUM(total_amount) AS revenue   
FROM silver_fact_orders
GROUP BY MONTHNAME(order_date), month(order_date)
ORDER BY revenue DESC
;


-- Seasonality: Which months or days of the week see the highest order volume?
-- months
SELECT
	MONTHNAME(order_date) AS 'Month',
	month(order_date) AS 'id',
	COUNT(*) AS total_transactions
FROM silver_fact_orders
GROUP BY MONTHNAME(order_date), month(order_date)
ORDER BY total_transactions DESC
;

-- days of the week
SELECT
	DATE_FORMAT(order_date, '%W') AS 'Weekday',
	COUNT(*) AS total_transactions
FROM silver_fact_orders
GROUP BY DATE_FORMAT(order_date, '%W')
ORDER BY total_transactions DESC
;


-- Average Order Value (AOV): How much is the average customer spending per transaction?
SELECT
	ROUND(AVG(total_amount), 2)  AS average_order_value
FROM silver_fact_orders
;


-- Geographic Distribution: Which cities or countries are our "hotspots" for sales?
SELECT
	dc.customer_country,
	COUNT(fo.order_id) AS total_transactions,
    SUM(fo.total_amount) AS revenue
FROM silver_fact_orders AS fo
LEFT JOIN silver_dim_customers AS dc
ON fo.customer_id =  dc.customer_id
GROUP BY dc.customer_country
ORDER BY total_transactions DESC
;


-- Customer Retention: How many customers are "one-hit wonders" versus repeat buyers?
SELECT
	fo.customer_id,
	dc.customer_name,
    dc.customer_country,
	COUNT(DISTINCT fo.order_id) AS No_of_Orders,
    COUNT(fo.order_id) AS No_of_Purchases
FROM silver_fact_orders AS fo
LEFT JOIN silver_dim_customers AS dc
ON fo.customer_id = dc.customer_id
GROUP BY fo.customer_id,
	dc.customer_name,
    dc.customer_country
ORDER BY No_of_Orders DESC
;


-- Demographics: Is there a correlation between a customer's age (derived from date_of_birth) and the categories they purchase?
SELECT
    dp.product_category,
    CASE
        WHEN TIMESTAMPDIFF(YEAR, dc.customer_date_of_birth, CURDATE()) BETWEEN 16 AND 30 THEN 'Gen-Z'
        WHEN TIMESTAMPDIFF(YEAR, dc.customer_date_of_birth, CURDATE()) BETWEEN 31 AND 50 THEN 'Millenial'
        WHEN TIMESTAMPDIFF(YEAR, dc.customer_date_of_birth, CURDATE()) BETWEEN 51 AND 70 THEN 'Gen X'
        WHEN TIMESTAMPDIFF(YEAR, dc.customer_date_of_birth, CURDATE()) >= 71 THEN 'Boomer'
    END AS Age_Demographic,
    COUNT(CASE
        WHEN TIMESTAMPDIFF(YEAR, dc.customer_date_of_birth, CURDATE()) BETWEEN 16 AND 30 THEN 1
        WHEN TIMESTAMPDIFF(YEAR, dc.customer_date_of_birth, CURDATE()) BETWEEN 31 AND 50 THEN 1
        WHEN TIMESTAMPDIFF(YEAR, dc.customer_date_of_birth, CURDATE()) BETWEEN 51 AND 70 THEN 1
        WHEN TIMESTAMPDIFF(YEAR, dc.customer_date_of_birth, CURDATE()) >= 71 THEN 1
    END) AS no_of_purchases
FROM `omnimart`.`silver_fact_orders` AS fo
LEFT JOIN `omnimart`.`silver_dim_customers` AS dc
ON fo.customer_id = dc.customer_id
LEFT JOIN `omnimart`.`silver_dim_products` AS dp
ON fo.product_id = dp.product_id
GROUP BY 1,2
ORDER BY 3 DESC;


-- Top Sellers: Which products or categories generate the most revenue vs. the most volume?
SELECT
    dp.product_title,
    dp.product_category,
    dp.product_price,
    COUNT(fo.quantity) AS 'times_ordered',
    SUM(fo.quantity) AS 'quantity_ordered',
    SUM(fo.total_amount) AS 'amount'
FROM silver_fact_orders AS fo
LEFT JOIN silver_dim_products AS dp
ON fo.product_id = dp.product_id
GROUP BY dp.product_title,
    dp.product_category,
    dp.product_price
ORDER BY 3 DESC
;

SELECT
	dp.product_subcategory,
    dp.product_category,
    SUM(fo.quantity) AS 'times_ordered',
    SUM(fo.total_amount) AS 'amount'
FROM silver_fact_orders AS fo
LEFT JOIN silver_dim_products AS dp
ON fo.product_id = dp.product_id
GROUP BY dp.product_subcategory,
    dp.product_category
ORDER BY 3 DESC
;


-- Inventory Planning: Which products are underperforming and might need a marketing "push"?
SELECT
    dp.product_title,
    dp.product_category,
    dp.product_price,
    COUNT(fo.quantity) AS 'times_ordered',
    SUM(fo.quantity) AS 'quantity_ordered',
    SUM(fo.total_amount) AS 'amount'
FROM silver_fact_orders AS fo
LEFT JOIN silver_dim_products AS dp
ON fo.product_id = dp.product_id
GROUP BY dp.product_title,
    dp.product_category,
    dp.product_price
ORDER BY 4 ASC
;


SELECT
	COUNT(quantity) AS total_quantity,
    AVG(COUNT(quantity)) AS average_no_of_items,
	ROUND(AVG(total_amount), 2)  AS average_order_value
FROM silver_fact_orders
;

