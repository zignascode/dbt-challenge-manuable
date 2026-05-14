-- El test verifica que no haya pedidos con ingresos totales negativos o cero.
-- Se aplica a la tabla mart_orders_summary
-- Se espera que arroje error debido a que la tabla contiene datos que cumplen con la condición
-- Se dejaron así intencionalmente para validar el fucnionamiento del test

    order_id,
    total_revenue
FROM {{ ref('mart_orders_summary') }}
WHERE total_revenue <= 0
OR total_revenue IS NULL

--"Ninguna orden puede tener un total_revenue negativo o igual a cero." 
--Para complementar se añadió la condición de que total_revenue no sea nulo.