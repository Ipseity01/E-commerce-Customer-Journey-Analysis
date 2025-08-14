-- 1. Monthly Purchase Trend

SELECT DATE_FORMAT(date, '%Y-%m') AS purchase_month, COUNT(*) AS purchase_count
FROM events1
WHERE type = 'purchase'
GROUP BY purchase_month
ORDER BY purchase_month;

-- 2. Daily Purchase Trend

SELECT DATE(date) AS purchase_day, COUNT(*) AS total_purchases
FROM events1
WHERE type = 'purchase'
GROUP BY purchase_day
ORDER BY purchase_day;

-- 3. Day of Week Purchase Trend

SELECT DAYNAME(date) AS day_name, COUNT(*) AS purchase_count
FROM events1
WHERE type = 'purchase'
GROUP BY day_name
ORDER BY FIELD(day_name, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

-- 4.  Monthly Revenue Trend

SELECT DATE_FORMAT(e.date, '%Y-%m') AS month, SUM(i.price_in_usd) AS total_revenue
FROM events1 e
JOIN items i ON e.item_id = i.id
WHERE e.type = 'purchase'
GROUP BY month
ORDER BY month;


