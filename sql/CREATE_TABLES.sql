CREATE TABLE "contact_information" (
  "id" integer PRIMARY KEY,
  "phone" varchar,
  "email" varchar,
  "address" varchar
);

CREATE TABLE "users" (
  "id" integer PRIMARY KEY,
  "first_name" varchar,
  "last_name" varchar,
  "username" varchar,
  "hash" varchar,-- better to not reference this as a password
  "contact_id" integer, -- can a user have a null contact id ???
  FOREIGN KEY ("contact_id") REFERENCES "contact_information"("id") ON DELETE CASCADE
);

CREATE TYPE bean_rarity_enum_type AS ENUM ('MoreCommon', 'Common', 'LessCommon', 'Rare', 'MoreRare');

CREATE TABLE "beans" (
  "id" integer PRIMARY KEY,
  "name" varchar,
  "description" text,
  "price" money,
  "stock" integer,
  "rarity" bean_rarity_enum_type NOT NULL
);

CREATE TYPE user_roles_enum_type AS ENUM ('Customer', 'Employee');

CREATE TABLE "user_roles" (
  "id" integer PRIMARY KEY,
  "role" user_roles_enum_type NOT NULL,
  "user_id" integer,
  FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE
);

CREATE TABLE "suppliers" (
  "id" integer PRIMARY KEY,
  "name" varchar,
  "contact_id" integer,
  FOREIGN KEY ("contact_id") REFERENCES "contact_information"("id") ON DELETE CASCADE
);

CREATE TYPE order_status_enum_type AS ENUM ('Ordered', 'Dispatched', 'ReadyForCollection', 'Delivered', 'Collected');

CREATE TABLE "supplier_orders" (
  "id" integer PRIMARY KEY,
  "order_date" date,
  "supplier_id" integer,
  "order_status" order_status_enum_type NOT NULL,
  "user_id" integer,
  FOREIGN KEY ("supplier_id") REFERENCES "suppliers"("id") ON DELETE CASCADE,
  FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE
);

CREATE TABLE "supplier_order_items" (
  "id" integer PRIMARY KEY,
  "quantity" integer,
  "supplier_order_id" integer,
  "bean_id" integer,
  FOREIGN KEY ("supplier_order_id") REFERENCES "supplier_orders"("id") ON DELETE CASCADE,
  FOREIGN KEY ("bean_id") REFERENCES "beans"("id") ON DELETE CASCADE
);

CREATE TYPE payment_enum_type AS ENUM (
    -- credit cards and debit cards
    'Visa', 'MasterCard', 'AmericanExpress', 'Discover',
    -- digital
    'ApplePay', 'GooglePay', 'SamsungPay', 'PayPal', 'Venmo',
    -- buy now pay later
    'Klarna', 'Afterpay', 'Affirm', 'Zip',
    -- crypto
    'Bitcoin(BTC)', 'Ethereum(ETH)', 'Litecoin(LTC)'
);

CREATE TABLE "orders" (
  "id" integer PRIMARY KEY,
  "order_date" date,
  "total_price" money, -- want to be calculated dynamically
  "user_id" integer,
  "order_status" order_status_enum_type NOT NULL,
  "payment_method" payment_enum_type NOT NULL,
  FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE
);

CREATE TABLE "order_items" (
  "id" integer PRIMARY KEY,
  "quantity" integer,
  "price" money, -- -- want to be calculated dynamically
  "bean_id" integer,
  "order_id" integer,
  FOREIGN KEY ("bean_id") REFERENCES "beans"("id") ON DELETE CASCADE,
  FOREIGN KEY ("order_id") REFERENCES "orders"("id") ON DELETE CASCADE
);

CREATE TABLE "magical_properties" (
  "id" integer PRIMARY KEY,
  "name" varchar,
  "description" text
);

CREATE TABLE "beans_magical_propeties" (
  "id" integer PRIMARY KEY,
  "effect_duration" integer,
  "bean_id" integer,
  "magical_properties_id" integer,
  FOREIGN KEY ("bean_id") REFERENCES "beans"("id") ON DELETE CASCADE,
  FOREIGN KEY ("magical_properties_id") REFERENCES "magical_properties"("id") ON DELETE CASCADE
);

COMMENT ON COLUMN "orders"."total_price" IS 'want to be calculated';

COMMENT ON COLUMN "order_items"."price" IS 'want to be calculated';