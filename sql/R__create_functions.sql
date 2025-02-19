-- Auto-Calaculate price in orders
CREATE OR REPLACE FUNCTION calculate_order_total()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE "Orders"

    SET total_price = (
        SELECT COALESCE(SUM(price), 0)
        FROM "OrderItem" 
        WHERE order_id = NEW.order_id
    )
    WHERE id = NEW.order_id;

    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;   

CREATE OR REPLACE TRIGGER update_order_total
AFTER INSERT OR UPDATE ON "OrderItem"
FOR EACH ROW EXECUTE FUNCTION calculate_order_total();

-- Auto-calculate order item price
CREATE OR REPLACE FUNCTION calculate_item_price()
RETURNS TRIGGER AS $$
BEGIN
    SELECT price INTO NEW.price 
    FROM "Bean" 
    WHERE id = NEW.bean_id;

    NEW.price := NEW.price * NEW.quantity;
    
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE TRIGGER update_item_price
BEFORE INSERT OR UPDATE ON "OrderItem"
FOR EACH ROW EXECUTE FUNCTION calculate_item_price();

-- Track status changes 
CREATE OR REPLACE FUNCTION log_order_status_change()
RETURNS TRIGGER AS $$
BEGIN
  IF (OLD.order_status_id != NEW.order_status_id) THEN
    INSERT INTO "OrderHistory" (order_id, order_status_id)
    VALUES (NEW.id, NEW.order_status_id);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE TRIGGER track_order_status
AFTER UPDATE ON "Orders"
FOR EACH ROW EXECUTE FUNCTION log_order_status_change();
