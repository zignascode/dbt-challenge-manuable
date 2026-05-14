{{ config(materialized='table') }}

SELECT
    customer_id,
    customer_name,
    email,
    first_order_date,
    last_order_date,
    total_orders,
    total_revenue,
    -- Se usa aquí la macros customer_segment para segmentar a los clientes
    {{ customer_segment('total_revenue', 'total_orders') }} AS customer_segment
FROM {{ ref('int_customers') }}
ORDER BY customer_id DESC