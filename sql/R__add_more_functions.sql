-- Function to predict expected date for stock to runout
CREATE OR REPLACE FUNCTION magic_beans_schema.predict_inventory_runout(bean_id BIGINT)
RETURNS DATE AS $$
DECLARE 
    avg_daily_sales NUMERIC;
    current_stock INTEGER;
    days_remaining INTEGER;
    runout_date DATE;
BEGIN
    -- Calculate the average daily sales of the bean in the past 30 days
    SELECT COALESCE(AVG(quantity), 0) 
    INTO avg_daily_sales 
    FROM "OrderItem" oi
    JOIN "Orders" o ON oi.order_id = o.id
    WHERE oi.bean_id = bean_id AND o.order_date >= CURRENT_DATE - INTERVAL '30 days';

    -- Get current stock
    SELECT quantity INTO current_stock FROM "Inventory" WHERE bean_id = bean_id;

    -- Avoid division by zero
    IF avg_daily_sales = 0 THEN
        RETURN NULL; -- No sales data, can't predict runout
    END IF;

    -- Calculate expected days remaining
    days_remaining := current_stock / avg_daily_sales;
    runout_date := CURRENT_DATE + days_remaining;

    RETURN runout_date;
END;
$$ LANGUAGE plpgsql;


-- Procedure to cancel an order and add inventory back
CREATE OR REPLACE PROCEDURE magic_beans_schema.cancel_order(IN order_id BIGINT)
LANGUAGE plpgsql
AS $$
DECLARE 
    item RECORD;
BEGIN
    -- Loop through order items and restore inventory
    FOR item IN 
        SELECT bean_id, quantity FROM "OrderItem" WHERE order_id = order_id
    LOOP
        UPDATE "Inventory"
        SET quantity = quantity + item.quantity
        WHERE bean_id = item.bean_id;
    END LOOP;

    -- Delete order items
    DELETE FROM "OrderItem" WHERE order_id = order_id;

    -- Delete the order itself
    DELETE FROM "Orders" WHERE id = order_id;
END;
$$;

-- Function to find inactive users (haven't placed an order in 6 months)
CREATE OR REPLACE FUNCTION magic_beans_schema.find_inactive_customers()
RETURNS TABLE(user_id BIGINT, username VARCHAR, last_order DATE) AS $$
BEGIN
    RETURN QUERY
    SELECT u.id, u.username, MAX(o.order_date) AS last_order
    FROM "Users" u
    LEFT JOIN "Orders" o ON u.id = o.user_id
    GROUP BY u.id, u.username
    HAVING MAX(o.order_date) < CURRENT_DATE - INTERVAL '6 months'
       OR MAX(o.order_date) IS NULL;
END;
$$ LANGUAGE plpgsql;

