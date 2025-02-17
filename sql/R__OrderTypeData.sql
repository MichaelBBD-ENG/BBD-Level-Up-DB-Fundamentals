WITH OrderTypeData AS (
    SELECT 'Supplier' AS "type"
    UNION ALL
    SELECT 'Customer'
)
MERGE INTO magic_beans_schema."order_type" AS target
USING OrderTypeData AS source
    ON target."type" = source."type"
WHEN NOT MATCHED BY TARGET THEN
    INSERT ("type") VALUES (source."type")
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;