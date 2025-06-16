{{ config(materialized='table') }}

SELECT
  FORMAT_DATE('%Y-%m', DATE(o.order_purchase_timestamp)) AS order_month,
  ROUND(SUM(i.price + i.freight_value), 2) AS total_sales,
  COUNT(DISTINCT o.order_id) AS num_orders
FROM {{ ref('order_items') }} i
JOIN {{ ref('orders') }} o
  ON i.order_id = o.order_id
GROUP BY order_month
ORDER BY order_month
