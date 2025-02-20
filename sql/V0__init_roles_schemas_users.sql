-- Create the new schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS magic_beans_schema;

-- admin
CREATE ROLE ${admin_role_name} WITH LOGIN PASSWORD '${admin_role_password}';
GRANT CREATE, USAGE ON SCHEMA magic_beans_schema, public TO ${admin_role_name};
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA magic_beans_schema TO ${admin_role_name};

-- analyst
CREATE ROLE ${analyst_role_name} WITH LOGIN PASSWORD '${analyst_role_password}';
GRANT USAGE ON SCHEMA magic_beans_schema, public TO ${analyst_role_name};
GRANT SELECT ON ALL TABLES IN SCHEMA magic_beans_schema TO ${analyst_role_name};

-- revoke access
REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA magic_beans_schema FROM PUBLIC;