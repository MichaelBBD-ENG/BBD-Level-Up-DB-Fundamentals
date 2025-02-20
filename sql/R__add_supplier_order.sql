CREATE OR REPLACE PROCEDURE magic_beans_schema.insert_supplier_order(
    IN p_admin_id INT,
    IN p_supplier_id INT,
    IN p_status VARCHAR(50),
    IN p_items JSONB,
	IN p_invoice UUID DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_order_id INT;
    v_status_id INT;
    v_item JSONB;
BEGIN
    -- Get the supplier_order_status ID for the given status ('paid' or 'received')
    SELECT id INTO v_status_id
    FROM magic_beans_schema.supplier_orders_status
    WHERE status = p_status;

    -- If status is invalid, raise an error
    IF v_status_id IS NULL THEN
        RAISE EXCEPTION 'Invalid supplier order status. Allowed values: paid, received';
    END IF;

    -- Insert into supplier_orders and get the new order ID
    INSERT INTO magic_beans_schema.supplier_orders (admin_id, order_date, supplier_id, supplier_order_status_id, invoice)
    VALUES (p_admin_id, CURRENT_DATE, p_supplier_id, v_status_id, p_invoice)
    RETURNING id INTO v_order_id;

    -- Insert initial status into supplier_orders_history
    INSERT INTO magic_beans_schema.supplier_orders_history (supplier_orders_id, date, supplier_orders_status_id)
    VALUES (v_order_id, CURRENT_DATE, v_status_id);

    -- Insert items into supplier_order_items
    FOR v_item IN SELECT * FROM jsonb_array_elements(p_items) LOOP
        INSERT INTO magic_beans_schema.supplier_order_items (quantity, supplier_orders_id, bean_id)
        VALUES (
            (v_item->>'quantity')::INT,
            v_order_id,
            (v_item->>'bean_id')::INT
        );
    END LOOP;

    -- Output success message
    RAISE NOTICE 'Supplier order % inserted successfully and history recorded', v_order_id;
END;
$$;
