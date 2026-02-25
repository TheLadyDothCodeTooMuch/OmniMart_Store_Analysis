INSERT INTO silver_dim_customers (customer_id, customer_name, customer_email, customer_date_of_birth, customer_city, customer_country, customer_signup_date
)
WITH cleaned_name AS (
   SELECT
        id, 
		TRIM(REGEXP_REPLACE(name, '^(Mr|Ms|Mrs|Dr|Prof)\\.?\\s+', '')) AS new_name,
        email, 
        date_of_birth, 
        city, 
        country, 
        signup_date
	FROM bronze_dim_customers)
SELECT
	id, 
	TRIM(REGEXP_REPLACE(new_name, '\\s(PhD|PHD|MD|II|III|DVM)\\.?$', '')) AS cleaned_new_name,
	email, 
	date_of_birth, 
	city, 
	country, 
	signup_date
FROM cleaned_name;
    
    
INSERT INTO silver_dim_products (product_id, product_title, product_price, product_description, product_category, product_subcategory)
    SELECT
		id, 
		title,
		price,
		description,
		category,
		subcategory
    FROM bronze_dim_products;
    
    
INSERT INTO silver_fact_orders (order_key, order_id, customer_id, order_date, product_id, quantity, total_amount)
    SELECT
		DENSE_RANK() OVER(ORDER BY order_id) AS order_key,
		order_id,
		customer_id,
		order_date,
		product_id,
		quantity,
		total_amount
    FROM bronze_fact_orders;    
