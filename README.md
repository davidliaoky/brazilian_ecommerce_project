
# Brazilian E-Commerce Analytics Project (Olist)

This project implements a complete data pipeline and warehouse for the [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce), using **dbt**, **BigQuery**, and **Python**.

---

## 📦 Project Structure

- **/models/dims/** – Dimension tables (customers, products, sellers, dates)
- **/models/facts/** – Fact tables (orders, order items, reviews, metrics)
- **/seeds/** – Raw CSVs loaded into BigQuery via `dbt seed`
- **/tests/** – Custom data quality checks (e.g., total price non-negative)
- **/docs/** – Optional markdown documentation
- **/notebooks/** – Python-based data analysis using BigQuery

---

## 🧱 Schema Design

Star schema with:
- ✅ `dim_customers`, `dim_orders`, `dim_products`, `dim_sellers`, `dim_dates`
- ✅ `fact_order_items`, `fact_reviews`, `fact_customer_lifetime`, `fact_monthly_sales`, `fact_product_sales_summary`

---

## 🛠️ Tools Used

| Tool      | Purpose                                 |
|-----------|-----------------------------------------|
| **dbt**   | Data modeling, testing, transformation  |
| **BigQuery** | Cloud data warehouse for storage       |
| **Python (Jupyter)** | Data analysis and visualization |
| **GitHub** | Project version control and hosting     |

---

## 🚀 How to Run

1. Clone the repo:
```bash
git clone https://github.com/davidliaoky/brazilian_ecommerce_project.git
cd brazilian_ecommerce_project
```

2. Set up dbt and BigQuery credentials

3. Run the pipeline:
```bash
dbt deps
dbt seed
dbt run
dbt test
```

4. Generate docs:
```bash
dbt docs generate
dbt docs serve
```

---

## 📊 Data Analysis (Python)

Performed in [notebooks/Data_Analysis.ipynb](notebooks/Data_Analysis.ipynb), including:
- Monthly revenue trends
- Top-selling products
- Customer lifetime value distribution

---

## ✅ Data Quality Checks

Tests implemented using:
- `not_null`, `unique`, `accepted_values`
- Custom SQL tests in `/tests`
- Schema-based validations in `schema.yml`

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

## 📎 Assignment Mapping

| Step | Task                        | Completed |
|------|-----------------------------|-----------|
| 1    | Data Acquisition            | ✅        |
| 2    | Warehouse Design (Star Schema) | ✅     |
| 3    | ELT Pipeline (dbt models)   | ✅        |
| 4    | Data Quality Checks         | ✅        |
| 5    | Python Data Analysis        | ✅        |
| 6    | Orchestration (scheduled)   | ⏳ Pending |
| 7    | Documentation               | ✅        |

---

## 🧠 Key Insights

- Revenue is concentrated in peak shopping months
- A few products drive most sales — stock prioritization is key
- High-value customers are few — ideal for loyalty/CRM targeting

---

©️ Developed as part of a Data Engineering assignment.
