ALTER TABLE magic_beans_schema."delivery"
ADD CONSTRAINT unique_order_id UNIQUE ("order_id");
 
ALTER TABLE magic_beans_schema."inventory"
ADD CONSTRAINT unique_bean_id UNIQUE ("bean_id");
 
ALTER TABLE magic_beans_schema."bean"
ADD CONSTRAINT unique_name_property UNIQUE ("name", "magical_property");