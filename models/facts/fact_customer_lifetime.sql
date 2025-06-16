{{ config(materialized='table') }}

SELECT
  o.customer_id,
  ROUND(SUM(i.price + i.freight_value), 2) AS lifetime_value,
  COUNT(DISTINCT o.order_id) AS num_orders,
  MIN(o.order_purchase_timestamp) AS first_purchase,
  MAX(o.order_purchase_timestamp) AS last_purchase
FROM {{ ref('order_items') }} i
JOIN {{ ref('orders') }} o
  ON i.order_id = o.order_id
GROUP BY o.customer_id
