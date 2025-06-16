{{ config(materialized='table') }}

SELECT DISTINCT
  DATE(order_purchase_timestamp) AS date,
  EXTRACT(DAY FROM order_purchase_timestamp) AS day,
  EXTRACT(MONTH FROM order_purchase_timestamp) AS month,
  EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
  FORMAT_DATE('%Y-%m', DATE(order_purchase_timestamp)) AS year_month
FROM {{ ref('orders') }}