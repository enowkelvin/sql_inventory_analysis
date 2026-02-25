-- ===============================================
-- Inventory Optimization & Warehouse KPI Analysis
-- Tool: MySQL Workbench
-- ===============================================

USE logistics_analysis;  -- change if your schema name differs

-- 1) Preview data
SELECT * FROM logistics_analysis.logistics LIMIT 10;

-- 2) Row count
SELECT COUNT(*) AS total_items
FROM logistics_analysis.logistics;

-- 3) Items below reorder point (stock-out risk)
SELECT
  item_id,
  category,
  stock_level,
  reorder_point,
  (reorder_point - stock_level) AS units_below_reorder
FROM logistics_analysis.logistics
WHERE stock_level < reorder_point
ORDER BY units_below_reorder DESC;

-- 4) Top items by popularity (demand signal)
SELECT
  item_id,
  category,
  item_popularity_score
FROM logistics_analysis.logistics
ORDER BY item_popularity_score DESC
LIMIT 10;

-- 5) Highest forecasted demand next 7 days (planning)
SELECT
  item_id,
  category,
  forecasted_demand_next_7d
FROM logistics_analysis.logistics
ORDER BY forecasted_demand_next_7d DESC
LIMIT 10;

-- 6) Highest stockout counts last month (service issues)
SELECT
  item_id,
  category,
  stockout_count_last_month,
  total_orders_last_month,
  order_fulfillment_rate
FROM logistics_analysis.logistics
ORDER BY stockout_count_last_month DESC
LIMIT 10;

-- 7) Fulfillment rate by category (delivery-performance equivalent)
SELECT
  category,
  AVG(order_fulfillment_rate) AS avg_fulfillment_rate,
  SUM(total_orders_last_month) AS total_orders
FROM logistics_analysis.logistics
GROUP BY category
ORDER BY avg_fulfillment_rate DESC;

-- 8) Inventory value estimate (stock_level * unit_price)
SELECT
  item_id,
  category,
  stock_level,
  unit_price,
  (stock_level * unit_price) AS inventory_value
FROM logistics_analysis.logistics
ORDER BY inventory_value DESC
LIMIT 15;

-- 9) Holding cost estimate per day (stock_level * holding_cost_per_unit_day)
SELECT
  item_id,
  category,
  stock_level,
  holding_cost_per_unit_day,
  (stock_level * holding_cost_per_unit_day) AS holding_cost_per_day
FROM logistics_analysis.logistics
ORDER BY holding_cost_per_day DESC
LIMIT 15;

-- 10) Warehouse picking efficiency by zone
SELECT
  zone,
  AVG(picking_time_seconds) AS avg_picking_time_seconds,
  AVG(layout_efficiency_score) AS avg_layout_efficiency
FROM logistics_analysis.logistics
GROUP BY zone
ORDER BY avg_picking_time_seconds;

-- 11) Turnover vs KPI score (performance view)
SELECT
  item_id,
  category,
  turnover_ratio,
  KPI_score
FROM logistics_analysis.logistics
ORDER BY KPI_score DESC
LIMIT 15;