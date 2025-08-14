-- 1. Top Countries by Purchase

SELECT country, COUNT(*) AS purchase_count
FROM events1
WHERE type = 'purchase'
GROUP BY country
ORDER BY purchase_count DESC
LIMIT 5;

-- 2. Device Preference

SELECT device, COUNT(*) AS purchase_count
FROM events1
WHERE type = 'purchase'
GROUP BY device
ORDER BY purchase_count DESC;

-- 3. Avg LTV by Device

SELECT e.device, AVG(u.ltv) AS avg_ltv
FROM events1 e
JOIN users u ON e.user_id = u.id
GROUP BY e.device
ORDER BY avg_ltv DESC;

-- 4. LTV by Country

SELECT e.country, AVG(u.ltv) AS avg_ltv
FROM events1 e
JOIN users u ON e.user_id = u.id
GROUP BY e.country
ORDER BY avg_ltv DESC;
