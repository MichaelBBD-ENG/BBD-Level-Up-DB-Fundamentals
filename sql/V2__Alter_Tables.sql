-- Drop the many-to-many relationship table
DROP TABLE IF EXISTS "beans_magical_propeties";

-- Add magical_property_id column to beans for one-to-one relationship
ALTER TABLE "beans"
ADD COLUMN "magical_property_id" integer UNIQUE;

-- Set up the foreign key constraint to enforce the one-to-one relationship
ALTER TABLE "beans"
ADD CONSTRAINT fk_magical_property
FOREIGN KEY ("magical_property_id") REFERENCES "magical_properties"("id") ON DELETE CASCADE;

-- Remove rarity column from beans
ALTER TABLE "beans" DROP COLUMN "rarity";

-- Create the new address table
CREATE TABLE IF NOT EXISTS "address" (
  "id" integer PRIMARY KEY,
  "street" varchar NOT NULL,
  "city" varchar NOT NULL,
  "country" varchar NOT NULL,
  "postal_code" varchar NOT NULL
);

-- Remove the old address column from contact_information
ALTER TABLE "contact_information" DROP COLUMN "address";

-- Add the foreign key reference to the new address table
ALTER TABLE "contact_information"
ADD COLUMN "address_id" integer UNIQUE;

ALTER TABLE "contact_information"
ADD CONSTRAINT fk_address
FOREIGN KEY ("address_id") REFERENCES "address"("id") ON DELETE CASCADE;

