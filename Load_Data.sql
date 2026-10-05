CREATE DATABASE olist_analytics;
USE olist_analytics;

TRUNCATE TABLE orders;

SELECT COUNT(*) AS row_count
FROM orders;
LOAD DATA LOCAL INFILE 'C:/Users/SIDDH/Downloads/Ecommerce_Analytics/cleaned_dataset/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    customer_id,
    order_status,
    @purchase,
    @approved,
    @carrier,
    @customer,
    @estimated
)
SET
    order_purchase_timestamp = STR_TO_DATE(NULLIF(@purchase, ''), '%d-%m-%Y %H:%i:%s'),
    order_approved_at = STR_TO_DATE(NULLIF(@approved, ''), '%d-%m-%Y %H:%i:%s'),
    order_delivered_carrier_date = STR_TO_DATE(NULLIF(@carrier, ''), '%d-%m-%Y %H:%i:%s'),
    order_delivered_customer_date = STR_TO_DATE(NULLIF(@customer, ''), '%d-%m-%Y %H:%i:%s'),
    order_estimated_delivery_date = STR_TO_DATE(NULLIF(@estimated, ''), '%d-%m-%Y %H:%i:%s');
TRUNCATE TABLE orders;
SELECT COUNT(*) AS row_count
FROM orders;
LOAD DATA LOCAL INFILE 'C:/Users/SIDDH/Downloads/Ecommerce_Analytics/cleaned_dataset/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    customer_id,
    order_status,
    @purchase,
    @approved,
    @carrier,
    @customer,
    @estimated
)
SET
    order_purchase_timestamp = NULLIF(@purchase, ''),
    order_approved_at = NULLIF(@approved, ''),
    order_delivered_carrier_date = NULLIF(@carrier, ''),
    order_delivered_customer_date = NULLIF(@customer, ''),
    order_estimated_delivery_date = NULLIF(@estimated, '');
SELECT
    order_id,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM orders
LIMIT 5;    
DESCRIBE orders;
CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);
SHOW TABLES;
TRUNCATE TABLE order_items;

LOAD DATA LOCAL INFILE 'C:/Users/SIDDH/Downloads/Ecommerce_Analytics/cleaned_dataset/olist_order_items_dataset.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    order_item_id,
    product_id,
    seller_id,
    @shipping,
    price,
    freight_value
)
SET
    shipping_limit_date = NULLIF(@shipping, '');
SELECT COUNT(*) AS row_count
FROM order_items;
SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
FROM order_items
LIMIT 5;
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);   
LOAD DATA LOCAL INFILE 'C:/Users/SIDDH/Downloads/Ecommerce_Analytics/cleaned_dataset/olist_customers_dataset.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; 
SELECT COUNT(*) AS row_count
FROM customers;
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);
show tables;
LOAD DATA LOCAL INFILE 'C:/Users/SIDDH/Downloads/Ecommerce_Analytics/cleaned_dataset/olist_products_dataset.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) AS row_count
FROM products;
CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);
LOAD DATA LOCAL INFILE 'C:/Users/SIDDH/Downloads/Ecommerce_Analytics/cleaned_dataset/olist_sellers_dataset.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) AS row_count
FROM sellers;
SELECT COUNT(*) AS total_rows,
       COUNT(seller_id) AS seller_ids
FROM sellers;
CREATE TABLE payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value DECIMAL(10,2)
);
show tables;
LOAD DATA LOCAL INFILE 'C:/Users/SIDDH/Downloads/Ecommerce_Analytics/cleaned_dataset/olist_order_payments_dataset.csv'
INTO TABLE payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) AS row_count
FROM payments;
CREATE TABLE reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);
LOAD DATA LOCAL INFILE 'C:/Users/SIDDH/Downloads/Ecommerce_Analytics/cleaned_dataset/olist_order_reviews_dataset.csv'
INTO TABLE reviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) AS row_count
FROM reviews;
SELECT COUNT(*) AS total_rows,
       COUNT(review_id) AS review_ids,
       COUNT(order_id) AS order_ids
FROM reviews;
CREATE TABLE category_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);
LOAD DATA LOCAL INFILE 'C:/Users/SIDDH/Downloads/Ecommerce_Analytics/cleaned_dataset/product_category_name_translation.csv'
INTO TABLE category_translation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) AS row_count
FROM category_translation;
CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat DECIMAL(10,7),
    geolocation_lng DECIMAL(10,7),
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(10)
);
LOAD DATA LOCAL INFILE 'C:/Users/SIDDH/Downloads/Ecommerce_Analytics/cleaned_dataset/olist_geolocation_dataset.csv'
INTO TABLE geolocation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) AS row_count
FROM geolocation;
SELECT
    COUNT(*) AS total_orders,
    COUNT(c.customer_id) AS matched_customers
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id;
SELECT
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT oi.order_id) AS orders_with_items
FROM orders o
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id;    
SELECT
    order_status,
    COUNT(*) AS order_count
FROM orders o
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL
GROUP BY order_status
ORDER BY order_count DESC;   
SELECT
    COUNT(*) AS total_items,
    COUNT(p.product_id) AS matched_products
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id;
SELECT
    COUNT(*) AS unmatched_items
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;
SELECT
    COUNT(*) AS unmatched_items
FROM order_items oi
LEFT JOIN sellers s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;
SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT p.order_id) AS orders_with_payments
FROM orders o
LEFT JOIN payments p
    ON o.order_id = p.order_id;    
SELECT
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp
FROM orders o
LEFT JOIN payments p
    ON o.order_id = p.order_id
WHERE p.order_id IS NULL;    
 SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT r.order_id) AS orders_with_reviews
FROM orders o
LEFT JOIN reviews r
    ON o.order_id = r.order_id;
SELECT
    o.order_status,
    COUNT(*) AS orders_without_reviews
FROM orders o
LEFT JOIN reviews r
    ON o.order_id = r.order_id
WHERE r.order_id IS NULL
GROUP BY o.order_status
ORDER BY orders_without_reviews DESC;    
SELECT
    COUNT(*) AS products_with_category,
    COUNT(ct.product_category_name) AS translated_categories
FROM products p
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name;
SELECT
    p.product_category_name,
    COUNT(*) AS product_count
FROM products p
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND ct.product_category_name IS NULL
GROUP BY p.product_category_name
ORDER BY product_count DESC;    
SELECT
    COUNT(DISTINCT oi.product_id) AS products_in_order_items,
    COUNT(DISTINCT p.product_id) AS matched_products
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id;
SELECT
    COUNT(*) AS total_customers,
    COUNT(DISTINCT o.customer_id) AS customers_with_orders
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id;
SELECT
    COUNT(DISTINCT customer_id) AS customer_ids,
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM customers;    
SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT customer_unique_id
    FROM customers
    GROUP BY customer_unique_id
    HAVING COUNT(*) > 1
) AS repeat_customer_list;
SELECT
    COUNT(*) AS total_sellers,
    COUNT(DISTINCT oi.seller_id) AS sellers_with_orders
FROM sellers s
LEFT JOIN order_items oi
    ON s.seller_id = oi.seller_id;
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