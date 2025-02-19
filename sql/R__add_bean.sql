CREATE OR REPLACE PROCEDURE magic_beans_schema.add_bean(
    p_name VARCHAR(255),
    p_description TEXT,
    p_price NUMERIC(10,2),
    p_magical_property_name VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
DECLARE
    magical_property_id BIGINT;
BEGIN
    SELECT id 
    INTO magical_property_id 
    FROM magic_beans_schema.magical_property
    WHERE name = p_magical_property_name;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Magical property not found: %', p_magical_property_name;
    END IF;
    
    INSERT INTO magic_beans_schema.bean (
        name, description, price, magical_property
    )
    VALUES (
        p_name, p_description, p_price, magical_property_id
    );
END;
$$;
