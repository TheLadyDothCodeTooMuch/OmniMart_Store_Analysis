USE omnimart;


DROP TABLE IF EXISTS silver_dim_customers;
CREATE TABLE `silver_dim_customers` (
  `customer_id` int NOT NULL,
  `customer_name` varchar(100) NOT NULL,
  `customer_email` varchar(100) NOT NULL,
  `customer_date_of_birth` datetime DEFAULT NULL,
  `customer_city` varchar(100) DEFAULT NULL,
  `customer_country` varchar(100) NOT NULL,
  `customer_signup_date` datetime DEFAULT NULL,
  `create_table` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`customer_id`)
);


DROP TABLE IF EXISTS silver_dim_products;
CREATE TABLE IF NOT EXISTS silver_dim_products (
    product_id INT PRIMARY KEY,
    product_title VARCHAR(300),
    product_price DECIMAL(7,2),
    product_description VARCHAR(1000),
    product_category VARCHAR(100),
    product_subcategory VARCHAR(100),
    `create_table` timestamp NULL DEFAULT CURRENT_TIMESTAMP
); 


DROP TABLE IF EXISTS silver_fact_orders;
CREATE TABLE IF NOT EXISTS silver_fact_orders (
	order_key INT,
	order_id VARCHAR(100),
	customer_id INT,
	order_date DATETIME,
	product_id INT,
	quantity INT,
	total_amount DECIMAL(10,2),
     `create_table` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES silver_dim_customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES silver_dim_products(product_id) 
); 
