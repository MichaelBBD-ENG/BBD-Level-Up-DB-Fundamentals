-- Step 1: Get existing order IDs
WITH existing_orders AS (
    SELECT id FROM magic_beans_schema."order"
),
existing_drivers AS (
    -- Step 2: Get existing driver IDs (assuming they have a role of 'Driver')
    SELECT u.id FROM magic_beans_schema."user" u
    JOIN magic_beans_schema."user_roles" ur ON u.id = ur.user_id
    JOIN magic_beans_schema."roles" r ON ur.role_id = r.id
    WHERE r.role = 'driver'
)
-- Step 3: Insert mock delivery data
INSERT INTO magic_beans_schema."delivery" (order_id, driver_id, delivery_notes)
SELECT 
    o.id AS order_id,
    d.id AS driver_id,
    'None.' AS delivery_notes
FROM existing_orders o
CROSS JOIN LATERAL (
    SELECT id FROM existing_drivers ORDER BY RANDOM() LIMIT 1
) d
LIMIT 10;  -- Adjust number of mock records as needed
