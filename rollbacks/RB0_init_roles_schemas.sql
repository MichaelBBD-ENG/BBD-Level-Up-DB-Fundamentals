-- undo change schema
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

-- delete roles
BEGIN TRANSACTION;

DROP ROLE IF EXISTS app_user;
DROP ROLE IF EXISTS backup_operator;
DROP ROLE IF EXISTS developer;
DROP ROLE IF EXISTS editor;
DROP ROLE IF EXISTS reader;
DROP ROLE IF EXISTS admin;

COMMIT;

-- rollback revoke access
BEGIN TRANSACTION;

GRANT USAGE ON SCHEMA public TO PUBLIC;
GRANT USAGE ON SCHEMA magic_beans_schema TO PUBLIC;
GRANT CREATE ON SCHEMA public TO PUBLIC;

COMMIT;