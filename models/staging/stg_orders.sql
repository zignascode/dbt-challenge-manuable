{{ config(materialized='view') }}

SELECT DISTINCT
  order_id,
  TRIM(customer_id) AS customer_id,
  order_date,
  order_status,

FROM (
  SELECT
    order_id,
    SAFE_CAST(order_date AS DATE) AS order_date, -- Forzar a fecha, sino arroja null
    {{ normalize_text('status') }} AS order_status, -- Se usa la macro normalize_text
    CASE                          -- Si el producto no existe lo marcamos como "NOT EXIST"
      WHEN customer_id NOT IN (SELECT customer_id FROM {{ source('raw','customers') }})
        THEN 'NOT EXIST'
        ELSE customer_id
    END AS customer_id
  FROM {{ source('raw','orders') }} -- Fuente de datos
)

WHERE order_id IS NOT NULL -- garantiza que no haya registros de ids nulos
-- Descomentar la siguiente línea si queremos excluir los clientes que no existen:
-- AND customer_id <> 'NOT EXIST' -- Filtrar registros con clientes no existentes
ORDER BY order_id