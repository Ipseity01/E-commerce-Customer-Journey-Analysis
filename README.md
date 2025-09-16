# E-commerce Customer Journey Analysis (SQL Project)

## Overview
This project analyzes a simulated e-commerce dataset to uncover key business insights.  
Using **SQL** and three interconnected tables — `events1`, `users`, and `items` — I calculated various KPIs related to:
- User behavior
- Product performance
- Funnel conversion rates
- Time-based trends
- Geographic and device-based performance

---

## Dataset Description

**1. events1 Table**
| Column       | Description |
|--------------|-------------|
| user_id      | Unique customer ID |
| item_id      | Purchased or viewed item ID |
| type         | Event type (view, add_to_cart, purchase) |
| date         | Timestamp of event |
| country      | Customer country |
| device       | Device used (mobile, desktop, etc.) |

**2. users Table**
| Column | Description |
|--------|-------------|
| id     | Unique customer ID |
| ltv    | Lifetime value of the customer |

**3. items Table**
| Column        | Description |
|---------------|-------------|
| id            | Unique product ID |
| name          | Product name |
| category      | Product category |
| price_in_usd  | Price in USD |

---

## KPI Analysis

### User-Based KPIs (`user_based_KPIs.sql`)

1. **Active Users** – Count of unique users who engaged with the platform.  
   ```sql
   SELECT COUNT(DISTINCT user_id) AS active_users FROM events1;
   ```
   **Insight**: The platform had 3,862 active users during the analysis period, representing the total number of unique customers who engaged through at least one activity      (view, add to cart, or purchase).

2. **High LTV Customers with Purchases** – Customers sorted by their lifetime value and purchase frequency.
   ```sql
   SELECT u.id AS user_id, u.ltv, COUNT(*) AS purchase_count
   FROM users u
   JOIN events1 e ON u.id = e.user_id
   WHERE e.type = 'purchase'
   GROUP BY u.id, u.ltv
   ORDER BY u.ltv DESC;
   ```
   **Insight**: High-value customers exhibit both strong lifetime value (LTV) and frequent purchasing activity.
   - The top customer (User ID 186) has an LTV of $1,215 and made 5 purchases.
   - Several customers combine high LTV and high purchase frequency, such as User ID 1154 with an LTV of $670 and 22 purchases, indicating strong loyalty.
    This analysis helps identify VIP customers who contribute disproportionately to revenue and should be prioritized for retention strategies.

3. **Average Purchases per User**
   ```sql
   SELECT COUNT(*) / COUNT(DISTINCT user_id) AS avg_purchases_per_user
   FROM events1
   WHERE type = 'purchase';
   ```
   **Insight**: On average, each purchasing customer completed ~4.13 purchases during the analysis period.
   This indicates moderate repeat buying behavior, suggesting that while customers do return for additional purchases, there is potential to implement loyalty programs or      targeted promotions to further increase purchase frequency.

4. **Average Revenue per User**
   ```sql
   SELECT SUM(i.price_in_usd) / COUNT(DISTINCT e.user_id) AS avg_revenue_per_user
   FROM events1 e
   JOIN items i ON e.item_id = i.id
   WHERE e.type = 'purchase';
   ```
   **Insight**: The average revenue per purchasing customer is $82.15.
   This metric represents the typical contribution of each buyer to total revenue and can serve as a baseline for customer acquisition cost (CAC) planning and revenue          forecasting. Increasing this figure through upselling, cross-selling, or bundling could directly improve overall profitability.

5. **Repeat Buyers**
   ```sql
   SELECT user_id, COUNT(*) AS purchase_count
   FROM events1
   WHERE type = 'purchase'
   GROUP BY user_id
   HAVING COUNT(*) > 1;
   ```
   **Insight**: A significant portion of the customer base demonstrates repeat purchasing behavior.
   - 1214 unique customers made more than one purchase during the analysis period.
   - The highest repeat purchase count was 60 purchases by a single customer (User ID 15696), showing strong loyalty and engagement.
   - Multiple customers recorded 10+ purchases, suggesting a core group of highly engaged buyers who contribute substantially to recurring revenue. This highlights an         opportunity for retention strategies such as loyalty rewards or personalized offers to further nurture these high-value customers.

6. **Churn Proxy: 1-time purchasers**
   ```sql
   SELECT user_id
   FROM events1
   WHERE type = 'purchase'
   GROUP BY user_id
   HAVING COUNT(*) = 1;
   ```
   **Insight**: A total of 350 customers made only one purchase during the analysis period.
   - This segment represents customers who engaged with the platform but did not return for repeat transactions.
   - While some of these may be one-time buyers by nature, others could represent missed opportunities for upselling, cross-selling, or retention campaigns.
   - Targeted strategies such as post-purchase follow-ups, personalized recommendations, or exclusive discounts could help convert a portion of these single-purchase            customers into repeat buyers, thereby increasing customer lifetime value (LTV).

### Product-Based KPIs (`product_based_KPIs.sql`)

1. **Best-Selling Items (by number of purchases)**  
   ```sql
   SELECT i.name, COUNT(*) AS purchase_count
   FROM events1 e
   JOIN items i ON e.item_id = i.id
   WHERE e.type = 'purchase'
   GROUP BY i.name
   ORDER BY purchase_count DESC
   LIMIT 10;
   ```
   **Insight**: The top-selling products during the analysis period were dominated by Google-branded apparel and merchandise.
   - The highest-selling item was the Google F/C Longsleeve Charcoal with 134 purchases, followed closely by the Google Zip Hoodie F/C (129 purchases) and the                   Super G Unisex Joggers (121 purchases).
   - Apparel items, particularly long-sleeves, hoodies, and joggers, occupy most of the top positions, suggesting a strong customer preference for wearable                      merchandise.
   - The presence of lifestyle items such as the Google Camp Mug Ivory and the Google Clear Pen 4-Pack in the top 10 indicates that non-apparel items also                       contribute significantly to sales, providing cross-selling opportunities.

2. **Revenue by Category**
   ```sql
   SELECT i.category, SUM(i.price_in_usd) AS total_revenue
   FROM events1 e
   JOIN items i ON e.item_id = i.id
   WHERE e.type = 'purchase'
   GROUP BY i.category
   ORDER BY total_revenue DESC;
   ```
   **Insight**: Revenue analysis by product category reveals that Apparel is the clear market leader, generating $75,624 in total sales — significantly higher than any        other category.

3. **Top Revenue-Generating Items**
   ```sql
   SELECT i.name, SUM(i.price_in_usd) AS revenue_generated
   FROM events1 e
   JOIN items i ON e.item_id = i.id
   WHERE e.type = 'purchase'
   GROUP BY i.name
   ORDER BY revenue_generated DESC
   LIMIT 10;
   ```
   **Insight**: The revenue leaderboard is dominated by high-value apparel items, highlighting the strong customer preference for premium Google-branded clothing.
   - Google Zip Hoodie F/C leads with $6,384, followed closely by the Google Badge Heavyweight Pullover Black ($5,428) and Google Men's Tech Fleece Grey                         ($4,922), indicating that hoodies and outerwear are top revenue drivers.
   - Sweatshirts and joggers such as the Google Crewneck Sweatshirt Navy ($4,356) and Super G Unisex Joggers ($3,875) further reinforce the dominance of                         comfort-oriented apparel.
   - Even within the top 10, no non-apparel products appear, suggesting that apparel generates the highest returns and should remain the primary focus for                       stock replenishment, seasonal launches, and marketing campaigns.

4. **Average Price per Category**
   ```sql
   SELECT category, AVG(price_in_usd) AS avg_price
   FROM items
   GROUP BY category
   ORDER BY avg_price DESC;
   ```
   **Insight**: The highest-priced category is Black Lives Matter merchandise, averaging $52.00, followed by Gift Cards ($46.25) and Apparel ($34.37).
   - This pricing structure suggests premium positioning for certain apparel lines and cause-related merchandise, potentially driven by exclusivity or limited-edition           status.
   - Mid-range categories include Bags ($28.91), Shop by Brand ($26.13), and Lifestyle ($21.31), offering accessible options while still contributing significantly to           total revenue.
   - Lower-priced categories such as Stationery ($3.13) and Fun items ($2.00) serve as entry-level purchases that can drive impulse buying and attract budget-conscious          customers, supporting upsell opportunities into higher-margin products.

5. **Item Purchase Frequency by Category**
   ```sql
   SELECT i.category, COUNT(*) AS total_purchases
   FROM events1 e
   JOIN items i ON e.item_id = i.id
   WHERE e.type = 'purchase'
   GROUP BY i.category
   ORDER BY total_purchases DESC;
   ```
   **Insight**: Apparel dominates customer demand with 2,395 purchases, far exceeding other categories and indicating a strong preference for wearable merchandise.
   - Secondary demand centers around Campus Collection (591 purchases) and New arrivals (567 purchases), showing the importance of product novelty and themed collections        in driving engagement.
   - Categories such as Accessories (474 purchases) and Office supplies (363 purchases) maintain steady demand, suggesting they are dependable repeat-purchase items.
   - Lower-volume categories like Eco-Friendly (3 purchases), Gift Cards (2 purchases), and Black Lives Matter (1 purchase) may indicate niche appeal or limited                 promotion/availability. These could represent untapped opportunities if strategically marketed.

6. **Most Viewed (or Added to Cart) Items**
   ```sql
   SELECT i.name, COUNT(*) AS add_to_cart_count
   FROM events1 e
   JOIN items i ON e.item_id = i.id
   WHERE e.type = 'add_to_cart'
   GROUP BY i.name
   ORDER BY add_to_cart_count DESC
   LIMIT 10;
   ```
   **Insight**: The YouTube Twill Sandwich Cap Black stands out as the most frequently added-to-cart item with a massive 864 adds, far surpassing all other products. This     suggests it has exceptionally high appeal, potentially driven by brand recognition, design, or price point.
   - Other apparel and accessory items like the Google F/C Long Sleeve Tee Charcoal (92 adds) and Google Badge Heavyweight Pullover Black (73 adds) also perform strongly,       reinforcing the popularity of branded wearable merchandise.
   - Premium headwear such as the Google Leather Strap Hat Blue (72 adds) and Black (67 adds) attract notable interest, hinting at a segment of customers valuing stylish,       durable brand accessories.
   - Non-wearable items like the Google Small Standard Journal Navy (66 adds) and Google Phone Stand Bamboo (50 adds) show that stationery and lifestyle products can still      capture meaningful attention alongside apparel.
  

### Time-Based KPIs (`time_based_KPIs.sql`)

1. **Monthly Purchase Trend**  
   ```sql
   SELECT DATE_FORMAT(date, '%Y-%m') AS purchase_month, COUNT(*) AS purchase_count
   FROM events1
   WHERE type = 'purchase'
   GROUP BY purchase_month
   ORDER BY purchase_month;
   ```
   **Insight**: Purchases peaked sharply in November 2020 with 6,190 transactions, but dropped dramatically to 276 in December 2020, indicating a short-lived sales surge,     likely tied to a seasonal or promotional event.

2. **Daily Purchase Trend**
   ```sql
   SELECT DATE(date) AS purchase_day, COUNT(*) AS total_purchases
   FROM events1
   WHERE type = 'purchase'
   GROUP BY purchase_day
   ORDER BY purchase_day;
   ```
   **Insight**: Daily purchase activity surged in late November 2020, peaking at 479 purchases on Nov 30. The strong upward trend in the last week of November suggests a      major promotional event, followed by a sharp decline in early December.

3. **Day of Week Purchase Trend**
   ```sql
   SELECT DAYNAME(date) AS day_name, COUNT(*) AS purchase_count
   FROM events1
   WHERE type = 'purchase'
   GROUP BY day_name
   ORDER BY FIELD(day_name, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');
   ```
   **Insight**: Purchases peak on Mondays (1,364) and Tuesdays (1,329), then steadily decline through the week, hitting the lowest on Sundays (482) — indicating strong        early-week engagement and weaker weekend activity.

4. **Monthly Revenue Trend**
   ```sql
   SELECT DATE_FORMAT(e.date, '%Y-%m') AS month, SUM(i.price_in_usd) AS total_revenue
   FROM events1 e
   JOIN items i ON e.item_id = i.id
   WHERE e.type = 'purchase'
   GROUP BY month
   ORDER BY month;
   ```
   **Insight**: Revenue was overwhelmingly concentrated in November 2020 ($122,824), with December 2020 generating only $5,665, suggesting a one-time sales event or           campaign driving November’s spike.

### Geo-Device-Based KPIs (`geo_device_based_KPIs.sql`)

1. **Top Countries by Purchase**  
   ```sql
   SELECT country, COUNT(*) AS purchase_count
   FROM events1
   WHERE type = 'purchase'
   GROUP BY country
   ORDER BY purchase_count DESC
   LIMIT 5;
   ```
   **Insight**: The US leads with 2,903 purchases, far ahead of other countries, followed by India (576) and Canada (555). Spain (182) and the UK (162) round out the top      five, indicating a predominantly North American customer base with smaller but notable international demand.

2. **Device Preference**
   ```sql
   SELECT device, COUNT(*) AS purchase_count
   FROM events1
   WHERE type = 'purchase'
   GROUP BY device
   ORDER BY purchase_count DESC;
   ```
   **Insight**: Most purchases were made via desktop (3,567), followed by mobile (2,774), with tablet (125) contributing minimally highlighting the importance of              optimizing both desktop and mobile shopping experiences.

3. **Avg LTV by Device**
   ```sql
   SELECT e.device, AVG(u.ltv) AS avg_ltv
   FROM events1 e
   JOIN users u ON e.user_id = u.id
   GROUP BY e.device
   ORDER BY avg_ltv DESC;
   ```
   **Insight**: Customers on mobile have the highest average LTV ($151.24), followed by desktop users ($135.65), while tablet users lag significantly ($25.30) — suggesting    mobile shoppers are the most valuable segment to target for retention and upselling.

4. **LTV by Country**
   ```sql
   SELECT e.country, AVG(u.ltv) AS avg_ltv
   FROM events1 e
   JOIN users u ON e.user_id = u.id
   GROUP BY e.country
   ORDER BY avg_ltv DESC;
   ```
   **Insight**: Countries with the highest average LTV are Japan ($400.41), Hong Kong ($378.00), and Philippines ($375.00), indicating extremely high-value customer           segments in these regions. In contrast, major markets like the US ($103.88) and India ($149.70) have lower average LTV, suggesting opportunities for revenue growth         through targeted upselling and retention strategies.

### Funnel-Based KPIs (`funnel_based_KPIs.sql`)

1. **Unique Users at Each Funnel Stage**  
   ```sql
   SELECT type, COUNT(DISTINCT user_id) AS unique_users
   FROM events1
   WHERE type IN ('view', 'add_to_cart', 'purchase')
   GROUP BY type
   ORDER BY FIELD(type, 'view', 'add_to_cart', 'purchase');
   ```
   **Insight**: Out of all engaged users, 2,506 performed at least one add-to-cart action, while 1,564 completed a purchase, indicating a significant drop-off between         interest and conversion — a potential area for funnel optimization.

2. **Conversion Rate: Add to Cart then Purchase**
   ```sql
   SELECT (SELECT COUNT(DISTINCT user_id) FROM events1 WHERE type = 'purchase') * 100 / 
       (SELECT COUNT(DISTINCT user_id) FROM events1 WHERE type = 'add_to_cart') AS cart_to_purchase_conversion;
   ```
   **Insight**: The cart-to-purchase conversion rate is 62.41%, indicating that nearly two-thirds of users who add items to their cart proceed to complete a purchase — a      strong conversion rate, though still leaving room to recover the remaining 37% through remarketing or checkout optimization.

3. **Users Who Added to Cart but Never Purchased**
   ```sql
   SELECT user_id
   FROM events1
   WHERE type = 'add_to_cart'
   AND user_id NOT IN (
       SELECT DISTINCT user_id FROM events1 WHERE type = 'purchase'
   );
   ```
   **Insight**: A total of 5,000 users added items to their cart but never completed a purchase, representing a major drop-off point in the sales funnel. Targeted             interventions like abandoned cart emails, personalized discounts, or simplified checkout could help convert a portion of these users into paying customers.

### Conclusion

This project shows how SQL can be used to turn e-commerce data into clear, actionable insights. By looking at user activity, product performance, funnel drop-offs, and geo-device trends, it highlights both what’s working like strong repeat buying behavior, high apparel sales, and solid cart-to-purchase conversions and what needs attention, such as one-time buyers, cart abandonment, and reliance on seasonal sales spikes.

The takeaways point toward opportunities to boost retention, improve the shopping funnel, and tap into high-value markets. Strategies like loyalty programs, abandoned cart campaigns, and expanding focus on international customers with higher LTV could help maximize both revenue and long-term growth. Overall, the analysis shows the real business value of applying SQL to customer journey data.










   



