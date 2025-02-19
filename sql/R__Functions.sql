-- Auto-Calaculate price in orders
CREATE OR REPLACE FUNCTION magic_beans_schema.calculate_order_total()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE magic_beans_schema."orders" 

    SET total_price = (
        SELECT COALESCE(SUM(price), 0)
        FROM magic_beans_schema."order_item" 
        WHERE order_id = NEW.order_id
    )
    WHERE id = NEW.order_id;

    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;   

CREATE OR REPLACE TRIGGER update_order_total
AFTER INSERT OR UPDATE OR DELETE ON magic_beans_schema."order_item"
FOR EACH ROW EXECUTE FUNCTION magic_beans_schema.calculate_order_total();

-- Auto-calculate order item price
CREATE OR REPLACE FUNCTION magic_beans_schema.calculate_item_price()
RETURNS TRIGGER AS $$
DECLARE
    bean_price NUMERIC(10,2);
BEGIN
    SELECT price INTO bean_price 
    FROM magic_beans_schema."bean"
    WHERE id = NEW.bean_id;

    IF bean_price IS NULL THEN
        RAISE EXCEPTION 'Bean with id % not found', NEW.bean_id;
    END IF;

    NEW.price := NEW.price * NEW.quantity;
    
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE TRIGGER update_item_price
BEFORE INSERT OR UPDATE ON magic_beans_schema."order_item"
FOR EACH ROW EXECUTE FUNCTION magic_beans_schema.calculate_item_price();

-- Track status changes 
CREATE OR REPLACE FUNCTION magic_beans_schema.log_order_status_change()
RETURNS TRIGGER AS $$
BEGIN
  IF (OLD.order_status_id != NEW.order_status_id) THEN
    INSERT INTO magic_beans_schema."order_history" (order_id, order_status_id)
    VALUES (NEW.id, NEW.order_status_id);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE TRIGGER track_order_status
AFTER UPDATE ON magic_beans_schema."orders"
FOR EACH ROW EXECUTE FUNCTION magic_beans_schema.log_order_status_change();