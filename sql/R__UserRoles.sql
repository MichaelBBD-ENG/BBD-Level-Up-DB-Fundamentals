WITH RolesData AS (
    SELECT 'Admin' AS "role"
    UNION ALL
    SELECT 'Driver'
    UNION ALL
    SELECT 'Customer'
)
MERGE INTO magic_beans_schema."roles" AS target
USING RolesData AS source
    ON target."role" = source."role"
WHEN NOT MATCHED BY TARGET THEN
    INSERT ("role") VALUES (source."role")
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;