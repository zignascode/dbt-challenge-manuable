/*¿Cuáles son los 5 productos más vendidos por mes durante el último trimestre, 
y cuál fue su variación porcentual en revenue vs el mes anterior?*/


-- Tabla temporal para extraer los registros de los últimos tres meses
WITH monthly_sales AS (
  SELECT
    FORMAT_DATE('%Y-%m', DATE(order_date)) AS month, --Ajuste de año con mes
    product_id,
    product_name,
    SUM(quantity) AS total_quantity, -- Cantidad total de ventas por mes de cada producto
    SUM(item_revenue) AS total_revenue -- Ingreso total de ventas por mes de cada producto
  FROM raw.int_orders
  WHERE order_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH) -- Filtro del último trimestre
  AND order_status = 'completed' -- Solo órdenes completadas
  AND quantity IS NOT NULL -- Cantidades no nulas
  AND quantity > 0  -- Cantidades no negativas
  GROUP BY month,product_id,product_name
),

-- Tabla temporal para obtener los ranking de más vendidos y el revenue del mes anterior
ranked_sales AS (
  SELECT
    month,
    product_name,
    total_revenue,
    total_quantity,
    -- Ranking de cantidades por mes
    RANK() OVER (PARTITION BY month ORDER BY total_quantity DESC) AS rank_in_month,
    -- Ingreso total del mes anterior
    LAG(total_revenue) OVER (PARTITION BY product_id ORDER BY month) AS prev_revenue
  FROM monthly_sales
)

-- Consolidación de la consulta
SELECT
  month,
  product_name,
  total_revenue,
  total_quantity,
  rank_in_month,
  -- Cálculo de la variación
  SAFE_DIVIDE(total_revenue - prev_revenue, prev_revenue) * 100 AS pct_variation
FROM ranked_sales
 -- Filtra el top 5 del ranking
WHERE rank_in_month <= 5
ORDER BY month, total_revenue DESC