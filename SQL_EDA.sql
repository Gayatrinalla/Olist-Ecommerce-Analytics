-- ============================================================
-- Olist Brazilian E-Commerce Analysis
-- SQL Exploratory Data Analysis (EDA)
-- ============================================================

USE olist_analytics;
-- ============================================================
-- SECTION 1: BUSINESS OVERVIEW
-- ============================================================

-- 1. Total Sales
SELECT
    SUM(price) AS total_sales
FROM order_items;
-- Total sales based on item price.
-- Freight charges are excluded.
-- Profit cannot be calculated because product cost is not provided.

-- 2. Total Freight Value
SELECT
    SUM(freight_value) AS total_freight
FROM order_items;

-- 3. Total Orders
SELECT
    COUNT(DISTINCT order_id) AS total_orders
FROM orders;

-- 4. Total Unique Customers
SELECT
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers;

-- 5. Average Order Value
SELECT
    SUM(price) / COUNT(DISTINCT order_id) AS average_order_value
FROM order_items;
-- Average sales value per order.
-- Based on item price only; freight is excluded.

-- 6. Average Items per Order
SELECT
    COUNT(*) / COUNT(DISTINCT order_id) AS average_items_per_order
FROM order_items;

-- 7. Total Items Sold
SELECT
    COUNT(*) AS total_items_sold
FROM order_items;

-- ============================================================
-- SECTION 2: ORDER PERFORMANCE
-- ============================================================

-- 8. Orders by Status
SELECT
    order_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

-- 9. Monthly Sales Trend
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS sales_month,
    SUM(oi.price) AS monthly_sales
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY sales_month;

-- ============================================================
-- SECTION 3: PRODUCT & CATEGORY ANALYSIS
-- ============================================================

-- 10. Top Product Categories by Sales
SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name,
        'Unknown'
    ) AS product_category,
    SUM(oi.price) AS total_sales
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name,
        'Unknown'
    )
ORDER BY total_sales DESC;

-- 11. Top Products by Sales
SELECT
    oi.product_id,
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name,
        'Unknown'
    ) AS product_category,
    SUM(oi.price) AS total_sales,
    COUNT(*) AS items_sold
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY
    oi.product_id,
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name,
        'Unknown'
    )
ORDER BY total_sales DESC
LIMIT 10;

-- ============================================================
-- SECTION 4: SELLER ANALYSIS
-- ============================================================

-- 12. Top Sellers by Sales
SELECT
    oi.seller_id,
    s.seller_city,
    s.seller_state,
    SUM(oi.price) AS total_sales,
    COUNT(*) AS items_sold
FROM order_items oi
JOIN sellers s
    ON oi.seller_id = s.seller_id
GROUP BY
    oi.seller_id,
    s.seller_city,
    s.seller_state
ORDER BY total_sales DESC
LIMIT 10;


-- ============================================================
-- SECTION 5: GEOGRAPHIC ANALYSIS
-- ============================================================

-- 13. Sales by Customer State
SELECT
    c.customer_state,
    SUM(oi.price) AS total_sales,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_state
ORDER BY total_sales DESC;

-- ============================================================
-- SECTION 6: PAYMENT ANALYSIS
-- ============================================================

-- 14. Orders by Payment Type
SELECT
    payment_type,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(payment_value) AS total_payment_value
FROM payments
GROUP BY
    payment_type
ORDER BY total_orders DESC;

-- 15. Average Payment Value by Payment Type
SELECT
    payment_type,
    COUNT(DISTINCT order_id) AS total_orders,
    AVG(payment_value) AS average_payment_value
FROM payments
GROUP BY
    payment_type
ORDER BY average_payment_value DESC;

-- ============================================================
-- SECTION 7: CUSTOMER REVIEW ANALYSIS
-- ============================================================

-- 16. Review Score Distribution
SELECT
    review_score,
    COUNT(*) AS review_count
FROM reviews
GROUP BY
    review_score
ORDER BY review_score;

-- 17. Average Review Score
SELECT
    AVG(review_score) AS average_review_score
FROM reviews;

-- 18. Average Review Score by Order Status
SELECT
    o.order_status,
    COUNT(DISTINCT r.order_id) AS reviewed_orders,
    AVG(r.review_score) AS average_review_score
FROM reviews r
JOIN orders o
    ON r.order_id = o.order_id
GROUP BY
    o.order_status
ORDER BY
    average_review_score DESC;
    
-- 19. Average Review Score by Payment Type
SELECT
    p.payment_type,
    COUNT(DISTINCT r.order_id) AS reviewed_orders,
    AVG(r.review_score) AS average_review_score
FROM reviews r
JOIN payments p
    ON r.order_id = p.order_id
GROUP BY
    p.payment_type
ORDER BY
    average_review_score DESC;
    
-- ============================================================
-- SECTION 8: DELIVERY & LOGISTICS ANALYSIS
-- ============================================================

-- 20. Average Delivery Time
SELECT
    AVG(
        DATEDIFF(
            order_delivered_customer_date,
            order_purchase_timestamp
        )
    ) AS average_delivery_days
FROM orders
WHERE
    order_delivered_customer_date IS NOT NULL;
    
-- 21. Delivery Performance
SELECT
    CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date
            THEN 'On Time'
        WHEN order_delivered_customer_date > order_estimated_delivery_date
            THEN 'Late'
    END AS delivery_status,
    COUNT(*) AS order_count
FROM orders
WHERE
    order_delivered_customer_date IS NOT NULL
GROUP BY
    delivery_status;    
    
-- 22. Average Delivery Delay for Late Orders
SELECT
    AVG(
        DATEDIFF(
            order_delivered_customer_date,
            order_estimated_delivery_date
        )
    ) AS average_delay_days
FROM orders
WHERE
    order_delivered_customer_date > order_estimated_delivery_date;  
    
-- 23. Delivery Performance by Customer State
SELECT
    c.customer_state,
    COUNT(*) AS delivered_orders,
    SUM(
        CASE
            WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
                THEN 1
            ELSE 0
        END
    ) AS on_time_orders,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
                    THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS on_time_percentage
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE
    o.order_delivered_customer_date IS NOT NULL
GROUP BY
    c.customer_state
ORDER BY
    on_time_percentage DESC;    
    
-- 24. Average Delivery Time by Customer State
SELECT
    c.customer_state,
    COUNT(*) AS delivered_orders,
    ROUND(
        AVG(
            DATEDIFF(
                o.order_delivered_customer_date,
                o.order_purchase_timestamp
            )
        ),
        2
    ) AS average_delivery_days
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE
    o.order_delivered_customer_date IS NOT NULL
GROUP BY
    c.customer_state
ORDER BY
    average_delivery_days;
    
-- 25. Average Freight Value by Customer State
SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(AVG(oi.freight_value), 2) AS average_freight_value
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_state
ORDER BY
    average_freight_value DESC;    
    
-- 26. Sales and Freight by Customer State
SELECT
    c.customer_state,
    ROUND(SUM(oi.price), 2) AS total_sales,
    ROUND(SUM(oi.freight_value), 2) AS total_freight,
    ROUND(
        100.0 * SUM(oi.freight_value) / SUM(oi.price),
        2
    ) AS freight_to_sales_percentage
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_state
ORDER BY
    freight_to_sales_percentage DESC;
    
-- ============================================================
-- SECTION 9: TIME & SALES TREND ANALYSIS
-- ============================================================

-- 27. Monthly Order Volume
SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
ORDER BY
    order_month;   
    
-- 28. Average Order Value by Month
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month,
    ROUND(
        SUM(oi.price) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY
    order_month;    

-- ============================================================
-- SECTION 10: CUSTOMER BEHAVIOR & RETENTION
-- ============================================================
    
-- 29. Repeat vs One-Time Customers
SELECT
    CASE
        WHEN order_count = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_unique_id
) AS customer_orders
GROUP BY
    customer_type
ORDER BY
    customer_count DESC;  
    
-- 30. Customer Order Frequency
SELECT
    order_count,
    COUNT(*) AS customer_count
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_unique_id
) AS customer_orders
GROUP BY
    order_count
ORDER BY
    order_count;    

-- ============================================================
-- SECTION 11: CUSTOMER VALUE ANALYSIS
-- ============================================================
    
-- 31. Sales by Customer Type
SELECT
    CASE
        WHEN customer_order_count = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    ROUND(SUM(oi.price), 2) AS total_sales,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM (
    SELECT
        c.customer_id,
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS customer_order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_id,
        c.customer_unique_id
) AS customer_orders
JOIN orders o
    ON customer_orders.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    customer_type
ORDER BY
    total_sales DESC;    
    
-- 31. Sales by Customer Type
SELECT
    CASE
        WHEN customer_order_count = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    ROUND(SUM(oi.price), 2) AS total_sales,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM (
    SELECT
        c.customer_id,
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS customer_order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_id,
        c.customer_unique_id
) AS customer_orders
JOIN orders o
    ON customer_orders.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    customer_type
ORDER BY
    total_sales DESC;    
    
-- 31A. Verify Repeat Customer Order Counts
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS order_count
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_unique_id
HAVING
    COUNT(DISTINCT o.order_id) > 1
ORDER BY
    order_count DESC
LIMIT 10;    

-- 31. Sales by Customer Type
WITH customer_order_counts AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_unique_id
)
SELECT
    CASE
        WHEN coc.order_count = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    ROUND(SUM(oi.price), 2) AS total_sales,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN customer_order_counts coc
    ON c.customer_unique_id = coc.customer_unique_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    customer_type
ORDER BY
    total_sales DESC;
    
-- 32. Average Sales per Order by Customer Type
WITH customer_order_counts AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_unique_id
)
SELECT
    CASE
        WHEN coc.order_count = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    ROUND(
        SUM(oi.price) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_sales_per_order
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN customer_order_counts coc
    ON c.customer_unique_id = coc.customer_unique_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    customer_type;    
    
-- 33. Repeat Customer Sales by State
WITH customer_order_counts AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_unique_id
)
SELECT
    c.customer_state,
    ROUND(SUM(oi.price), 2) AS repeat_customer_sales,
    COUNT(DISTINCT o.order_id) AS repeat_customer_orders
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN customer_order_counts coc
    ON c.customer_unique_id = coc.customer_unique_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE
    coc.order_count > 1
GROUP BY
    c.customer_state
ORDER BY
    repeat_customer_sales DESC;    
    
-- 34. Repeat Customer Rate by State
WITH customer_order_counts AS (
    SELECT
        c.customer_unique_id,
        c.customer_state,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_unique_id,
        c.customer_state
)
SELECT
    customer_state,
    COUNT(*) AS total_customers,
    SUM(
        CASE
            WHEN order_count > 1 THEN 1
            ELSE 0
        END
    ) AS repeat_customers,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN order_count > 1 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS repeat_customer_rate
FROM customer_order_counts
GROUP BY
    customer_state
ORDER BY
    repeat_customer_rate DESC;    

-- ============================================================
-- SECTION 12: BUSINESS RELATIONSHIPS
-- ============================================================
    
-- 35. Review Score vs Delivery Performance
SELECT
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
            THEN 'On Time'
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
            THEN 'Late'
    END AS delivery_status,
    COUNT(DISTINCT r.order_id) AS reviewed_orders,
    ROUND(AVG(r.review_score), 2) AS average_review_score
FROM orders o
JOIN reviews r
    ON o.order_id = r.order_id
WHERE
    o.order_delivered_customer_date IS NOT NULL
GROUP BY
    delivery_status
ORDER BY
    average_review_score DESC;    

-- 36. Review Score by Delivery Delay
SELECT
    CASE
        WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date
            THEN 'On Time'
        WHEN DATEDIFF(
                o.order_delivered_customer_date,
                o.order_estimated_delivery_date
             ) BETWEEN 1 AND 3
            THEN '1-3 Days Late'
        WHEN DATEDIFF(
                o.order_delivered_customer_date,
                o.order_estimated_delivery_date
             ) BETWEEN 4 AND 7
            THEN '4-7 Days Late'
        WHEN DATEDIFF(
                o.order_delivered_customer_date,
                o.order_estimated_delivery_date
             ) BETWEEN 8 AND 14
            THEN '8-14 Days Late'
        ELSE '15+ Days Late'
    END AS delivery_delay_group,
    COUNT(DISTINCT r.order_id) AS reviewed_orders,
    ROUND(AVG(r.review_score), 2) AS average_review_score
FROM orders o
JOIN reviews r
    ON o.order_id = r.order_id
WHERE
    o.order_delivered_customer_date IS NOT NULL
GROUP BY
    delivery_delay_group
ORDER BY
    CASE delivery_delay_group
        WHEN 'On Time' THEN 1
        WHEN '1-3 Days Late' THEN 2
        WHEN '4-7 Days Late' THEN 3
        WHEN '8-14 Days Late' THEN 4
        WHEN '15+ Days Late' THEN 5
    END;

-- ============================================================
-- SECTION 13: RISK & OPERATIONAL ANALYSIS
-- ============================================================
    
-- 37. Cancellation Rate by Customer State
SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(
        DISTINCT CASE
            WHEN o.order_status = 'canceled'
            THEN o.order_id
        END
    ) AS canceled_orders,
    ROUND(
        100.0 *
        COUNT(
            DISTINCT CASE
                WHEN o.order_status = 'canceled'
                THEN o.order_id
            END
        ) / COUNT(DISTINCT o.order_id),
        2
    ) AS cancellation_rate
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY
    c.customer_state
ORDER BY
    cancellation_rate DESC;   
    
-- 38. Sales by Order Status
SELECT
    o.order_status,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_sales
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    o.order_status
ORDER BY
    total_sales DESC;    
    
-- 39. Sales by Payment Type
SELECT
    p.payment_type,
    COUNT(DISTINCT p.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_payment_value,
    ROUND(AVG(p.payment_value), 2) AS average_payment_value
FROM payments p
GROUP BY
    p.payment_type
ORDER BY
    total_payment_value DESC;    
    
-- 40. Payment Installment Distribution
SELECT
    payment_installments,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM payments
WHERE
    payment_type = 'credit_card'
GROUP BY
    payment_installments
ORDER BY
    payment_installments;    
    
-- 41. Seller Sales vs Item Volume
SELECT
    oi.seller_id,
    s.seller_city,
    s.seller_state,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS total_sales,
    ROUND(AVG(oi.price), 2) AS average_item_price
FROM order_items oi
JOIN sellers s
    ON oi.seller_id = s.seller_id
GROUP BY
    oi.seller_id,
    s.seller_city,
    s.seller_state
ORDER BY
    total_sales DESC
LIMIT 10;    

-- 42. Seller Sales and Freight Performance
SELECT
    oi.seller_id,
    s.seller_city,
    s.seller_state,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS total_sales,
    ROUND(SUM(oi.freight_value), 2) AS total_freight,
    ROUND(
        100.0 * SUM(oi.freight_value) / SUM(oi.price),
        2
    ) AS freight_to_sales_percentage
FROM order_items oi
JOIN sellers s
    ON oi.seller_id = s.seller_id
GROUP BY
    oi.seller_id,
    s.seller_city,
    s.seller_state
ORDER BY
    freight_to_sales_percentage DESC
LIMIT 10;

-- ============================================================
-- SECTION 14: GROWTH ANALYSIS
-- ============================================================

-- 43. Monthly Sales Growth
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS sales_month,
        SUM(oi.price) AS total_sales
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
)
SELECT
    sales_month,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(
        100.0 * (
            total_sales - LAG(total_sales) OVER (ORDER BY sales_month)
        ) /
        LAG(total_sales) OVER (ORDER BY sales_month),
        2
    ) AS month_over_month_growth
FROM monthly_sales
ORDER BY
    sales_month;
    
-- ============================================================
-- SECTION 15: CUSTOMER LIFETIME VALUE
-- ============================================================
    
-- 44. Customer Lifetime Order Value
SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_customer_sales,
    ROUND(
        SUM(oi.price) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_sales_per_order
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY
    c.customer_unique_id
ORDER BY
    total_customer_sales DESC
LIMIT 10;    

-- ============================================================
-- SECTION 16: CATEGORY SALES & CUSTOMER REVIEWS
-- ============================================================

-- 45. Product Category Sales and Customer Reviews
WITH order_reviews AS (
    SELECT
        order_id,
        AVG(review_score) AS average_review_score
    FROM reviews
    GROUP BY order_id
)
SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name,
        'Unknown'
    ) AS product_category,
    ROUND(SUM(oi.price), 2) AS total_sales,
    COUNT(*) AS items_sold,
    COUNT(DISTINCT r.order_id) AS reviewed_orders,
    ROUND(AVG(r.average_review_score), 2) AS average_review_score
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
LEFT JOIN order_reviews r
    ON oi.order_id = r.order_id
GROUP BY
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name,
        'Unknown'
    )
ORDER BY
    total_sales DESC;