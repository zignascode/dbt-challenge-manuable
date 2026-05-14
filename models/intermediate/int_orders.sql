{{ config(materialized='view') }}

WITH orders_products AS (
    SELECT
        oi.order_id,
        oi.product_id,
        p.product_name,
        p.price,
        oi.quantity,
        oi.quantity * p.price AS item_revenue
    FROM {{ ref('stg_order_items') }} oi
    LEFT JOIN {{ ref('stg_products') }} p ON (oi.product_id = p.product_id)
)

SELECT
    o.order_id,
    o.order_status,
    o.order_date,
    o.customer_id,
    op.product_id,
    op.product_name,
    op.price,
    op.quantity,
    op.item_revenue

FROM {{ ref('stg_orders') }} o
LEFT JOIN orders_products op ON (o.order_id = op.order_id)

ORDER BY order_id DESC