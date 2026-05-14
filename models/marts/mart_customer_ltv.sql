{{ config(materialized='table') }}

SELECT
    customer_id,
    customer_name,
    email,
    first_order_date,
    last_order_date,
    total_orders,
    total_revenue,
    CASE
        WHEN total_revenue >5000 THEN 'VIP'
        WHEN total_revenue >500 THEN 'Regular'
        WHEN total_orders <2 THEN 'NUEVO'
    END AS customer_segment
FROM {{ ref('int_customers') }}
ORDER BY customer_id DESC