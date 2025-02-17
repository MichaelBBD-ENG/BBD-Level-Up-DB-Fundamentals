-- Drop Foreign Keys
ALTER TABLE "Supplier" DROP CONSTRAINT "Supplier_contact_id_fkey";
ALTER TABLE "Orders" DROP CONSTRAINT "Orders_user_id_fkey";
ALTER TABLE "Orders" DROP CONSTRAINT "Orders_payment_method_id_fkey";
ALTER TABLE "Orders" DROP CONSTRAINT "Orders_order_status_id_fkey";
ALTER TABLE "Orders" DROP CONSTRAINT "Orders_supplier_id_fkey";
ALTER TABLE "Orders" DROP CONSTRAINT "Orders_order_type_id_fkey";
ALTER TABLE "OrderItem" DROP CONSTRAINT "OrderItem_order_id_fkey";
ALTER TABLE "OrderItem" DROP CONSTRAINT "OrderItem_bean_id_fkey";
ALTER TABLE "OrderHistory" DROP CONSTRAINT "OrderHistory_order_id_fkey";
ALTER TABLE "OrderHistory" DROP CONSTRAINT "OrderHistory_order_status_id_fkey";
ALTER TABLE "Bean" DROP CONSTRAINT "Bean_magical_property_fkey";
ALTER TABLE "Inventory" DROP CONSTRAINT "Inventory_bean_id_fkey";
ALTER TABLE "Users" DROP CONSTRAINT "Users_contact_id_fkey";
ALTER TABLE "UserRole" DROP CONSTRAINT "UserRole_user_id_fkey";
ALTER TABLE "UserRole" DROP CONSTRAINT "UserRole_role_id_fkey";
ALTER TABLE "Payment" DROP CONSTRAINT "Payment_order_id_fkey";
ALTER TABLE "Payment" DROP CONSTRAINT "Payment_status_id_fkey";
ALTER TABLE "Delivery" DROP CONSTRAINT "Delivery_order_id_fkey";
ALTER TABLE "Delivery" DROP CONSTRAINT "Delivery_driver_id_fkey";

-- Drop Tables
DROP TABLE IF EXISTS "Delivery";
DROP TABLE IF EXISTS "PaymentStatus";
DROP TABLE IF EXISTS "Payment";
DROP TABLE IF EXISTS "ContactInformation";
DROP TABLE IF EXISTS "Roles";
DROP TABLE IF EXISTS "UserRole";
DROP TABLE IF EXISTS "Users";
DROP TABLE IF EXISTS "MagicalProperty";
DROP TABLE IF EXISTS "Inventory";
DROP TABLE IF EXISTS "Bean";
DROP TABLE IF EXISTS "OrderStatus";
DROP TABLE IF EXISTS "PaymentMethod";
DROP TABLE IF EXISTS "OrderHistory";
DROP TABLE IF EXISTS "OrderItem";
DROP TABLE IF EXISTS "Orders";
DROP TABLE IF EXISTS "Supplier";
DROP TABLE IF EXISTS "OrderType";
