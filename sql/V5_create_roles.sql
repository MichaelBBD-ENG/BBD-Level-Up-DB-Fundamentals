BEGIN TRANSACTION;

-- basically admin, sudo, root
CREATE ROLE admin WITH LOGIN SUPERUSER;
COMMENT ON ROLE admin IS 'basically admin, sudo, root'; 

-- can only read from the db
CREATE ROLE reader WITH LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT;
ALTER DEFAULT PRIVILEGES IN SCHEMA magic_beans_schema GRANT SELECT ON ALL TABLES IN SCHEMA magic_beans_schema TO reader;
COMMENT ON ROLE reader IS 'can only read from the db'; 

-- can only write to the db
CREATE ROLE editor WITH LOGIN;
ALTER DEFAULT PRIVILEGES IN SCHEMA magic_beans_schema GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA magic_beans_schema TO editor;
COMMENT ON ROLE editor IS 'can only write to the db'; 

-- can create objects and modify objects but cannot change roles, permissions etc
CREATE ROLE developer WITH LOGIN CREATEDB;
GRANT CREATE, USAGE ON SCHEMA magic_beans_schema TO developer;
COMMENT ON ROLE developer IS 'an create objects and modify objects but cannot change roles, permissions etc'; 

-- cannot modify data but can create backups of data
CREATE ROLE backup_operator WITH LOGIN;
GRANT SELECT ON ALL TABLES IN SCHEMA magic_beans_schema TO backup_operator;
ALTER DEFAULT PRIVILEGES IN SCHEMA magic_beans_schema GRANT SELECT ON ALL TABLES TO backup_operator;
COMMENT ON ROLE backup_operator IS 'cannot modify data but can create backups of data'; 

-- usage for backend/frontend stack
CREATE ROLE app_user WITH LOGIN;
GRANT USAGE ON SCHEMA magic_beans_schema TO app_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA magic_beans_schema GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA magic_beans_schema TO app_user;
COMMENT ON ROLE app_user IS 'usage for backend/frontend stack'; 

COMMIT;