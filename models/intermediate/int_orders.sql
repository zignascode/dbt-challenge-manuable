{{ config(materialized='view') }}

SELECT
    oi.order_id,
    o.customer_id,
    oi.product_id,
    p.product_name,
    oi.quantity,
    p.price,
    oi.quantity * p.price AS item_revenue --monto por producto
FROM {{ ref('stg_order_items') }} oi
LEFT JOIN {{ ref('stg_products') }} p ON (oi.product_id = p.product_id)
LEFT JOIN {{ ref('stg_orders') }} o ON (oi.order_id = o.order_id)

ORDER BY order_id DESC