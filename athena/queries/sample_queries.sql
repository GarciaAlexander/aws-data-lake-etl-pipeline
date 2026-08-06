-- View all curated records
SELECT *
FROM curated_sales_data
LIMIT 50;

-- Total sales amount by vendor
SELECT vendor, SUM(amount) AS total_amount
FROM curated_sales_data
GROUP BY vendor
ORDER BY total_amount DESC;

-- Filter by date range
SELECT *
FROM curated_sales_data
WHERE date >= DATE '2026-01-01'
ORDER BY date;

-- Identify records with missing or normalized fields
SELECT *
FROM curated_sales_data
WHERE vendor = 'Unknown';
