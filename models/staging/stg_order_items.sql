{{ config(materialized='view') }}

SELECT DISTINCT
  order_id,
  product_id,
  quantity

FROM (
  SELECT
    order_id,
    product_id,
    SAFE_CAST(quantity AS INT64) AS quantity,
    CASE -- Si el producto no existe en stg_products, lo marcamos como "NOT EXIST"
      WHEN product_id NOT IN (SELECT product_id FROM {{ source('raw','products') }})
        THEN 'NOT EXIST'
        ELSE product_id
    END AS existance_condition,
    --CASE -- Si el negativo es un error, lo marcamos como "INVALID"
    --  WHEN SAFE_CAST(quantity AS INT64) < 0
    --    THEN 'INVALID'
    --END AS quantity_condition
  FROM {{ source('raw','order_items') }}
)

WHERE existance_condition <> 'NOT EXIST'
AND order_id IS NOT NULL
ORDER BY order_id DESC