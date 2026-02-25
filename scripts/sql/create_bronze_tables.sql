USE omnimart;


DROP TABLE IF EXISTS bronze_dim_customers;
CREATE TABLE `bronze_dim_customers` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `date_of_birth` datetime DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `country` varchar(100) NOT NULL,
  `signup_date` datetime DEFAULT NULL,
  `create_table` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);


DROP TABLE IF EXISTS bronze_dim_products;
CREATE TABLE IF NOT EXISTS bronze_dim_products (
    id INT PRIMARY KEY,
    title VARCHAR(300),
    price DECIMAL(7,2),
    description VARCHAR(1000),
	category VARCHAR(100),
    image VARCHAR(200),
	rating VARCHAR(100),
    subcategory VARCHAR(100)
); 


DROP TABLE IF EXISTS bronze_fact_orders;
CREATE TABLE IF NOT EXISTS bronze_fact_orders (
	order_id VARCHAR(100) PRIMARY KEY,
	customer_id INT,
	order_date DATETIME,
	product_id INT,
	quantity INT,
	total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES bronze_dim_customers(id),
    FOREIGN KEY (product_id) REFERENCES bronze_dim_products(id) 
); 
