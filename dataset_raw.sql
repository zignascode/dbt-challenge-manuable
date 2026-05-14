-- Crear dataset raw (si no existe)
-- Script con los datos muestra para poblas el dataset raw.

CREATE SCHEMA IF NOT EXISTS raw;

-- =========================
-- Tabla raw.orders
-- =========================
CREATE OR REPLACE TABLE raw.orders AS
SELECT * FROM UNNEST([
  STRUCT('O001' AS order_id, 'C01' AS customer_id, '2024-01-15' AS order_date, 'completed' AS status),
  STRUCT('O002', 'C02', '2024-01-16', 'COMPLETED'),
  STRUCT('O002', 'C02', '2024-01-16', 'COMPLETED'), -- duplicado intencional
  STRUCT('O003', 'C03', NULL, 'pending'),
  STRUCT('O004', 'C01', '2024-02-01', 'cancelled'),
  STRUCT('O005', 'C99', '2024-02-10', 'completed') -- cliente inexistente
]);

-- =========================
-- Tabla raw.customers
-- =========================
CREATE OR REPLACE TABLE raw.customers AS
SELECT * FROM UNNEST([
  STRUCT('C01' AS customer_id, 'Ana García' AS name, 'ana@email.com' AS email),
  STRUCT('C02', 'Carlos López', 'carlos@email.com'),
  STRUCT('C03', NULL, 'sin_nombre@email.com') -- nombre nulo intencional
]);

-- =========================
-- Tabla raw.products
-- =========================
CREATE OR REPLACE TABLE raw.products AS
SELECT * FROM UNNEST([
  STRUCT('P01' AS product_id, 'Laptop' AS name, 1200.00 AS price),
  STRUCT('P02', 'Mouse', 25.00),
  STRUCT('P03', 'Teclado', 75.00)
]);

-- =========================
-- Tabla raw.order_items
-- =========================
CREATE OR REPLACE TABLE raw.order_items AS
SELECT * FROM UNNEST([
  STRUCT('O001' AS order_id, 'P01' AS product_id, 1 AS quantity),
  STRUCT('O001', 'P02', 2),
  STRUCT('O002', 'P03', 3),
  STRUCT('O004', 'P99', 1), -- producto inexistente
  STRUCT('O005', 'P01', -1) -- cantidad negativa intencional
]);