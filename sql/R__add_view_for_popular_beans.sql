SET search_path TO magic_beans_schema;

-- Drop the existing view if it exists
DROP VIEW IF EXISTS Top_5_Selling_Beans;

-- View for Top 5 Selling Beans
CREATE VIEW Top_5_Selling_Beans AS
SELECT b.id AS bean_id, b.name AS bean_name, SUM(oi.quantity) AS total_sold
FROM order_items oi  -- No need to prefix with schema, since search_path is set
JOIN beans b ON oi.bean_id = b.id
GROUP BY b.id, b.name
ORDER BY total_sold DESC
LIMIT 5;