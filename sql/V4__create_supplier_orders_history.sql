CREATE TABLE magic_beans_schema."supplier_orders_history" (
  "id" int PRIMARY KEY,
  "supplier_orders_id" INT NOT NULL,
  "date" DATE DEFAULT (CURRENT_TIMESTAMP),
  "supplier_orders_status_id" INT NOT NULL
);

ALTER TABLE magic_beans_schema."supplier_orders_history" ADD FOREIGN KEY ("supplier_orders_id") REFERENCES magic_beans_schema."supplier_orders" ("id");

ALTER TABLE magic_beans_schema."supplier_orders_history" ADD FOREIGN KEY ("supplier_orders_status_id") REFERENCES magic_beans_schema."supplier_orders_status" ("id");