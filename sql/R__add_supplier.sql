CREATE OR REPLACE PROCEDURE magic_beans_schema.add_supplier_with_contact(
    supplier_name VARCHAR(255),
    contact_phone VARCHAR(20),
    contact_email VARCHAR(255),
    contact_address TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    contact_id BIGINT;
BEGIN
    SELECT id INTO contact_id 
    FROM magic_beans_schema.contact_information 
    WHERE phone = contact_phone OR email = contact_email;

    IF contact_id IS NULL THEN
        INSERT INTO magic_beans_schema.contact_information (phone, email, address)
        VALUES (contact_phone, contact_email, contact_address)
        RETURNING id INTO contact_id;
    END IF;

    INSERT INTO magic_beans_schema.supplier (name, contact_id)
    VALUES (supplier_name, contact_id)
    ON CONFLICT (name) DO NOTHING;
END;
$$;
