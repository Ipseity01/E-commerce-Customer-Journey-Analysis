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
   SELECT COUNT(DISTINCT user_id) AS active_users FROM events1;
   **Insight**: The platform had 3,862 active users during the analysis period, representing the total number of unique customers who engaged through at least one activity (view, add to cart, or purchase).



