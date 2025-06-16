{{ config(materialized='table') }}

SELECT
  order_id,
  payment_sequential,
  payment_type,
  payment_installments,
  payment_value
FROM {{ ref('order_payments') }}