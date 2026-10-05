SELECT
    order_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;
-- missing values in orders
SELECT
    COUNT(*) AS total_orders,
    SUM(order_id IS NULL) AS missing_order_id,
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(order_status IS NULL) AS missing_status,
    SUM(order_purchase_timestamp IS NULL) AS missing_purchase_date,
    SUM(order_approved_at IS NULL) AS missing_approved_date,
    SUM(order_delivered_carrier_date IS NULL) AS missing_carrier_date,
    SUM(order_delivered_customer_date IS NULL) AS missing_delivery_date,
    SUM(order_estimated_delivery_date IS NULL) AS missing_estimated_date
FROM orders;
-- duplicate order_id
SELECT
    order_id,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;
-- duplicate customer_id
SELECT
    customer_id,
    COUNT(*) AS customer_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;
-- duplicate product_id
SELECT
    product_id,
    COUNT(*) AS product_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;
-- duplicate seller_id
SELECT
    seller_id,
    COUNT(*) AS seller_count
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;
-- order_id+order_item_id
SELECT
    order_id,
    order_item_id,
    COUNT(*) AS item_count
FROM order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;
-- payment type
SELECT
    payment_type,
    COUNT(*) AS payment_count
FROM payments
GROUP BY payment_type
ORDER BY payment_count DESC;

SELECT
    MIN(payment_value) AS minimum_payment,
    MAX(payment_value) AS maximum_payment
FROM payments;

SELECT
    MIN(payment_installments) AS minimum_installments,
    MAX(payment_installments) AS maximum_installments
FROM payments;

SELECT
    MIN(review_score) AS minimum_score,
    MAX(review_score) AS maximum_score
FROM reviews;

SELECT
    COUNT(*) AS total_reviews,
    SUM(review_comment_title IS NULL) AS missing_titles,
    SUM(review_comment_message IS NULL) AS missing_messages
FROM reviews;

SELECT
    COUNT(*) AS total_reviews,
    SUM(review_comment_title IS NULL OR review_comment_title = '') AS missing_titles,
    SUM(review_comment_message IS NULL OR review_comment_message = '') AS missing_messages
FROM reviews;

-- duplicate review_id
SELECT
    review_id,
    COUNT(*) AS review_count
FROM reviews
GROUP BY review_id
HAVING COUNT(*) > 1;

SELECT
    COUNT(*) AS duplicate_review_ids,
    SUM(review_count - 1) AS extra_review_rows
FROM (
    SELECT
        review_id,
        COUNT(*) AS review_count
    FROM reviews
    GROUP BY review_id
    HAVING COUNT(*) > 1
) AS duplicates;

SELECT
    review_id,
    COUNT(DISTINCT order_id) AS order_count
FROM reviews
GROUP BY review_id
HAVING COUNT(DISTINCT order_id) > 1;

SELECT
    COUNT(*) AS review_ids_multiple_orders
FROM (
    SELECT
        review_id
    FROM reviews
    GROUP BY review_id
    HAVING COUNT(DISTINCT order_id) > 1
) AS x;

SELECT
    order_id,
    COUNT(*) AS review_count
FROM reviews
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT
    COUNT(*) AS orders_with_multiple_reviews
FROM (
    SELECT
        order_id
    FROM reviews
    GROUP BY order_id
    HAVING COUNT(*) > 1
) AS x;

SELECT
    COUNT(*) AS total_reviews,
    SUM(order_id IS NULL OR order_id = '') AS missing_order_ids
FROM reviews;

-- products
SELECT
    COUNT(*) AS total_products,
    SUM(product_category_name IS NULL OR product_category_name = '') AS missing_category,
    SUM(product_name_lenght IS NULL) AS missing_name_length,
    SUM(product_description_lenght IS NULL) AS missing_description_length,
    SUM(product_photos_qty IS NULL) AS missing_photos,
    SUM(product_weight_g IS NULL) AS missing_weight,
    SUM(product_length_cm IS NULL) AS missing_length,
    SUM(product_height_cm IS NULL) AS missing_height,
    SUM(product_width_cm IS NULL) AS missing_width
FROM products;

SELECT
    MIN(product_weight_g) AS min_weight,
    MIN(product_length_cm) AS min_length,
    MIN(product_height_cm) AS min_height,
    MIN(product_width_cm) AS min_width
FROM products;

SELECT
    SUM(product_weight_g = 0) AS zero_weight,
    SUM(product_length_cm = 0) AS zero_length,
    SUM(product_height_cm = 0) AS zero_height,
    SUM(product_width_cm = 0) AS zero_width
FROM products;

SELECT
    SUM(product_weight_g < 0) AS negative_weight,
    SUM(product_length_cm < 0) AS negative_length,
    SUM(product_height_cm < 0) AS negative_height,
    SUM(product_width_cm < 0) AS negative_width
FROM products;

SELECT
    COALESCE(product_category_name, 'MISSING') AS category,
    COUNT(*) AS product_count
FROM products
GROUP BY product_category_name
ORDER BY product_count DESC;

SELECT
    SUM(product_category_name IS NULL) AS null_categories,
    SUM(product_category_name = '') AS empty_categories
FROM products;

SELECT
    SUM(product_category_name = '') AS empty_category
FROM products;

SELECT
    COUNT(*) AS total_mappings,
    COUNT(product_category_name) AS portuguese_categories,
    COUNT(product_category_name_english) AS english_categories
FROM category_translation;

SELECT
    product_category_name,
    COUNT(*) AS category_count
FROM category_translation
GROUP BY product_category_name
HAVING COUNT(*) > 1;

SELECT
    product_category_name_english,
    COUNT(*) AS category_count
FROM category_translation
GROUP BY product_category_name_english
HAVING COUNT(*) > 1;

SELECT
    COUNT(DISTINCT p.product_category_name) AS product_categories,
    COUNT(DISTINCT ct.product_category_name) AS translated_categories
FROM products p
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
WHERE p.product_category_name <> '';

-- Geolocation
SELECT
    COUNT(*) AS total_rows,
    COUNT(geolocation_zip_code_prefix) AS zip_prefixes,
    COUNT(geolocation_lat) AS latitudes,
    COUNT(geolocation_lng) AS longitudes,
    COUNT(geolocation_city) AS cities,
    COUNT(geolocation_state) AS states
FROM geolocation;

SELECT
    SUM(geolocation_lat = 0) AS zero_latitudes,
    SUM(geolocation_lng = 0) AS zero_longitudes,
    SUM(geolocation_lat < -90 OR geolocation_lat > 90) AS invalid_latitudes,
    SUM(geolocation_lng < -180 OR geolocation_lng > 180) AS invalid_longitudes
FROM geolocation;

SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS order_count
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY order_count DESC;

SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT
        c.customer_unique_id
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
    HAVING COUNT(DISTINCT o.order_id) > 1
) AS repeat_customer_list;

SELECT
    COUNT(DISTINCT oi.seller_id) AS sellers_in_orders,
    COUNT(DISTINCT s.seller_id) AS matched_sellers
FROM order_items oi
LEFT JOIN sellers s
    ON oi.seller_id = s.seller_id;
    
SELECT
    COUNT(DISTINCT p.order_id) AS payment_orders,
    COUNT(DISTINCT o.order_id) AS matched_orders
FROM payments p
LEFT JOIN orders o
    ON p.order_id = o.order_id;
    
SELECT
    COUNT(DISTINCT p.order_id) AS payment_orders,
    COUNT(DISTINCT o.order_id) AS matched_orders
FROM payments p
LEFT JOIN orders o
    ON p.order_id = o.order_id;
    
SELECT
    COUNT(DISTINCT r.order_id) AS review_orders,
    COUNT(DISTINCT o.order_id) AS matched_orders
FROM reviews r
LEFT JOIN orders o
    ON r.order_id = o.order_id;
    
SELECT
    COUNT(DISTINCT oi.product_id) AS products_in_orders,
    COUNT(DISTINCT p.product_id) AS matched_products
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id;
    
SELECT
    SUM(price < 0) AS negative_prices,
    SUM(freight_value < 0) AS negative_freight,
    MIN(price) AS minimum_price,
    MAX(price) AS maximum_price,
    MIN(freight_value) AS minimum_freight,
    MAX(freight_value) AS maximum_freight
FROM order_items;    