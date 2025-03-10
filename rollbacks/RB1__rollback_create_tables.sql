-- Drop Foreign Keys
ALTER TABLE magic_beans_schema."supplier" DROP CONSTRAINT "supplier_contact_id_fkey";
ALTER TABLE magic_beans_schema."orders" DROP CONSTRAINT "orders_user_id_fkey";
ALTER TABLE magic_beans_schema."orders" DROP CONSTRAINT "orders_payment_method_id_fkey";
ALTER TABLE magic_beans_schema."orders" DROP CONSTRAINT "orders_order_status_id_fkey";
ALTER TABLE magic_beans_schema."orders" DROP CONSTRAINT "orders_supplier_id_fkey";
ALTER TABLE magic_beans_schema."orders" DROP CONSTRAINT "orders_order_type_id_fkey";
ALTER TABLE magic_beans_schema."order_item" DROP CONSTRAINT "order_item_order_id_fkey";
ALTER TABLE magic_beans_schema."order_item" DROP CONSTRAINT "order_item_bean_id_fkey";
ALTER TABLE magic_beans_schema."order_history" DROP CONSTRAINT "order_history_order_id_fkey";
ALTER TABLE magic_beans_schema."order_history" DROP CONSTRAINT "order_history_order_status_id_fkey";
ALTER TABLE magic_beans_schema."bean" DROP CONSTRAINT "bean_magical_property_fkey";
ALTER TABLE magic_beans_schema."inventory" DROP CONSTRAINT "inventory_bean_id_fkey";
ALTER TABLE magic_beans_schema."users" DROP CONSTRAINT "users_contact_id_fkey";
ALTER TABLE magic_beans_schema."user_role" DROP CONSTRAINT "user_role_user_id_fkey";
ALTER TABLE magic_beans_schema."user_role" DROP CONSTRAINT "user_role_role_id_fkey";
ALTER TABLE magic_beans_schema."payment" DROP CONSTRAINT "payment_order_id_fkey";
ALTER TABLE magic_beans_schema."payment" DROP CONSTRAINT "payment_status_id_fkey";
ALTER TABLE magic_beans_schema."delivery" DROP CONSTRAINT "delivery_order_id_fkey";
ALTER TABLE magic_beans_schema."delivery" DROP CONSTRAINT "delivery_driver_id_fkey";

-- Drop Tables
DROP TABLE IF EXISTS magic_beans_schema."delivery";
DROP TABLE IF EXISTS magic_beans_schema."payment_status";
DROP TABLE IF EXISTS magic_beans_schema."payment";
DROP TABLE IF EXISTS magic_beans_schema."contact_information";
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
