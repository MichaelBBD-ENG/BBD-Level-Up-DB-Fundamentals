-- Auto-Calculate total_price in orders
CREATE OR REPLACE FUNCTION magic_beans_schema.calculate_order_total()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE magic_beans_schema.orders
  SET total_price = (
    SELECT COALESCE(SUM(price * quantity), 0::money)
    FROM magic_beans_schema.order_items
    WHERE order_id = NEW.id
  )
  WHERE id = NEW.id;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_order_total
AFTER INSERT OR UPDATE ON magic_beans_schema.order_items
FOR EACH ROW EXECUTE FUNCTION magic_beans_schema.calculate_order_total();

-- Auto-Calculate price in order_items
CREATE OR REPLACE FUNCTION magic_beans_schema.calculate_item_price()
RETURNS TRIGGER AS $$
BEGIN
  SELECT price INTO NEW.price FROM magic_beans_schema.beans WHERE id = NEW.bean_id;
  IF NEW.price IS NULL THEN
    RAISE EXCEPTION 'Bean ID % does not exist or has no price', NEW.bean_id;
  END IF;
  
  RETURN NEW;

  
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_item_price
BEFORE INSERT ON magic_beans_schema.order_items
FOR EACH ROW EXECUTE FUNCTION magic_beans_schema.calculate_item_price();

-- Prevent supplier_orders from Being Placed with Nonexistent Suppliers
CREATE OR REPLACE FUNCTION magic_beans_schema.validate_supplier_order()
RETURNS TRIGGER AS $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM magic_beans_schema.suppliers WHERE id = NEW.supplier_id) THEN
    RAISE EXCEPTION 'Supplier ID % does not exist', NEW.supplier_id;
  END IF;

  -- Check if user exists and has Employee role
  IF NOT EXISTS (
    SELECT 1 
    FROM magic_beans_schema.users u
    JOIN magic_beans_schema.user_roles ur ON u.id = ur.user_id
    WHERE u.id = NEW.user_id 
    AND ur.role = 'Employee'
  ) THEN
      RAISE EXCEPTION 'User ID % either does not exist or is not an Employee', NEW.user_id;
    END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER validate_supplier_order_trigger
BEFORE INSERT ON magic_beans_schema.supplier_orders
FOR EACH ROW EXECUTE FUNCTION magic_beans_schema.validate_supplier_order();

-- Prevent Duplicate Addresses
CREATE OR REPLACE FUNCTION magic_beans_schema.prevent_duplicate_addresses()
RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM magic_beans_schema.address 
    WHERE street = NEW.street 
    AND city = NEW.city 
    AND country = NEW.country 
    AND postal_code = NEW.postal_code
  ) THEN
    RAISE EXCEPTION 'Address already exists';
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER unique_address
BEFORE INSERT ON magic_beans_schema.address
FOR EACH ROW EXECUTE FUNCTION magic_beans_schema.prevent_duplicate_addresses();

-- Deduct Stock When Order is Inserted
CREATE OR REPLACE FUNCTION magic_beans_schema.reduce_stock_on_order()
RETURNS TRIGGER AS $$
BEGIN
    -- Reduce stock for the ordered bean
    UPDATE magic_beans_schema.beans
    SET stock = stock - NEW.quantity
    WHERE id = NEW.bean_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER deduct_stock_on_order
AFTER INSERT ON magic_beans_schema.order_items
FOR EACH ROW EXECUTE FUNCTION magic_beans_schema.reduce_stock_on_order();

-- Validate Email Format
CREATE OR REPLACE FUNCTION magic_beans_schema.validate_email_format()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.email !~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$' THEN
        RAISE EXCEPTION 'Invalid email format: %', NEW.email;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_email_format
BEFORE INSERT OR UPDATE ON magic_beans_schema.contact_information
FOR EACH ROW EXECUTE FUNCTION magic_beans_schema.validate_email_format();

-- Prevent Negative Stock Values
CREATE OR REPLACE FUNCTION magic_beans_schema.prevent_negative_stock()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.stock < 0 THEN
        RAISE EXCEPTION 'Stock cannot be negative for bean ID %', NEW.id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_positive_stock
BEFORE INSERT OR UPDATE ON magic_beans_schema.beans
FOR EACH ROW EXECUTE FUNCTION magic_beans_schema.prevent_negative_stock();

-- Validate Order Quantity Against Available Stock
CREATE OR REPLACE FUNCTION magic_beans_schema.validate_order_quantity()
RETURNS TRIGGER AS $$
DECLARE
    available_stock INTEGER;
BEGIN
    SELECT stock INTO available_stock
    FROM magic_beans_schema.beans
    WHERE id = NEW.bean_id;
    
    IF NEW.quantity > available_stock THEN
        RAISE EXCEPTION 'Insufficient stock for bean ID %. Available: %, Requested: %', 
            NEW.bean_id, available_stock, NEW.quantity;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_order_quantity
BEFORE INSERT ON magic_beans_schema.order_items
FOR EACH ROW EXECUTE FUNCTION magic_beans_schema.validate_order_quantity();

-- Ensure Non-Negative Prices
CREATE OR REPLACE FUNCTION magic_beans_schema.validate_price()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.price::numeric <= 0 THEN
        RAISE EXCEPTION 'Price must be greater than zero';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_positive_price
BEFORE INSERT OR UPDATE ON magic_beans_schema.beans
FOR EACH ROW EXECUTE FUNCTION magic_beans_schema.validate_price();

-- Handle Stock Updates from Supplier Orders
CREATE OR REPLACE FUNCTION magic_beans_schema.update_stock_from_supplier_order()
RETURNS TRIGGER AS $$
BEGIN
    -- Only process when order status changes to 'Delivered'
    IF NEW.order_status = 'Delivered' AND OLD.order_status != 'Delivered' THEN
        -- Update stock for all items in the supplier order
        UPDATE magic_beans_schema.beans b
        SET stock = b.stock + soi.quantity
        FROM magic_beans_schema.supplier_order_items soi
        WHERE soi.supplier_order_id = NEW.id
        AND soi.bean_id = b.id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER handle_supplier_order_delivery
AFTER UPDATE ON magic_beans_schema.supplier_orders
FOR EACH ROW EXECUTE FUNCTION magic_beans_schema.update_stock_from_supplier_order();

