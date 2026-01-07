--Query 1: Monthly Sales Drill-Down Analysis 

USE fleximart_dw;
SELECT
    ds.month_name,
    ds.year,
    ds.quarter,
    p.product_name,
    SUM(fs.quantity_sold) AS total_quantity_sold,
    SUM(fs.total_amount) AS total_sales_amount
FROM    
    dim_date ds 
JOIN
    fact_sales fs ON ds.date_key = fs.date_key
JOIN
    dim_product p ON fs.product_key = p.product_key
WHERE
    ds.year = 2024
GROUP BY
     ds.quarter, ds.year, p.product_name, ds.month_name
ORDER BY
    ds.year, ds.quarter, ds.month_name, total_sales_amount DESC;

--Query 2: Product Performance Analysis


USE fleximart_dw;
SELECT
    p.product_name,
    p.category,
    SUM(f.quantity_sold) AS total_units_sold,
    SUM(f.total_amount) AS total_revenue,
    ROUND(
        (SUM(f.total_amount) / 
         (SELECT SUM(total_amount) FROM fact_sales)) * 100,
        2
    ) AS revenue_contribution_percentage
FROM fact_sales f
JOIN dim_product p
    ON f.product_key = p.product_key
GROUP BY
    p.product_key,
    p.product_name,
    p.category
ORDER BY
    total_revenue DESC
LIMIT 10;

--Query 3: Customer Segmentation Analysis

USE fleximart_dw;
WITH customer_spending AS (
    SELECT
        c.customer_key,
        SUM(f.total_amount) AS total_spent
    FROM fact_sales f
    JOIN dim_customer c
        ON f.customer_key = c.customer_key
    GROUP BY
        c.customer_key
),
customer_segments AS (
    SELECT
        customer_key,
        total_spent,
        CASE
            WHEN total_spent > 50000 THEN 'High Value'
            WHEN total_spent BETWEEN 20000 AND 50000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS customer_segment
    FROM customer_spending
)
SELECT
    customer_segment,
    COUNT(customer_key) AS customer_count,
    SUM(total_spent) AS total_revenue,
    ROUND(AVG(total_spent), 0) AS avg_revenue_per_customer
FROM customer_segments
GROUP BY
    c.customer_segment
ORDER BY
    total_revenue DESC;
    
