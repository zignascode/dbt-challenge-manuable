{{ config(materialized='view') }}

WITH orders_products AS (
    SELECT
        oi.order_id,
        SUM(oi.quantity * p.price) AS total_revenue
    FROM {{ ref('stg_order_items') }} oi
    LEFT JOIN {{ ref('stg_products') }} p ON (oi.product_id = p.product_id)
    GROUP BY oi.order_id
)

SELECT DISTINCT
  o.customer_id,
  c.customer_name,
  c.email,
  COUNT(DISTINCT o.order_id) AS total_orders,
  MIN(o.order_date) AS first_order_date,
  MAX(o.order_date) AS last_order_date,
  SUM(op.total_revenue) AS total_revenue

FROM {{ ref('stg_orders') }} o
LEFT JOIN orders_products op ON (o.order_id = op.order_id)
LEFT JOIN {{ ref('stg_customers') }} c ON (o.customer_id = c.customer_id)
GROUP BY o.customer_id,c.customer_name,c.email
ORDER BY o.customer_id DESC