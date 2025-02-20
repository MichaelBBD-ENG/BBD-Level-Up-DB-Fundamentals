WITH RolesData AS (
  SELECT 'Admin' AS "role"
  UNION ALL
  SELECT 'Driver'
  UNION ALL
  SELECT 'Customer'
),
ins AS (
  INSERT INTO magic_beans_schema."roles" ("role")
  SELECT role FROM RolesData
  ON CONFLICT ("role") DO NOTHING
  RETURNING "role"
),
del AS (
  DELETE FROM magic_beans_schema."roles"
  WHERE "role" NOT IN (SELECT role FROM RolesData)
  RETURNING "role"
)
SELECT 'Inserted' AS operation, role FROM ins
UNION ALL
SELECT 'Deleted' AS operation, role FROM del;
