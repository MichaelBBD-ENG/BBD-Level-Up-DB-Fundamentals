DO $$ 
DECLARE 
    db_table RECORD;
BEGIN
    -- Create the new schema if it doesn't exist
    CREATE SCHEMA IF NOT EXISTS magic_beans_schema;

    FOR db_table IN 
        SELECT tablename 
        FROM pg_tables 
        WHERE schemaname = 'public' 
        AND tablename IN ('address', 'magical_properties', 'order_items', 'orders', 'supplier_order_items', 'supplier_orders', 'suppliers','user_roles', 'beans', 'users', 'contact_information')
    LOOP
        EXECUTE format('ALTER TABLE public.%I SET SCHEMA magic_beans_schema', db_table.tablename);
    END LOOP;
END $$;
