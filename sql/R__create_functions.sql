-- Auto-Calaculate price in orders
CREATE OR REPLACE FUNCTION calculate_order_total()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE "Orders"

    SET total_price = (
        SELECT COALESCE(SUM(price*quantity), 0)
        FROM OrderItem 
        WHERE order_id = NEW.id
    )
    WHERE id=new.id;

    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;   

CREATE TRIGGER update_order_total
AFTER INSERT OR UPDATE ON "OrderItem"
FOR EACH ROW EXECUTE FUNCTION calculate_order_total();

-- Auto-Calaculate price in OrderItem
CREATE OR REPLACE FUNCTION calculate_item_price()
RETURNS TRIGGER AS $$
BEGIN
    SELECT price into NEW.price FROM "Bean" WHERE id=NEW.bean_id;
    IF NEW.price is NULL THEN
        RAISE EXCEPTION 'Bean ID % does not have a price', NEW.bean_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER update_item_price
AFTER INSERT ON "OrderItem"
FOR EACH ROW EXECUTE FUNCTION calculate_item_price();

-- Prevent negative stock values
CREATE OR REPLACE FUNCTION prevent_negative_stock()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.quantity < 0 THEN
        RAISE EXCEPTION 'Stock cannot be negative for Bean ID %', NEW.bean_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER enforce_positive_inventory
BEFORE INSERT OR UPDATE ON "Inventory"
FOR EACH ROW EXECUTE FUNCTION prevent_negative_stock();

-- Handle stock updates for supplier orders
CREATE OR REPLACE FUNCTION update_stock_for_supplier_order()
RETURNS TRIGGER AS $$
DECLARE
    delivered_status_id BIGINT := (SELECT id FROM "OrderStatus" WHERE status = 'Delivered');
    supplier_order_type_id BIGINT := (SELECT id FROM "OrderType" WHERE type = 'Supplier');
BEGIN
    -- Update inventory for supplier orders 
    IF NEW.order_status_id = delivered_status_id
        AND NEW.order_type_id = supplier_order_type_id THEN
        -- Add stock for each bean in the order 
        UPDATE "Inventory" i
        SET quantity = i.quantity + oi.quantity
        FROM "OrderItem" oi
        WHERE oi.order_id = NEW.id
        AND oi.bean_id = i.bean_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER handle_supplier_order_stock_updates
AFTER INSERT OR UPDATE ON "Orders"
FOR EACH ROW
WHEN (
    NEW.order_status_id IS DISTINCT FROM OLD.order_status_id
    AND NEW.order_type_id = (SELECT id FROM "OrderType" WHERE type = 'Supplier')
)
EXECUTE FUNCTION update_stock_for_supplier_order();

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

CREATE TRIGGER track_order_status
AFTER UPDATE ON "Orders"
FOR EACH ROW EXECUTE FUNCTION log_order_status_change();
