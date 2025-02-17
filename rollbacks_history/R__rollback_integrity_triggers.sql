-- Remove Triggers
DROP TRIGGER IF EXISTS update_order_total ON magic_beans_schema.order_items;
DROP TRIGGER IF EXISTS update_item_price ON magic_beans_schema.order_items;
DROP TRIGGER IF EXISTS validate_supplier_order_trigger ON magic_beans_schema.supplier_orders;
DROP TRIGGER IF EXISTS unique_address ON magic_beans_schema.address;
DROP TRIGGER IF EXISTS deduct_stock_on_order ON magic_beans_schema.order_items;
DROP TRIGGER IF EXISTS enforce_email_format ON magic_beans_schema.contact_information;
DROP TRIGGER IF EXISTS enforce_positive_stock ON magic_beans_schema.beans;
DROP TRIGGER IF EXISTS check_order_quantity ON magic_beans_schema.order_items;
DROP TRIGGER IF EXISTS enforce_positive_price ON magic_beans_schema.beans;
DROP TRIGGER IF EXISTS handle_supplier_order_delivery ON magic_beans_schema.supplier_orders;

-- Remove Functions
DROP FUNCTION IF EXISTS magic_beans_schema.calculate_order_total;
DROP FUNCTION IF EXISTS magic_beans_schema.calculate_item_price;
DROP FUNCTION IF EXISTS magic_beans_schema.validate_supplier_order;
DROP FUNCTION IF EXISTS magic_beans_schema.prevent_duplicate_addresses;
DROP FUNCTION IF EXISTS magic_beans_schema.reduce_stock_on_order;
DROP FUNCTION IF EXISTS magic_beans_schema.validate_email_format;
DROP FUNCTION IF EXISTS magic_beans_schema.prevent_negative_stock;
DROP FUNCTION IF EXISTS magic_beans_schema.validate_order_quantity;
DROP FUNCTION IF EXISTS magic_beans_schema.validate_price;
DROP FUNCTION IF EXISTS magic_beans_schema.update_stock_from_supplier_order;