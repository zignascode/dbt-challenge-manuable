{{ config(materialized='table') }}

SELECT
    order_id,
    customer_id,
    order_date,
    COUNT(DISTINCT product_id) AS total_items,
    SUM(item_revenue) AS total_revenue,    
    order_status,
FROM {{ ref('int_orders') }}
GROUP BY order_id, customer_id, order_date, order_status
ORDER BY order_id DESC
