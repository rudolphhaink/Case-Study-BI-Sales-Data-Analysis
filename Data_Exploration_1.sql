
-- Aggregates net revenue by month using SQLite's strftime function.
-- Useful to observe monthly growth or seasonal patterns.
SELECT 
  strftime('%Y-%m', date) AS month,
  SUM(net_revenue) AS total_net_revenue
FROM sales
GROUP BY month
ORDER BY month;

-- Summarizes net revenue, cost, and profit by region.
-- Identifies top- and under-performing geographic areas.
SELECT 
  region,
  SUM(net_revenue) AS total_net_revenue,
  SUM(total_cost) AS total_cost,
  SUM(net_revenue) - SUM(total_cost) AS profit
FROM sales
GROUP BY region
ORDER BY total_net_revenue DESC;

-- Compares online vs. offline channels on key metrics:
-- transaction count, revenue, returns, and order value.
SELECT 
  channel,
  COUNT(*) AS num_transactions,
  SUM(net_revenue) AS total_net_revenue,
  SUM(returned_amount) AS total_returns,
  ROUND(AVG(price * amount), 2) AS avg_order_value
FROM sales
GROUP BY channel;

-- Evaluates each product type by net revenue and return volume.
-- Helps spotlight bestsellers and problematic products.
SELECT 
  product_type,
  SUM(net_revenue) AS total_net_revenue,
  SUM(returned_amount) AS total_returns,
  COUNT(*) AS num_sales
FROM sales
GROUP BY product_type
ORDER BY total_net_revenue DESC;

-- Breaks down revenue, cost, profit, and average order value
-- by customer type: B2B (business) vs. B2C (individual).
SELECT 
  customer_type,
  SUM(net_revenue) AS net_revenue,
  SUM(total_cost) AS total_cost,
  ROUND(SUM(net_revenue) - SUM(total_cost), 2) AS profit,
  ROUND(AVG(price * amount), 2) AS avg_order_value
FROM sales
GROUP BY customer_type;

-- Calculates return rate as a percentage of sold units.
-- High return rate products might signal quality or expectation issues.
SELECT 
  product_type,
  SUM(returned_amount) AS total_returned,
  SUM(amount) AS total_sold,
  ROUND(100.0 * SUM(returned_amount) / NULLIF(SUM(amount), 0), 2) AS return_rate_percent
FROM sales
GROUP BY product_type
ORDER BY return_rate_percent DESC;



