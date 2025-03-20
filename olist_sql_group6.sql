-- KPI -1: Weekday vs Weekend Payment Statistics

SELECT 
    CASE
        WHEN DAYOFWEEK(STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d')) IN (1 , 7) THEN 'WeekEnd'
        ELSE 'Weekday'
    END AS Day_type,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_payments,
    ROUND(AVG(p.payment_value), 2) AS Avg_Payments
FROM
    olist_orders o
        JOIN
    order_payments p ON o.order_id = p.order_id
GROUP BY Day_type;

-- KPI -2: Count of Orders with Review Score 5 and Payment Type as Credit Card

SELECT 
    review_score,
    payment_type,
    COUNT(DISTINCT p.order_id) AS No_of_orders
FROM
    order_payments p
        JOIN
    order_reviews r ON r.order_id = p.order_id
WHERE
    r.review_score = 5
        AND p.payment_type = 'credit_card';
        
-- KPI -3: Average Delivery Time for Pet Shop Products

SELECT 
    product_category_name,
    ROUND(AVG(DATEDIFF(order_delivered_customer_date,
                    order_purchase_timestamp))) AS Avg_delivery_time
FROM
    olist_orders o
        JOIN
    order_items i ON i.order_id = o.order_id
        JOIN
    olist_products p ON p.product_id = i.product_id
WHERE
    p.product_category_name = 'pet_shop'
        AND o.order_delivered_customer_date IS NOT NULL;
        
-- KPI -4:Average Order Price and Payment Amount for Customers in São Paulo

SELECT 
    customer_city,
    ROUND(AVG(i.price)) AS Avg_price,
    ROUND(AVG(p.payment_value)) AS Avg_payment
FROM
    olist_customers c
        JOIN
    olist_orders o ON c.customer_id = o.customer_id
        JOIN
    order_items i ON o.order_id = i.order_id
        JOIN
    order_payments p ON o.order_id = p.order_id
WHERE
    c.customer_city = 'Sao Paulo';

-- KPI -5: Relationship Between Shipping Days and Review Scores
SELECT 
    r.review_score,
    ROUND(AVG(DATEDIFF(order_delivered_customer_date,
                    order_purchase_timestamp)),
            0) AS Avg_shipping_days
FROM
    olist_orders o
        JOIN
    order_reviews r ON o.order_id = r.order_id
WHERE
    order_delivered_customer_date IS NOT NULL
GROUP BY review_score
ORDER BY review_score;