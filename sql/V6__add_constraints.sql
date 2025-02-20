-- Order items must have a quantity
ALTER TABLE magic_beans_schema."supplier_order_items" ADD CHECK ("quantity" > 0);
ALTER TABLE magic_beans_schema."order_item" ADD CHECK ("quantity" > 0);

-- Inventory cannot be negative
ALTER TABLE magic_beans_schema."inventory" ADD CHECK ("quantity" >= 0);

-- Price cannot be negative
ALTER TABLE magic_beans_schema."bean" ADD CHECK ("price" >= 0);

-- Ensure Invoice is unique
ALTER TABLE magic_beans_schema."supplier_orders" ADD CONSTRAINT unique_invoice UNIQUE ("invoice");

-- Prevents a user from having duplicate roles
ALTER TABLE magic_beans_schema."user_roles" ADD CONSTRAINT unique_user_role UNIQUE ("user_id", "role_id");

-- Prevent duplicate bean id's for stock
ALTER TABLE magic_beans_schema."inventory" ADD CONSTRAINT unique_inventory_bean UNIQUE ("bean_id");