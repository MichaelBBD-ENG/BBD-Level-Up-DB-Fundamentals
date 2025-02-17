-- Remove foreign key reference from contact_information
ALTER TABLE "contact_information" DROP CONSTRAINT IF EXISTS fk_address;
ALTER TABLE "contact_information" DROP COLUMN IF EXISTS "address_id";

-- Restore old address column in contact_information
ALTER TABLE "contact_information" ADD COLUMN "address" varchar;

-- Drop the new address table
DROP TABLE IF EXISTS "address";

-- Restore rarity column in beans
ALTER TABLE "beans" ADD COLUMN "rarity" bean_rarity_enum_type NOT NULL;

-- Remove foreign key constraint and magical_property_id column from beans
ALTER TABLE "beans" DROP CONSTRAINT IF EXISTS fk_magical_property;
ALTER TABLE "beans" DROP COLUMN IF EXISTS "magical_property_id";

-- Restore the many-to-many relationship table
CREATE TABLE IF NOT EXISTS "beans_magical_propeties" (
  "id" integer PRIMARY KEY,
  "effect_duration" integer,
  "bean_id" integer,
  "magical_properties_id" integer,
  FOREIGN KEY ("bean_id") REFERENCES "beans"("id") ON DELETE CASCADE,
  FOREIGN KEY ("magical_properties_id") REFERENCES "magical_properties"("id") ON DELETE CASCADE
);
