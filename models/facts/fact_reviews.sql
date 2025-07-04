{{ config(materialized='table') }}

SELECT
  order_id,
  review_score,
  review_comment_title,
  review_comment_message,
  review_creation_date,
  review_answer_timestamp
FROM {{ ref('order_reviews') }}