ALTER TABLE magic_beans_schema."supplier_orders_status"
ADD CONSTRAINT unique_supplier_orders_status UNIQUE ("status");
 
ALTER TABLE magic_beans_schema."supplier_orders"
ADD CONSTRAINT unique_supplier_orders_invoice UNIQUE ("invoice");
 
ALTER TABLE magic_beans_schema."payment_method"
ADD CONSTRAINT unique_payment_method UNIQUE ("method");
 
ALTER TABLE magic_beans_schema."roles"
ADD CONSTRAINT unique_role UNIQUE ("role");