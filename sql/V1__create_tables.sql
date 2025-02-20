CREATE TABLE magic_beans_schema."supplier" (
  "id" INT PRIMARY KEY,
  "name" VARCHAR(255) UNIQUE NOT NULL,
  "contact_id" INT NOT NULL
);

CREATE TABLE magic_beans_schema."supplier_orders_status" (
  "id" INT PRIMARY KEY,
  "status" VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE magic_beans_schema."supplier_orders" (
  "id" INT PRIMARY KEY,
  "admin_id" INT,
  "order_date" DATE DEFAULT (CURRENT_TIMESTAMP),
  "supplier_id" INT,
  "supplier_order_status_id" INT,
  "invoice" uuid
);

CREATE TABLE magic_beans_schema."supplier_order_items" (
  "id" int PRIMARY KEY,
  "quantity" int,
  "supplier_orders_id" int,
  "bean_id" int
);

CREATE TABLE magic_beans_schema."order" (
  "id" INT PRIMARY KEY,
  "user_id" INT NOT NULL,
  "order_date" DATE DEFAULT (CURRENT_TIMESTAMP),
  "payment_id" INT NOT NULL,
  "order_status_id" INT NOT NULL
);

CREATE TABLE magic_beans_schema."order_history" (
  "id" int PRIMARY KEY,
  "order_id" INT NOT NULL,
  "date" DATE DEFAULT (CURRENT_TIMESTAMP),
  "order_status_id" INT NOT NULL
);

CREATE TABLE magic_beans_schema."order_item" (
  "id" INT PRIMARY KEY,
  "order_id" INT NOT NULL,
  "bean_id" INT NOT NULL,
  "quantity" INT NOT NULL
);

CREATE TABLE magic_beans_schema."payment_method" (
  "id" INT PRIMARY KEY,
  "method" VARCHAR(100)
);

CREATE TABLE magic_beans_schema."order_status" (
  "id" INT PRIMARY KEY,
  "status" VARCHAR(100)
);

CREATE TABLE magic_beans_schema."bean" (
  "id" INT PRIMARY KEY,
  "name" VARCHAR(255) UNIQUE NOT NULL,
  "description" TEXT,
  "price" DECIMAL(10,2) NOT NULL,
  "magical_property" INT NOT NULL
);

CREATE TABLE magic_beans_schema."inventory" (
  "id" int PRIMARY KEY,
  "bean_id" int NOT NULL,
  "quantity" int NOT NULL
);

CREATE TABLE magic_beans_schema."magical_property" (
  "id" INT PRIMARY KEY,
  "name" VARCHAR(255) UNIQUE NOT NULL,
  "description" TEXT
);

CREATE TABLE magic_beans_schema."user" (
  "id" INT PRIMARY KEY,
  "first_name" VARCHAR(100) NOT NULL,
  "last_name" VARCHAR(100) NOT NULL,
  "username" VARCHAR(100) UNIQUE NOT NULL,
  "contact_id" INT NOT NULL
);

CREATE TABLE magic_beans_schema."user_roles" (
  "id" INT PRIMARY KEY,
  "user_id" INT NOT NULL,
  "role_id" INT NOT NULL
);

CREATE TABLE magic_beans_schema."roles" (
  "id" INT PRIMARY KEY,
  "role" VARCHAR(100) NOT NULL
);

CREATE TABLE magic_beans_schema."contact_information" (
  "id" INT PRIMARY KEY,
  "phone" VARCHAR(20) UNIQUE,
  "email" VARCHAR(255) UNIQUE,
  "address" TEXT
);

CREATE TABLE magic_beans_schema."payment" (
  "id" INT PRIMARY KEY,
  "order_id" INT NOT NULL,
  "payment_method_id" INT NOT NULL,
  "payment_date" DATE DEFAULT (CURRENT_TIMESTAMP),
  "amount" DECIMAL(10,2) NOT NULL
);

CREATE TABLE magic_beans_schema."delivery" (
  "id" INT PRIMARY KEY,
  "order_id" INT NOT NULL,
  "driver_id" INT NOT NULL,
  "delivery_notes" TEXT
);

ALTER TABLE magic_beans_schema."supplier" ADD FOREIGN KEY ("contact_id") REFERENCES magic_beans_schema."contact_information" ("id");

ALTER TABLE magic_beans_schema."supplier_orders" ADD FOREIGN KEY ("admin_id") REFERENCES magic_beans_schema."user" ("id");

ALTER TABLE magic_beans_schema."supplier_orders" ADD FOREIGN KEY ("supplier_id") REFERENCES magic_beans_schema."supplier" ("id");

ALTER TABLE magic_beans_schema."supplier_orders" ADD FOREIGN KEY ("supplier_order_status_id") REFERENCES magic_beans_schema."supplier_orders_status" ("id");

ALTER TABLE magic_beans_schema."supplier_order_items" ADD FOREIGN KEY ("supplier_orders_id") REFERENCES magic_beans_schema."supplier_orders" ("id");

ALTER TABLE magic_beans_schema."supplier_order_items" ADD FOREIGN KEY ("bean_id") REFERENCES magic_beans_schema."bean" ("id");

ALTER TABLE magic_beans_schema."order" ADD FOREIGN KEY ("user_id") REFERENCES magic_beans_schema."user" ("id");

ALTER TABLE magic_beans_schema."order" ADD FOREIGN KEY ("payment_id") REFERENCES magic_beans_schema."payment" ("id");

ALTER TABLE magic_beans_schema."order" ADD FOREIGN KEY ("order_status_id") REFERENCES magic_beans_schema."order_status" ("id");

ALTER TABLE magic_beans_schema."order_history" ADD FOREIGN KEY ("order_id") REFERENCES magic_beans_schema."order" ("id");

ALTER TABLE magic_beans_schema."order_history" ADD FOREIGN KEY ("order_status_id") REFERENCES magic_beans_schema."order_status" ("id");

ALTER TABLE magic_beans_schema."order_item" ADD FOREIGN KEY ("order_id") REFERENCES magic_beans_schema."order" ("id");

ALTER TABLE magic_beans_schema."order_item" ADD FOREIGN KEY ("bean_id") REFERENCES magic_beans_schema."bean" ("id");

ALTER TABLE magic_beans_schema."bean" ADD FOREIGN KEY ("magical_property") REFERENCES magic_beans_schema."magical_property" ("id");

ALTER TABLE magic_beans_schema."inventory" ADD FOREIGN KEY ("bean_id") REFERENCES magic_beans_schema."bean" ("id");

ALTER TABLE magic_beans_schema."user" ADD FOREIGN KEY ("contact_id") REFERENCES magic_beans_schema."contact_information" ("id");

ALTER TABLE magic_beans_schema."user_roles" ADD FOREIGN KEY ("user_id") REFERENCES magic_beans_schema."user" ("id");

ALTER TABLE magic_beans_schema."user_roles" ADD FOREIGN KEY ("role_id") REFERENCES magic_beans_schema."roles" ("id");

ALTER TABLE magic_beans_schema."payment" ADD FOREIGN KEY ("order_id") REFERENCES magic_beans_schema."order" ("id");

ALTER TABLE magic_beans_schema."payment" ADD FOREIGN KEY ("payment_method_id") REFERENCES magic_beans_schema."payment_method" ("id");

ALTER TABLE magic_beans_schema."delivery" ADD FOREIGN KEY ("order_id") REFERENCES magic_beans_schema."order" ("id");

ALTER TABLE magic_beans_schema."delivery" ADD FOREIGN KEY ("driver_id") REFERENCES magic_beans_schema."user" ("id");
