-- 1. Best-Selling Items (by number of purchases)

SELECT i.name, COUNT(*) AS purchase_count
FROM events1 e
JOIN items i ON e.item_id = i.id
WHERE e.type = 'purchase'
GROUP BY i.name
ORDER BY purchase_count DESC
LIMIT 10;

-- 2. Revenue by Category

SELECT i.category, SUM(i.price_in_usd) AS total_revenue
FROM events1 e
JOIN items i ON e.item_id = i.id
WHERE e.type = 'purchase'
GROUP BY i.category
ORDER BY total_revenue DESC;

-- 3. Top Revenue-Generating Items

SELECT i.name, SUM(i.price_in_usd) AS revenue_generated
FROM events1 e
JOIN items i ON e.item_id = i.id
WHERE e.type = 'purchase'
GROUP BY i.name
ORDER BY revenue_generated DESC
LIMIT 10;

-- 4. Average Price per Category

SELECT category, AVG(price_in_usd) AS avg_price
FROM items
GROUP BY category
ORDER BY avg_price DESC;

-- 5. Item Purchase Frequency by Category

SELECT i.category, COUNT(*) AS total_purchases
FROM events1 e
JOIN items i ON e.item_id = i.id
WHERE e.type = 'purchase'
GROUP BY i.category
ORDER BY total_purchases DESC;

-- 6. Most Viewed (or Added to Cart) Items
SELECT i.name, COUNT(*) AS add_to_cart_count
FROM events1 e
JOIN items i ON e.item_id = i.id
WHERE e.type = 'add_to_cart'
GROUP BY i.name
ORDER BY add_to_cart_count DESC
LIMIT 10;


