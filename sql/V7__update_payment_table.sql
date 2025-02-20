ALTER TABLE magic_beans_schema."payment" 
DROP CONSTRAINT IF EXISTS payment_order_id_fkey;

ALTER TABLE magic_beans_schema."payment" 
DROP COLUMN IF EXISTS "order_id";