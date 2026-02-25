## Data Dictionary

### Table silver_dim_customers
This table holds the standardized customer profiles. A key step here was using RegEx to strip titles and suffixes like Mr, Ms, PhD, and MD from the names to keep the data professional.

| Column | Data Type | Description |
| :--- | :--- | :--- |
| `customer_id` | INT (PK) | Unique identifier for each customer |
| `customer_name` | VARCHAR(100) | Standardized name with titles and suffixes removed |
| `customer_email` | VARCHAR(100) | Primary contact email address |
| `customer_date_of_birth` | DATETIME | Birth date used for age demographic segmentation |
| `customer_city` | VARCHAR(100) | City of residence |
| `customer_country` | VARCHAR(100) | Country used for geographic dispersion analysis |
| `customer_signup_date` | DATETIME | Account creation date for growth tracking |
| `create_table` | TIMESTAMP | Audit timestamp for the record load |

### Table silver_dim_products
The enriched product catalog featuring subcategory mapping for granular reporting.

| Column | Data Type | Description |
| :--- | :--- | :--- |
| `product_id` | INT (PK) | Unique identifier for the product |
| `product_title` | VARCHAR(300) | The name of the product |
| `product_price` | DECIMAL(7,2) | Unit price formatted for financial accuracy |
| `product_description` | VARCHAR(1000) | Detailed summary of the item |
| `product_category` | VARCHAR(100) | Broad category for high level filtering |
| `product_subcategory` | VARCHAR(100) | Specific grouping used for revenue bar charts |
| `create_table` | TIMESTAMP | Audit timestamp for the record load |

### Table silver_fact_orders
The central transaction table tracking the scale of the 200,000 order dataset.

| Column | Data Type | Description |
| :--- | :--- | :--- |
| `order_key` | INT | Unique identifier for the specific row |
| `order_id` | VARCHAR(100) | Checkout identifier used to calculate Basket Size |
| `customer_id` | INT (FK) | Reference to the customer who placed the order |
| `order_date` | DATETIME | Transaction date for YoY and monthly trends |
| `product_id` | INT (FK) | Reference to the specific product purchased |
| `quantity` | INT | Total units purchased in this transaction line |
| `total_amount` | DECIMAL(10,2) | Line item revenue (Quantity x Price) |
| `create_table` | TIMESTAMP | Audit timestamp for the record load |
