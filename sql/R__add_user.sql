CREATE OR REPLACE PROCEDURE magic_beans_schema.add_user(
    p_first_name      VARCHAR(100),
    p_last_name       VARCHAR(100),
    p_username        VARCHAR(100),
    p_phone           VARCHAR(20),
    p_email           VARCHAR(255),
    p_address         TEXT,
    p_role            VARCHAR(100)
)
LANGUAGE plpgsql
AS $$
DECLARE
    new_user_id    BIGINT;
    new_contact_id BIGINT;
    role_id        BIGINT;
BEGIN
    SELECT "id" 
    INTO role_id
    FROM magic_beans_schema."roles"
    WHERE "role" = p_role;
    

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Unrecognized role: %', p_role;
    END IF;

  
    INSERT INTO magic_beans_schema."contact_information" ("phone", "email", "address")
    VALUES (p_phone, p_email, p_address)
    RETURNING "id" INTO new_contact_id;

 
    INSERT INTO magic_beans_schema."users" (
        "first_name", "last_name", "username", "hashed_password", "contact_id"
    )
    VALUES (p_first_name, p_last_name, p_username, p_hashed_password, new_contact_id)
    RETURNING "id" INTO new_user_id;

    INSERT INTO magic_beans_schema."user_role" ("user_id", "role_id")
    VALUES (new_user_id, role_id);
END;
$$;

