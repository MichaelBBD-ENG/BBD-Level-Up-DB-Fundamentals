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
AFTER UPDATE ON magic_beans_schema."order"
FOR EACH ROW EXECUTE FUNCTION magic_beans_schema.log_order_status_change();

CREATE OR REPLACE FUNCTION magic_beans_schema.validate_driver()
RETURNS TRIGGER AS $$
BEGIN
    -- Check if assigned driver has driver role
    IF NOT EXISTS (
        SELECT 1 FROM magic_beans_schema."user_roles" ur
        JOIN magic_beans_schema."roles" r ON ur.role_id = r.id
        WHERE ur.user_id = NEW.driver_id AND r.role = 'Driver'
    ) THEN
        RAISE EXCEPTION 'User % is not a driver', NEW.driver_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER check_driver
BEFORE INSERT OR UPDATE ON magic_beans_schema."delivery"
FOR EACH ROW EXECUTE FUNCTION magic_beans_schema.validate_driver();