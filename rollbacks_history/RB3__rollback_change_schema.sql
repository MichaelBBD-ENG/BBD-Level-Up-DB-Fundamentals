DO $$ 
DECLARE 
    db_table RECORD;
BEGIN
    FOR db_table IN 
        SELECT tablename FROM pg_tables WHERE schemaname = 'magic_beans_schema'
    LOOP
        EXECUTE format('ALTER TABLE magic_beans_schema.%I SET SCHEMA public', db_table.tablename);
    END LOOP;

    -- Drop the magic_beans_schema schema
    EXECUTE 'DROP SCHEMA magic_beans_schema CASCADE';
END $$;

