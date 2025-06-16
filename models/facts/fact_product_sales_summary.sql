{{ config(materialized='table') }}

SELECT
  p.product_id,
  t.product_category_name_english,
  COUNT(*) AS units_sold,
  ROUND(SUM(i.price), 2) AS total_revenue
FROM {{ ref('order_items') }} i
JOIN {{ ref('products') }} p
  ON i.product_id = p.product_id
LEFT JOIN {{ ref('product_category_name_translation') }} t
  ON p.product_category_name = t.product_category_name
GROUP BY p.product_id, t.product_category_name_english
ORDER BY total_revenue DESC
LIMIT 20
