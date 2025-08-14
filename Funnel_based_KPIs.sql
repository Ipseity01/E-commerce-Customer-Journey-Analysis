-- 1. Unique Users at Each Funnel Stage

SELECT type, COUNT(DISTINCT user_id) AS unique_users
FROM events1
WHERE type IN ('view', 'add_to_cart', 'purchase')
GROUP BY type
ORDER BY FIELD(type, 'view', 'add_to_cart', 'purchase');

-- 2. Conversion Rate: Add to Cart then Purchase

SELECT (SELECT COUNT(DISTINCT user_id) FROM events1 WHERE type = 'purchase') * 100 / 
       (SELECT COUNT(DISTINCT user_id) FROM events1 WHERE type = 'add_to_cart') AS cart_to_purchase_conversion;
    
-- 3. Users Who Added to Cart but Never Purchased

SELECT user_id
FROM events1
WHERE type = 'add_to_cart'
AND user_id NOT IN (
    SELECT DISTINCT user_id FROM events1 WHERE type = 'purchase'
);


