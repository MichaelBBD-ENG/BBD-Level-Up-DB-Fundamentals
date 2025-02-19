BEGIN;

SET search_path TO magic_beans_schema;

-- View for Top 5 Selling Beans
CREATE VIEW "top_5_selling_beans" AS
SELECT 
    b.id AS bean_id, 
    b.name AS bean_name, 
    SUM(oi.quantity) AS total_sold
FROM "order_item" oi
JOIN "bean" b ON oi.bean_id = b.id
GROUP BY b.id, b.name
ORDER BY total_sold DESC
LIMIT 5;

-- View for Supplier Orders
CREATE VIEW "supplier_orders" AS
SELECT 
    o.id AS order_id, 
    s.name AS supplier, 
    o.order_date, 
    o.total_price, 
    pm.method AS payment_method, 
    os.status AS order_status
FROM "orders" o
JOIN "supplier" s ON o.supplier_id = s.id
JOIN "payment_method" pm ON o.payment_method_id = pm.id
JOIN "order_status" os ON o.order_status_id = os.id
JOIN "order_type" ot ON o.order_type_id = ot.id
WHERE ot.type = 'Supplier';

-- View for Monthly Sales
CREATE VIEW "monthly_sales" AS
SELECT 
    DATE_TRUNC('month', o.order_date) AS sales_month, 
    COUNT(o.id) AS total_orders, 
    SUM(o.total_price) AS total_sales
FROM "orders" o
GROUP BY sales_month
ORDER BY sales_month DESC;

-- View for Customer Orders
CREATE VIEW "customer_orders" AS
SELECT 
    o.id AS order_id, 
    u.username AS customer, 
    o.order_date, 
    o.total_price, 
    pm.method AS payment_method, 
    os.status AS order_status
FROM "orders" o
JOIN "users" u ON o.user_id = u.id
JOIN "payment_method" pm ON o.payment_method_id = pm.id
JOIN "order_status" os ON o.order_status_id = os.id
JOIN "order_type" ot ON o.order_type_id = ot.id
WHERE ot.type = 'Customer';

-- View for Delivery History
CREATE VIEW "delivery_history" AS
SELECT 
    d.id AS delivery_id,
    o.id AS order_id,
    u.username AS customer,
    driver.username AS driver,
    d.delivery_notes,
    oh.date AS order_status_date,
    os.status AS order_status
FROM "delivery" d
JOIN "orders" o ON d.order_id = o.id
JOIN "users" u ON o.user_id = u.id
JOIN "users" driver ON d.driver_id = driver.id
JOIN "order_history" oh ON oh.order_id = o.id
JOIN "order_status" os ON oh.order_status_id = os.id
ORDER BY oh.date DESC;

CREATE VIEW "order_details" AS
SELECT 
    o.id AS order_id,
    o.user_id,
    u.first_name || ' ' || u.last_name AS user_name,
    o.order_date,
    o.total_price,
    pm.method AS payment_method,
    os.status AS order_status,
    ot.type AS order_type,
    s.name AS supplier_name,
    ARRAY_AGG(oi.bean_id) AS bean_ids,
    ARRAY_AGG(oi.quantity) AS quantities,
    ARRAY_AGG(oi.price) AS prices,
    ARRAY_AGG(b.name) AS bean_names,
    ARRAY_AGG(b.price) AS bean_prices,
    d.driver_id AS delivery_driver_id,
    d.delivery_notes,
    p.payment_date,
    p.amount AS payment_amount,
    ps.status AS payment_status
FROM "orders" o
JOIN "users" u ON o.user_id = u.id
JOIN "payment_method" pm ON o.payment_method_id = pm.id
JOIN "order_status" os ON o.order_status_id = os.id
JOIN "order_type" ot ON o.order_type_id = ot.id
JOIN "supplier" s ON o.supplier_id = s.id
JOIN "order_item" oi ON o.id = oi.order_id
JOIN "bean" b ON oi.bean_id = b.id
JOIN "payment" p ON o.id = p.order_id
JOIN "payment_status" ps ON p.status_id = ps.id
LEFT JOIN "delivery" d ON o.id = d.order_id
GROUP BY 
    o.id, o.user_id, u.first_name, u.last_name, o.order_date, o.total_price,
    pm.method, os.status, ot.type, s.name, d.driver_id, d.delivery_notes,
    p.payment_date, p.amount, ps.status;


CREATE VIEW "bean_stock_status" AS
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
        WHEN COALESCE(i.quantity, 0) > 0 THEN 'In Stock'
    END AS stock_status
FROM "bean" b
LEFT JOIN "magical_property" mp ON b.magical_property = mp.id
LEFT JOIN "inventory" i ON b.id = i.bean_id;


COMMIT;
