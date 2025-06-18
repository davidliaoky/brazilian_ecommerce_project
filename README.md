# Brazilian E-Commerce Analytics Project (Olist)

This project implements a complete data pipeline and warehouse for the [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce), using **dbt**, **BigQuery**, and **Python**.

---

## 📦 Project Structure

This project follows a modular and organized directory layout, aligned with the core components of a dbt and Python-based analytics pipeline. Here's how the folders map to the GitHub repository structure:

- **/models/dims/** – Contains dbt models for dimension tables, such as `dim_customers.sql`, `dim_products.sql`, etc. These files transform raw seeded data into reusable lookup tables.
- **/models/facts/** – Contains dbt models for fact tables, such as `fact_order_items.sql` or `fact_reviews.sql`. These aggregate transactional and behavioral data.
- **/seeds/** – Includes raw and cleaned CSVs (e.g., `orders.csv`, `order_reviews.csv`) that are loaded into BigQuery using `dbt seed`.
- **/tests/** – Houses custom dbt data quality tests (e.g., test\_total\_price\_positive.sql) to validate integrity of the data models.
- **/docs/** – Optional markdown files used to enhance project documentation and support `dbt docs` generation.
- **/notebooks/** – Jupyter notebooks used for final-stage data analysis. For example, `Data_Analysis.ipynb` connects to BigQuery and computes KPIs like revenue trends and top-selling products.

This structure ensures clean separation of concerns between modeling, testing, documentation, and analysis.

---

## 🛠️ Tools Used

To build a scalable and maintainable data pipeline, we used the following tools:

| Tool                 | Purpose                                                                                              |
| -------------------- | ---------------------------------------------------------------------------------------------------- |
| **dbt**              | Enables modular SQL-based transformations, testing, and documentation for ELT pipelines.             |
| **BigQuery**         | Fully-managed cloud data warehouse with high scalability, used to store and query the ingested data. |
| **Python (Jupyter)** | Used for data inspection, transformation, and final analysis with pandas and SQLAlchemy.             |
| **GitHub**           | Facilitates version control, collaboration, and submission tracking.                                 |

These tools together streamline the process of data ingestion, transformation, validation, and analysis, allowing fast iteration with production-grade quality.

---

## ⚙️ Environment Configuration

- A Google Cloud project was initialized, and a new BigQuery dataset (i.e. `brazilian_ecommerce`) was created manually via the BigQuery Console.
- The dataset was configured in the `US` multi-region to ensure compatibility with the Kaggle source data and dbt seed commands.
- Service account credentials were set up and stored securely to allow dbt access to the BigQuery warehouse.

---

## 📥 Data Ingestion

The raw CSV files from the [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) were ingested into **Google BigQuery** using the following process:

1. **Downloading Data from Kaggle**

   - The dataset was downloaded from Kaggle and extracted locally:
     ```bash
     kaggle datasets download -d olistbr/brazilian-ecommerce
     unzip brazilian-ecommerce.zip -d olist_data
     ```

2. **Initial Data Inspection**

   - All CSVs were inspected for encoding issues, line breaks, and malformed rows.
   - A known issue in `order_reviews_dataset.csv` was identified: line breaks in the `review_comment_message` field caused row misalignment.

3. **Cleaning Data via Python Scripts**

   - A Python script was used to clean the problematic file by removing newline characters from the review messages.
   - This cleaned version was renamed to `order_reviews.csv` to reflect its cleaned status:
     ```python
     import pandas as pd

     df_cleaned = pd.read_csv("olist_data/olist_order_reviews_dataset.csv")
     df_cleaned["review_comment_message"] = df_cleaned["review_comment_message"].astype(str).str.replace(r'[\n\r]+', ' ', regex=True)
     df_cleaned.to_csv("olist_data/order_reviews.csv", index=False)
     ```

4. **Standardizing and Moving Files to dbt Seeds Folder**

   - All files were renamed to follow a consistent naming scheme (e.g., removing `olist_` prefix and `_dataset` suffix), then copied to the `seeds` folder for dbt ingestion.
   - The script also skips the already cleaned `order_reviews.csv` to avoid overwriting:
     ```python
     import shutil
     import os

     source_folder = "olist_data"
     target_folder = "seeds"

     for file_name in os.listdir(source_folder):
         if file_name.endswith(".csv") and file_name != "order_reviews.csv":
             new_name = file_name.replace("olist_", "").replace("_dataset", "")
             shutil.copy(os.path.join(source_folder, file_name), os.path.join(target_folder, new_name))
     ```

5. **Seeding Data to BigQuery via dbt**

   - With all cleaned and renamed files in place, the following command was used to load them into BigQuery:
     ```bash
     dbt seed
     ```

---

## ✅ Data Quality Checks

To ensure data reliability, we implemented rigorous tests using **dbt-expectations**, an extension of dbt that adds expectations-style assertions. These helped validate assumptions about the data across both dimension and fact tables.

### ✔️ Tests Implemented:

- `not_null` – Ensures critical fields (e.g., primary/foreign keys) are not missing
- `unique` – Enforces entity uniqueness (e.g., IDs in dimension tables)
- `accepted_values` – Checks for valid categorical values (e.g., review scores between 1–5)
- **Custom SQL tests** – Applied to validate business logic, such as:
  - `price >= 0`
  - `freight_value >= 0`
  - Foreign key integrity between fact and dimension tables

These tests were defined in `schema.yml` files and run automatically with:

```bash
dbt test
```

### ⚠️ Challenges Encountered:

During testing, we encountered an issue with unexpected nulls in `product_category_name`, which stemmed from missing foreign key relationships in the raw data. This required either enriching the data with external mappings or accepting a reduced granularity in product-level analyses.

This finding underscores the importance of enforcing rigorous data quality checks as part of the pipeline.

---

## 🧱 Schema Design

This project adopts a star schema to structure the data warehouse efficiently for analysis and reporting. At the center of the schema is the primary fact table surrounded by multiple dimension tables.

**Star schema includes:**

- ✅ `dim_customers` — customer details
- ✅ `dim_orders` — order-level metadata and timestamps
- ✅ `dim_products` — product category and names
- ✅ `dim_sellers` — seller information and locations
- ✅ `dim_dates` — calendar breakdown for time-based reporting

**Fact tables:**

- ✅ `fact_order_items` — core transactional facts including price, freight, quantity
- ✅ `fact_reviews` — review scores and comment counts
- ✅ `fact_customer_lifetime` — customer-centric aggregations
- ✅ `fact_monthly_sales` — time-aggregated revenue
- ✅ `fact_product_sales_summary` — product-level revenue summary

---

## 📊 Data Analysis (Python)

The final stage of this pipeline involved extracting insights from the processed data using Python and BigQuery. The analysis was conducted in a Jupyter Notebook using `pandas`, `matplotlib`, and `sqlalchemy` to connect to the data warehouse and execute SQL queries.

### 🔍 Key Analyses Performed:

1. **Monthly Revenue Trends**

   - Aggregated total revenue (`price + freight_value`) by month using `dim_dates` and `fact_monthly_sales`.
   - Visualized seasonal trends and revenue spikes.

2. **Top-Selling Products**

   - Ranked products based on total sales revenue using `fact_product_sales_summary`.
   - Joined with `dim_products` to display readable product category names.

3. **Customer Lifetime Value (CLV)**

   - Calculated total revenue per customer using `fact_customer_lifetime`.
   - Analyzed distribution of customer value across the dataset.

4. **Review Score Distribution**

   - Used `fact_reviews` to compute average ratings by product category.
   - Detected categories with low satisfaction and possible quality issues.

5. **Product Category Segmentation**

   - Clustered product categories based on sales volume, review scores, and average price.

Each analysis cell in the notebook was documented with SQL logic and chart outputs, supporting exploratory investigation and business insight generation.

---

## ⏰ Orchestration (Planned)

To be scheduled using dbt Cloud or a local cron job to automate nightly runs.

---

## 📚 Documentation

Full DAG and model documentation generated using `dbt docs`:

```bash
dbt docs generate && dbt docs serve
```

---

## 📌 Assignment Mapping

| Step | Task                           | Completed |
| ---- | ------------------------------ | --------- |
| 1    | Data Acquisition               | ✅         |
| 2    | Warehouse Design (Star Schema) | ✅         |
| 3    | ELT Pipeline (dbt models)      | ✅         |
| 4    | Data Quality Checks            | ✅         |
| 5    | Python Data Analysis           | ✅         |
| 6    | Orchestration (scheduled)      | ⏳ Pending |
| 7    | Documentation                  | ✅         |

---

## 🧠 Key Insights

- Revenue is concentrated in peak shopping months
- A few products drive most sales — stock prioritization is key
- High-value customers are few — ideal for loyalty/CRM targeting

---

©️ Developed as part of a Data Engineering assignment.

