{{ config(materialized='table') }}

SELECT
  i.order_id,
  i.order_item_id,
  o.customer_id,
  i.product_id,
  i.seller_id,
  i.shipping_limit_date,
  o.order_purchase_timestamp,
  i.price,
  i.freight_value,
  ROUND(i.price + i.freight_value, 2) AS total_price
FROM {{ ref('order_items') }} i
JOIN {{ ref('orders') }} o
  ON i.order_id = o.order_id
WHERE i.price IS NOT NULL AND i.freight_value IS NOT NULL
