{% macro customer_segment(total_revenue, total_orders) %}
    CASE
      WHEN {{ total_revenue }} > 5000 THEN 'VIP'
      WHEN {{ total_revenue }} > 500 THEN 'Regular'
      WHEN {{ total_orders }} < 2 THEN 'NUEVO'
      ELSE 'Regular'
    END
{% endmacro %}