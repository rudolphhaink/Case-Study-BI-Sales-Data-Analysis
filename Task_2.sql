-- Step 1: Filter the dataset to only include transactions from the last 6 months,
-- specifically from August 3, 2024 to Febuary 2, 2025.
WITH filtered_sales AS (
  -- Select transactions between August 3, 2024 and February 2, 2025 (inclusive)
  SELECT *
  FROM sales
  WHERE date >= '2024-08-03' AND date <= '2025-02-02'
),

-- Step 2: Aggregate sales metrics for each combination of region and sales channel (online/offline)
channel_region_stats AS (
  SELECT
    region,
    channel,

    -- Total revenue (before returns) for each region-channel pair
    SUM(total_revenue) AS total_revenue,

    -- Total number of returned units for the region-channel pair
    SUM(returned_amount) AS total_returns,

    -- Total number of units sold (before returns) in that region/channel
    SUM(amount) AS total_sold,

    -- Proportion of units returned: returned_amount ÷ amount
    -- NULLIF prevents division by zero (returns NULL if total_sold = 0)
    -- Multiplied by 1.0 to force floating-point division
    ROUND(1.0 * SUM(returned_amount) / NULLIF(SUM(amount), 0), 4) AS return_proportion
  FROM filtered_sales
  GROUP BY region, channel
),

-- Step 3: Calculate the average return proportion across all region-channel combinations
average_return AS (
  SELECT AVG(return_proportion) AS avg_return_proportion
  FROM channel_region_stats
)

-- Step 4: Final result
-- Join the stats with the average (using CROSS JOIN since we only have one row from average_return)
-- Add a boolean flag: is this region/channel's return_proportion above the overall average?
SELECT 
  s.region,
  s.channel,
  s.total_revenue,
  s.total_returns,
  ROUND(s.return_proportion, 4) AS return_proportion,

  -- Boolean expression: TRUE if this combination has above-average return rate
  s.return_proportion > a.avg_return_proportion AS above_average_return

FROM channel_region_stats s
CROSS JOIN average_return a  -- Joins every row of stats with the one-row average table
ORDER BY return_proportion DESC;  -- Show worst-performing (highest return rate) first

