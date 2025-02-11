DO $$ 
DECLARE 
    db_table RECORD;
BEGIN
    -- creating a new schema for our database
    CREATE SCHEMA magic_beans_schema;

    FOR db_table IN SELECT tablename FROM pg_tables WHERE schemaname = 'public'
    LOOP
        EXECUTE format('ALTER TABLE public.%I SET SCHEMA magic_beans_schema', db_table.tablename);
    END LOOP;
END $$;
