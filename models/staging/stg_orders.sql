{{ config(materialized='view') }}

SELECT
  order_id,
  customer_id,
  SAFE_CAST(order_date AS DATE) AS order_date, -- Forzar a fecha, sino arroja null
  LOWER(TRIM(status)) AS order_status -- Limpiar espacios y convertir a minúsculas
FROM {{ source('raw','orders') }} -- Fuente de datos
WHERE order_id IS NOT NULL; --garantiza que no haya registros de ids nulos