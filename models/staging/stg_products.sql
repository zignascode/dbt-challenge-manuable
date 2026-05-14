{{ config(materialized='view') }}

SELECT DISTINCT
  product_id,
  TRIM(name) AS product_name,
  SAFE_CAST(price AS NUMERIC) AS price
FROM {{ source('raw','products') }}
WHERE product_id IS NOT NULL
ORDER BY product_id