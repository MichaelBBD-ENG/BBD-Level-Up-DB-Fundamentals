CREATE TABLE "OrderType" (
  "id" BIGSERIAL PRIMARY KEY,
  "type" VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE "Supplier" (
  "id" BIGSERIAL PRIMARY KEY,
  "name" VARCHAR(255) UNIQUE NOT NULL,
  "contact_id" BIGINT NOT NULL
);

CREATE TABLE "Orders" (
  "id" BIGSERIAL PRIMARY KEY,
  "user_id" BIGINT NOT NULL,
  "order_date" DATE DEFAULT CURRENT_DATE CHECK ("order_date" <= CURRENT_DATE),
  "total_price" NUMERIC(10,2) NOT NULL CHECK ("total_price" >= 0),
  "payment_method_id" BIGINT NOT NULL,
  "order_status_id" BIGINT NOT NULL,
  "order_type_id" BIGINT NOT NULL,
  "supplier_id" BIGINT
);

CREATE TABLE "OrderItem" (
  "id" BIGSERIAL PRIMARY KEY,
  "order_id" BIGINT NOT NULL,
  "bean_id" BIGINT NOT NULL,
  "quantity" INTEGER NOT NULL CHECK ("quantity" > 0),
  "price" NUMERIC(10,2) NOT NULL CHECK ("price" >= 0)
);

CREATE TABLE "OrderHistory" (
  "id" BIGSERIAL PRIMARY KEY,
  "order_id" BIGINT NOT NULL,
  "date" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "order_status_id" BIGINT NOT NULL
);

CREATE TABLE "PaymentMethod" (
  "id" BIGSERIAL PRIMARY KEY,
  "method" VARCHAR(100) NOT NULL
);

CREATE TABLE "OrderStatus" (
  "id" BIGSERIAL PRIMARY KEY,
  "status" VARCHAR(100) NOT NULL
);

CREATE TABLE "Bean" (
  "id" BIGSERIAL PRIMARY KEY,
  "name" VARCHAR(255) UNIQUE NOT NULL,
  "description" TEXT,
  "price" NUMERIC(10,2) NOT NULL CHECK ("price" >= 0),
  "magical_property" BIGINT NOT NULL
);

CREATE TABLE "Inventory" (
  "id" BIGSERIAL PRIMARY KEY,
  "bean_id" BIGINT NOT NULL,
  "quantity" INTEGER NOT NULL CHECK ("quantity" >= 0)
);

CREATE TABLE "MagicalProperty" (
  "id" BIGSERIAL PRIMARY KEY,
  "name" VARCHAR(255) UNIQUE NOT NULL,
  "description" TEXT
);

CREATE TABLE "Users" (
  "id" BIGSERIAL PRIMARY KEY,
  "first_name" VARCHAR(100) NOT NULL,
  "last_name" VARCHAR(100) NOT NULL,
  "username" VARCHAR(100) UNIQUE NOT NULL,
  "hashed_password" VARCHAR(255) NOT NULL,
  "contact_id" BIGINT NOT NULL
);

CREATE TABLE "UserRole" (
  "id" BIGSERIAL PRIMARY KEY,
  "user_id" BIGINT NOT NULL,
  "role_id" BIGINT NOT NULL
);

CREATE TABLE "Roles" (
  "id" BIGSERIAL PRIMARY KEY,
  "role" VARCHAR(100) NOT NULL
);

CREATE TABLE "ContactInformation" (
  "id" BIGSERIAL PRIMARY KEY,
  "phone" VARCHAR(20) UNIQUE,
  "email" VARCHAR(255) UNIQUE,
  "address" TEXT
);

CREATE TABLE "Payment" (
  "id" BIGSERIAL PRIMARY KEY,
  "order_id" BIGINT NOT NULL,
  "payment_date" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  "amount" NUMERIC(10,2) NOT NULL CHECK ("amount" >= 0),
  "status_id" BIGINT NOT NULL
);

CREATE TABLE "PaymentStatus" (
  "id" BIGSERIAL PRIMARY KEY,
  "status" VARCHAR(100) NOT NULL
);

CREATE TABLE "Delivery" (
  "id" BIGSERIAL PRIMARY KEY,
  "order_id" BIGINT NOT NULL,
  "driver_id" BIGINT NOT NULL,
  "delivery_notes" TEXT
);

ALTER TABLE "Supplier" ADD FOREIGN KEY ("contact_id") REFERENCES "ContactInformation" ("id");

ALTER TABLE "Orders" ADD FOREIGN KEY ("user_id") REFERENCES "Users" ("id") ON DELETE CASCADE;
ALTER TABLE "Orders" ADD FOREIGN KEY ("payment_method_id") REFERENCES "PaymentMethod" ("id");
ALTER TABLE "Orders" ADD FOREIGN KEY ("order_status_id") REFERENCES "OrderStatus" ("id");
ALTER TABLE "Orders" ADD FOREIGN KEY ("supplier_id") REFERENCES "Supplier" ("id");
ALTER TABLE "Orders" ADD FOREIGN KEY ("order_type_id") REFERENCES "OrderType" ("id");

ALTER TABLE "OrderItem" ADD FOREIGN KEY ("order_id") REFERENCES "Orders" ("id") ON DELETE CASCADE;
ALTER TABLE "OrderItem" ADD FOREIGN KEY ("bean_id") REFERENCES "Bean" ("id");

ALTER TABLE "OrderHistory" ADD FOREIGN KEY ("order_id") REFERENCES "Orders" ("id") ON DELETE CASCADE;
ALTER TABLE "OrderHistory" ADD FOREIGN KEY ("order_status_id") REFERENCES "OrderStatus" ("id");

ALTER TABLE "Bean" ADD FOREIGN KEY ("magical_property") REFERENCES "MagicalProperty" ("id");

ALTER TABLE "Inventory" ADD FOREIGN KEY ("bean_id") REFERENCES "Bean" ("id");

ALTER TABLE "Users" ADD FOREIGN KEY ("contact_id") REFERENCES "ContactInformation" ("id");

ALTER TABLE "UserRole" ADD FOREIGN KEY ("user_id") REFERENCES "Users" ("id") ON DELETE CASCADE;
ALTER TABLE "UserRole" ADD FOREIGN KEY ("role_id") REFERENCES "Roles" ("id");

ALTER TABLE "Payment" ADD FOREIGN KEY ("order_id") REFERENCES "Orders" ("id") ON DELETE CASCADE;
ALTER TABLE "Payment" ADD FOREIGN KEY ("status_id") REFERENCES "PaymentStatus" ("id");

ALTER TABLE "Delivery" ADD FOREIGN KEY ("order_id") REFERENCES "Orders" ("id") ON DELETE CASCADE;
ALTER TABLE "Delivery" ADD FOREIGN KEY ("driver_id") REFERENCES "Users" ("id");