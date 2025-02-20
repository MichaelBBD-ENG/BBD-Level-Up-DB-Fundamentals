CREATE OR REPLACE VIEW magic_beans_schema.top_5_selling_beans AS
SELECT 
    b.id AS bean_id, 
    b.name AS bean_name, 
    SUM(oi.quantity) AS total_sold,
    SUM(oi.quantity * b.price) AS total_revenue
FROM magic_beans_schema.order_item oi
JOIN magic_beans_schema.bean b ON oi.bean_id = b.id
JOIN magic_beans_schema."order" o ON oi.order_id = o.id
JOIN magic_beans_schema.order_status os ON o.order_status_id = os.id
GROUP BY b.id, b.name
ORDER BY total_sold DESC
LIMIT 5;

CREATE OR REPLACE VIEW magic_beans_schema.customer_order_details AS
SELECT 
    o.id AS order_id,
    u.id AS customer_id,
    u.first_name || ' ' || u.last_name AS customer_name,
    o.order_date,
    b.id AS bean_id,
    b.name AS bean_name,
    oi.quantity,
    b.price,
    (oi.quantity * b.price) AS total_price,
    os.status AS order_status
FROM magic_beans_schema."order" o
JOIN magic_beans_schema."user" u ON o.user_id = u.id
JOIN magic_beans_schema.order_item oi ON o.id = oi.order_id
JOIN magic_beans_schema.bean b ON oi.bean_id = b.id
JOIN magic_beans_schema.order_status os ON o.order_status_id = os.id
ORDER BY o.order_date DESC, o.id;

CREATE OR REPLACE VIEW magic_beans_schema.monthly_sales AS
SELECT 
    DATE_TRUNC('month', o.order_date) AS month,
    SUM(oi.quantity * b.price) AS total_sales
FROM magic_beans_schema."order" o
JOIN magic_beans_schema.order_item oi ON o.id = oi.order_id
JOIN magic_beans_schema.bean b ON oi.bean_id = b.id
GROUP BY month
ORDER BY month;

CREATE OR REPLACE VIEW magic_beans_schema.bean_stock_status AS
SELECT 
    b.id AS bean_id,
    b.name AS bean_name,
    b.description AS bean_description,
    b.price AS bean_price,
    mp.name AS magical_property,
    mp.description AS magical_property_description,
    COALESCE(i.quantity, 0) AS current_stock,
    CASE 
        WHEN COALESCE(i.quantity, 0) = 0 THEN 'Out of Stock'
        WHEN COALESCE(i.quantity, 0) < 10 THEN 'Low Stock'
        ELSE 'In Stock'
    END AS stock_status
FROM magic_beans_schema.bean b
LEFT JOIN magic_beans_schema.magical_property mp ON b.magical_property = mp.id
LEFT JOIN magic_beans_schema.inventory i ON b.id = i.bean_id;
