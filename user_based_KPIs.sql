-- 1. Active Users

SELECT COUNT(DISTINCT user_id) AS active_users
FROM events1;

-- 2. High LTV Customers with Purchases

SELECT u.id AS user_id, u.ltv, COUNT(*) AS purchase_count
FROM users u
JOIN events1 e ON u.id = e.user_id
WHERE e.type = 'purchase'
GROUP BY u.id, u.ltv
ORDER BY u.ltv DESC;

-- 3. Average Purchases per User

SELECT COUNT(*) / COUNT(DISTINCT user_id) AS avg_purchases_per_user
FROM events1
WHERE type = 'purchase';

-- 4. Average Revenue per User

SELECT SUM(i.price_in_usd) / COUNT(DISTINCT e.user_id) AS avg_revenue_per_user
FROM events1 e
JOIN items i ON e.item_id = i.id
WHERE e.type = 'purchase';

-- 5. Repeat Buyers

SELECT user_id, COUNT(*) AS purchase_count
FROM events1
WHERE type = 'purchase'
GROUP BY user_id
HAVING COUNT(*) > 1;

-- 6. Churn Proxy: 1-time purchasers

SELECT user_id
FROM events1
WHERE type = 'purchase'
GROUP BY user_id
HAVING COUNT(*) = 1;
