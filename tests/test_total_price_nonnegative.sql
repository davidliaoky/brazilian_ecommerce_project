-- tests/test_total_price_nonnegative.sql

SELECT *
FROM {{ ref('fact_order_items') }}
WHERE total_price IS NULL OR total_price < 0
