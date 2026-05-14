{{ config(materialized='view') }}

SELECT
  TRIM(customer_id) AS customer_id,
  -- Se usa aquí la macro normalize_text para limpiar y estandarizar los campos de texto
  {{ normalize_text('name') }} AS customer_name,
  {{ normalize_text('email') }} AS email
FROM {{ source('raw','customers') }}
WHERE customer_id IS NOT NULL
ORDER BY customer_id