--Customer Purchase History Query

USE fleximart_db;
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * oi.unit_price) AS total_spent
FROM
    customers c
JOIN
    orders o ON c.customer_id = o.customer_id
JOIN
    order_items oi ON o.order_id = oi.order_id
GROUP BY
    c.customer_id, c.first_name, c.last_name, c.email
HAVING
    COUNT(DISTINCT o.order_id) >= 2
    AND SUM(oi.quantity * oi.unit_price) > 5000
ORDER BY
    total_spent DESC;

--Product Sales Analysis

USE fleximart_db;
SELECT
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM    
    products p      
JOIN
    order_items oi ON p.product_id = oi.product_id
GROUP BY
    p.product_id, p.product_name
HAVING
    SUM(oi.quantity) > 1000
ORDER BY
    total_revenue DESC;

--Monthly Sales Summary

USE fleximart_db;
SELECT
    MONTHNAME(o.order_date) AS month_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * oi.unit_price) AS monthly_revenue,
    SUM(SUM(oi.quantity * oi.unit_price)) OVER (
        ORDER BY MONTH(o.order_date)
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_revenue
FROM
    orders o
JOIN
    order_items oi ON o.order_id = oi.order_id
WHERE
    YEAR(o.order_date) = 2024
GROUP BY
    MONTH(o.order_date), MONTHNAME(o.order_date)
ORDER BY
    MONTH(o.order_date);

