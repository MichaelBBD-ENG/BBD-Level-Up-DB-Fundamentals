CREATE OR REPLACE PROCEDURE magic_beans_schema.add_magical_property(
    p_name VARCHAR(255),
    p_description TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO magic_beans_schema.magical_property (
        name, description
    )
    VALUES (
        p_name, p_description
    );
END;
$$;