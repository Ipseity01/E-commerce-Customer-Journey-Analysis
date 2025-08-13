# E-commerce Customer Journey Analysis (SQL Project)

## Overview
This project analyzes a simulated e-commerce dataset to uncover key business insights.  
Using **SQL** and three interconnected tables — `events1`, `users`, and `items` — I calculated various KPIs related to:
- User behavior
- Product performance
- Funnel conversion rates
- Time-based trends
- Geographic and device-based performance

The SQL results were later visualized in **Excel** and **Power BI** for interactive dashboards.

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


