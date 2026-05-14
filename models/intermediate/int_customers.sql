{{ config(materialized='view') }}

WITH customer_orders AS (
    SELECT
        o.customer_id,
        o.order_id,
        o.order_date,
        o.order_status,
        SUM(oi.quantity * p.price) AS order_revenue
    FROM {{ ref('stg_orders') }} o
    LEFT JOIN {{ ref('stg_order_items') }} oi ON (o.order_id = oi.order_id)
    LEFT JOIN {{ ref('stg_products') }} p ON (oi.product_id = p.product_id)
    GROUP BY o.customer_id, o.order_id, o.order_date, o.order_status
)

SELECT
    c.customer_id,
    c.customer_name,
    c.email,
    COUNT(DISTINCT co.order_id) AS total_orders,
    SUM(co.order_revenue) AS total_revenue,
    MIN(co.order_date) AS first_order_date,
    MAX(co.order_date) AS last_order_date
FROM {{ ref('stg_customers') }} c
LEFT JOIN customer_orders co ON (c.customer_id = co.customer_id)
GROUP BY c.customer_id, c.customer_name, c.email
ORDER BY customer_id DESC