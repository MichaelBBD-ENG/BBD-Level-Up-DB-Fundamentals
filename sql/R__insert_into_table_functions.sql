CREATE OR REPLACE FUNCTION insert_user(
    first_name_input VARCHAR, 
    last_name_input VARCHAR,
    username_input VARCHAR,
    hashed_password_input VARCHAR,
    phone_input VARCHAR,
    email_input VARCHAR,
    address_input TEXT
)
RETURNS VOID AS $$
DECLARE
    new_id INT;
BEGIN
    INSERT INTO magic_beans_schema."contact_information" (phone, email, address)
    VALUES (phone_input, email_input, address_input)
    RETURNING id INTO new_id;
    
    INSERT INTO magic_beans_schema."users" (first_name, last_name, username, hashed_password, contact_id)
    VALUES (first_name_input, last_name_input, username_input, hashed_password_input, new_id);
END;
$$ LANGUAGE plpgsql;
