-- prevent users from selecting data not related to them in the users table
CREATE POLICY user_restrict_policy ON magic_beans_schema."user"
FOR ALL
TO ${analyst_role_name}
USING (id = current_setting('session.auth_user_id')::int);