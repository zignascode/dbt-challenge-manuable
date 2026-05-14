{{ config(materialized='view') }}

SELECT DISTINCT
  order_id,
  order_date,
  order_status,
  customer_id

FROM (
  SELECT
    order_id,
    SAFE_CAST(order_date AS DATE) AS order_date, -- Forzar a fecha, sino arroja null
    LOWER(TRIM(status)) AS order_status, -- Limpiar espacios y convertir a minúsculas
    CASE                          -- Si el producto no existe lo marcamos como "NOT EXIST"
      WHEN customer_id NOT IN (SELECT customer_id FROM {{ source('raw','customers') }})
        THEN 'NOT EXIST'
        ELSE customer_id
    END AS customer_id
  FROM {{ source('raw','orders') }} -- Fuente de datos
)

WHERE customer_id <> 'NOT EXIST' -- Filtrar registros con clientes no existentes
  AND order_id IS NOT NULL -- garantiza que no haya registros de ids nulos
ORDER BY order_id