CREATE OR REPLACE PROCEDURE()
LANGUAGE plpgsql
AS $$
BEGIN
WITH updated_order_status AS (
    UPDATE magic_beans_schema."order_status"
    SET magic_beans_schema."order_status".status = "Expired"
    FROM magic_beans_schema."order"
    WHERE magic_beans_schema."order_status".id = magic_beans_schema."order".order_status_id
    AND magic_beans_schema."order".order_date < NOW() - INTERVAL '7 days'
    RETURNING magic_beans_schema."order_status".id
)
UPDATE magic_beans_schema."order_history"
SET date = NOW()
WHERE magic_beans_schema."order_history".order_status_id IN (SELECT id FROM updated_order_status);
END;
$$;


