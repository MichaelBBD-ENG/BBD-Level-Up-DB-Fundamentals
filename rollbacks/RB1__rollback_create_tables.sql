-- Drop Foreign Keys
ALTER TABLE magic_beans_schema."supplier" DROP CONSTRAINT "Supplier_contact_id_fkey";
ALTER TABLE magic_beans_schema."orders" DROP CONSTRAINT "Orders_user_id_fkey";
ALTER TABLE magic_beans_schema."orders" DROP CONSTRAINT "Orders_payment_method_id_fkey";
ALTER TABLE magic_beans_schema."orders" DROP CONSTRAINT "Orders_order_status_id_fkey";
ALTER TABLE magic_beans_schema."orders" DROP CONSTRAINT "Orders_supplier_id_fkey";
ALTER TABLE magic_beans_schema."orders" DROP CONSTRAINT "Orders_order_type_id_fkey";
ALTER TABLE magic_beans_schema."order_item" DROP CONSTRAINT "OrderItem_order_id_fkey";
ALTER TABLE magic_beans_schema."order_item" DROP CONSTRAINT "OrderItem_bean_id_fkey";
ALTER TABLE magic_beans_schema."order_history" DROP CONSTRAINT "OrderHistory_order_id_fkey";
ALTER TABLE magic_beans_schema."order_history" DROP CONSTRAINT "OrderHistory_order_status_id_fkey";
ALTER TABLE magic_beans_schema."bean" DROP CONSTRAINT "Bean_magical_property_fkey";
ALTER TABLE magic_beans_schema."inventory" DROP CONSTRAINT "Inventory_bean_id_fkey";
ALTER TABLE magic_beans_schema."users" DROP CONSTRAINT "Users_contact_id_fkey";
ALTER TABLE magic_beans_schema."user_role" DROP CONSTRAINT "UserRole_user_id_fkey";
ALTER TABLE magic_beans_schema."user_role" DROP CONSTRAINT "UserRole_role_id_fkey";
ALTER TABLE magic_beans_schema."payment" DROP CONSTRAINT "Payment_order_id_fkey";
ALTER TABLE magic_beans_schema."payment" DROP CONSTRAINT "Payment_status_id_fkey";
ALTER TABLE magic_beans_schema."delivery" DROP CONSTRAINT "Delivery_order_id_fkey";
ALTER TABLE magic_beans_schema."delivery" DROP CONSTRAINT "Delivery_driver_id_fkey";

-- Drop Tables
DROP TABLE IF EXISTS magic_beans_schema."delivery";
DROP TABLE IF EXISTS magic_beans_schema."payment_status";
DROP TABLE IF EXISTS magic_beans_schema."payment";
DROP TABLE IF EXISTS magic_beans_schema."ContactInformation";
DROP TABLE IF EXISTS magic_beans_schema."roles";
DROP TABLE IF EXISTS magic_beans_schema."user_role";
DROP TABLE IF EXISTS magic_beans_schema."users";
DROP TABLE IF EXISTS magic_beans_schema."magical_property";
DROP TABLE IF EXISTS magic_beans_schema."inventory";
DROP TABLE IF EXISTS magic_beans_schema."bean";
DROP TABLE IF EXISTS magic_beans_schema."order_status";
DROP TABLE IF EXISTS magic_beans_schema."payment_method";
DROP TABLE IF EXISTS magic_beans_schema."order_history";
DROP TABLE IF EXISTS magic_beans_schema."order_item";
DROP TABLE IF EXISTS magic_beans_schema."orders";
DROP TABLE IF EXISTS magic_beans_schema."supplier";
DROP TABLE IF EXISTS magic_beans_schema."order_type";
