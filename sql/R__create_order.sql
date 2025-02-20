CREATE OR REPLACE FUNCTION magic_beans_schema.create_order(
    p_user_id INT,
    p_payment_method VARCHAR(100),
    p_order_items JSONB 
) RETURNS INT AS $$
DECLARE
    v_order_id INT;
    v_payment_id INT;
    v_payment_method_id INT;
    v_item JSONB;
    v_bean_id INT;
    v_bean_name TEXT;
    v_quantity INT;
    v_inventory_quantity INT;
    v_bean_price DECIMAL(10,2);
    v_total_price DECIMAL(10,2) := 0;
    v_order_status_id INT;
BEGIN
    -- Find the order_status_id for 'Order Placed'
    SELECT id INTO v_order_status_id
    FROM magic_beans_schema.order_status
    WHERE status = 'Order Placed';

    IF v_order_status_id IS NULL THEN
        RAISE EXCEPTION 'Order status "Order Placed" not found';
    END IF;

    -- Find the payment method ID
    SELECT id INTO v_payment_method_id
    FROM magic_beans_schema.payment_method
    WHERE method = p_payment_method;

    IF v_payment_method_id IS NULL THEN
        RAISE EXCEPTION 'Payment method "%" not found', p_payment_method;
    END IF;

    -- First pass: Validate inventory and calculate total price
    FOR v_item IN SELECT * FROM jsonb_array_elements(p_order_items)
    LOOP
        v_bean_name := v_item->>'bean_name';
        v_quantity := (v_item->>'quantity')::INT;

        -- Find the bean ID from its name
        SELECT id INTO v_bean_id
        FROM magic_beans_schema.bean
        WHERE name = v_bean_name;

        IF v_bean_id IS NULL THEN
            RAISE EXCEPTION 'Bean "%" not found', v_bean_name;
        END IF;

        -- Lock inventory for update
        SELECT quantity INTO v_inventory_quantity
        FROM magic_beans_schema.inventory
        WHERE bean_id = v_bean_id
        FOR UPDATE;

        IF v_inventory_quantity IS NULL THEN
            RAISE EXCEPTION 'Bean "%" not found in inventory', v_bean_name;
        ELSIF v_inventory_quantity < v_quantity THEN
            RAISE EXCEPTION 'Insufficient stock for bean "%": available %, requested %',
                v_bean_name, v_inventory_quantity, v_quantity;
        END IF;

        -- Get the bean's price
        SELECT price INTO v_bean_price
        FROM magic_beans_schema.bean
        WHERE id = v_bean_id;

        IF v_bean_price IS NULL THEN
            RAISE EXCEPTION 'Bean "%" price not found', v_bean_name;
        END IF;

        -- Calculate total price
        v_total_price := v_total_price + (v_bean_price * v_quantity);
    END LOOP;

    -- Insert into the payment table
    INSERT INTO magic_beans_schema.payment (
        payment_method_id, payment_date, amount
    ) VALUES (
        v_payment_method_id, CURRENT_TIMESTAMP, v_total_price
    ) RETURNING id INTO v_payment_id;

    -- Insert into the order table
    INSERT INTO magic_beans_schema."order" (
        user_id, order_date, payment_id, order_status_id
    ) VALUES (
        p_user_id, CURRENT_TIMESTAMP, v_payment_id, v_order_status_id
    ) RETURNING id INTO v_order_id;

    -- Second pass: Insert order items and deduct inventory
    FOR v_item IN SELECT * FROM jsonb_array_elements(p_order_items)
    LOOP
        v_bean_name := v_item->>'bean_name';
        v_quantity := (v_item->>'quantity')::INT;

        -- Find the bean ID
        SELECT id INTO v_bean_id
        FROM magic_beans_schema.bean
        WHERE name = v_bean_name;

        -- Insert into order_item
        INSERT INTO magic_beans_schema.order_item (
            order_id, bean_id, quantity
        ) VALUES (
            v_order_id, v_bean_id, v_quantity
        );

        -- Deduct from inventory
        UPDATE magic_beans_schema.inventory
        SET quantity = quantity - v_quantity
        WHERE bean_id = v_bean_id;
    END LOOP;

    -- Insert into order_history
    INSERT INTO magic_beans_schema.order_history (
        order_id, date, order_status_id
    ) VALUES (
        v_order_id, CURRENT_TIMESTAMP, v_order_status_id
    );

    -- Return the order ID
    RETURN v_order_id;
END;
$$ LANGUAGE plpgsql;

