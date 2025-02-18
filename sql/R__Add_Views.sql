BEGIN;

SET search_path TO magic_beans_schema;

-- Drop the existing views if they exist
DROP VIEW IF EXISTS "Top_5_Selling_Beans";
DROP VIEW IF EXISTS "Supplier_Orders";
DROP VIEW IF EXISTS "Monthly_Sales";
DROP VIEW IF EXISTS "Customer_Orders";
DROP VIEW IF EXISTS "Delivery_History";

-- View for Top 5 Selling Beans
CREATE VIEW "Top_5_Selling_Beans" AS
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
CREATE VIEW "Supplier_Orders" AS
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
CREATE VIEW "Monthly_Sales" AS
SELECT 
    DATE_TRUNC('month', o.order_date) AS sales_month, 
    COUNT(o.id) AS total_orders, 
    SUM(o.total_price) AS total_sales
FROM "orders" o
GROUP BY sales_month
ORDER BY sales_month DESC;

-- View for Customer Orders
CREATE VIEW "Customer_Orders" AS
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
CREATE VIEW "Delivery_History" AS
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

COMMIT;
