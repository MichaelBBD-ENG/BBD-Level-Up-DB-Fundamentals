ALTER TABLE magic_beans_schema."delivery"
DROP COLUMN "delivery_notes";

ALTER ROLE ${admin_role_name} BYPASSRLS;
ALTER ROLE ${analyst_role_name} BYPASSRLS;

GRANT CREATE, USAGE ON SCHEMA magic_beans_schema, public TO ${admin_role_name};
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA magic_beans_schema TO ${admin_role_name};
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA magic_beans_schema TO ${admin_role_name};

GRANT CREATE, USAGE ON SCHEMA magic_beans_schema, public TO ${analyst_role_name};
GRANT SELECT ON ALL TABLES IN SCHEMA magic_beans_schema TO ${analyst_role_name};