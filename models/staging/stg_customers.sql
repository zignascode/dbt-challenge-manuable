{{ config(materialized='view') }}

SELECT
  customer_id,
  TRIM(name) AS customer_name,
  LOWER(TRIM(email)) AS email
FROM {{ source('raw','customers') }}
WHERE customer_id IS NOT NULL
AND name IS NOT NULL
ORDER BY customer_id