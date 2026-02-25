# OmniMart: End-to-End Retail Data Pipeline 🛒🏗️

A comprehensive data engineering project simulating a high-volume retail ecosystem. This project demonstrates a full **Medallion Architecture** workflow: generating raw data with Python, managing a relational database in MySQL, and delivering business intelligence via Power BI.

<img width="1579" height="912" alt="image" src="https://github.com/user-attachments/assets/587b67a9-54c2-4339-8044-316fcd81e29e" />

## 🏗️ Architecture Overview

The project follows a multi-layer pipeline to ensure data integrity and scalability:

1. **Bronze Layer (Raw):** 200,000+ records generated via Python scripts and loaded as-is into MySQL.
2. **Silver Layer (Refined):** Data cleaned and joined using SQL, creating a single source of truth for analytics.
3. **Visualization:** Interactive executive dashboard built in Power BI.

## 🐍 Data Extraction & Loading (Python)

To simulate a real-world environment, I used Python to generate a massive, relational dataset.

* **Tech Stack:** `Pandas`, `SQLAlchemy`, `Faker`, `Requests`.
* **Logic:** Integrated the *Fake Store API* with custom product logic to create 800 customers and 200,000 orders.
* **Key Feature:** Simulated realistic "Basket Sizes" (1-10 items per order) to enable deep behavioral analysis.

## 💾 Transformation & Cleaning (SQL)

The transition from Bronze to Silver focused on making the data "analytics-ready."

* **Sanitization:** Applied RegEx to clean customer names by removing titles and suffixes (e.g., Mr, Ms, PhD, MD, II, III).
* **Data Modeling:** Used CTEs to calculate complex metrics such as Average Order Value (AOV).
* **Optimization:** Structured the schema to maintain high performance despite the 200k+ row count.

## 📊 Business Intelligence (Power BI)

The final dashboard tracks **$638M+ in simulated revenue** and provides three core strategic pillars:

* **Basket Analysis:** Visualizing the frequency of items per cart to identify cross-selling opportunities.
* **Demographic Profiling:** Correlating customer age groups with product categories for targeted marketing.
* **Inventory Planning:** Using the Subcategory Bar Chart combined with SQL Bottom-N queries to identify which product lines are underperforming and need a strategic marketing push.


## 💡 Strategic Recommendations

* **Increase Basket Size:** Data suggests a high frequency of 1-2 item orders. I recommend tiered shipping incentives starting at 3 items. Also, implementing frequently bought together bundles for 3+ items could really drive up Average Order Value.
* **Targeted Spend:** Reallocate marketing budget to high-conversion age demographics (Gen-Zs [15-29] and Boomers [classified as 75+]) identified in the category heatmaps.
* **Inventory Shift:** I found a cluster of underperforming products with low sales frequency (women's clothing - particularly tops nad gaming devices). These are perfect candidates for a seasonal clearance or a targeted social media push to free up warehouse space.
* **Geographic Expansion:** Given the low purchase volume in North America compared to the business's success in Africa and Europe, there is a major opportunity to investigate supply chain or marketing gaps in the Western market.

---

### How to Run

1. Clone the repo.
2. Run `extract.py` to create the CSVs.
3. Use `load_to_sql.py` to push data to your MySQL instance.
4. Open the `.pbix` file to explore the dashboard.
