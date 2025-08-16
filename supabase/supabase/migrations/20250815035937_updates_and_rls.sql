create type "public"."timeslot_status" as enum ('Pending', 'Available');

-- Safe ENUM migration: Handle "Waited" → "Absent" conversion
-- Step 1: Create new enum type
create type "public"."appointment_status_new" as enum ('Pending', 'Confirmed', 'Completed', 'Canceled', 'Absent');

-- Step 2: Add temporary column with new enum type
alter table "public"."appointment" add column "status_new" appointment_status_new;

-- Step 3: Migrate data with safe conversion (handle "Waited" → "Absent")
UPDATE "public"."appointment" 
SET "status_new" = CASE 
    WHEN "status"::text = 'Pending' THEN 'Pending'::appointment_status_new
    WHEN "status"::text = 'Confirmed' THEN 'Confirmed'::appointment_status_new
    WHEN "status"::text = 'Completed' THEN 'Completed'::appointment_status_new
    WHEN "status"::text = 'Canceled' THEN 'Canceled'::appointment_status_new
    WHEN "status"::text = 'Cancelled' THEN 'Canceled'::appointment_status_new
    WHEN "status"::text = 'Waited' THEN 'Absent'::appointment_status_new  -- Safe rename
    WHEN "status"::text = 'Absent' THEN 'Absent'::appointment_status_new
    ELSE 'Pending'::appointment_status_new  -- Fallback for any unknown values
END;

-- Step 4: Drop old column
alter table "public"."appointment" drop column "status";

-- Step 5: Rename new column to original name
alter table "public"."appointment" rename column "status_new" to "status";

-- Step 6: Set default value
alter table "public"."appointment" alter column "status" set default 'Pending'::appointment_status_new;

-- Step 7: Drop old enum type and rename new one
drop type "public"."appointment_status";
alter type "public"."appointment_status_new" rename to "appointment_status";

alter table "public"."app_user" enable row level security;

alter table "public"."appointment" enable row level security;

alter table "public"."appointment_document" enable row level security;

alter table "public"."complaint" enable row level security;

alter table "public"."department" enable row level security;

alter table "public"."document_type" enable row level security;

alter table "public"."feedback" enable row level security;

alter table "public"."message" enable row level security;

alter table "public"."notification" enable row level security;

alter table "public"."officer_department" enable row level security;

alter table "public"."required_doc_for_service" enable row level security;

alter table "public"."service" enable row level security;

-- Safe column migration for time_slot table
-- Step 1: Add the new columns first
alter table "public"."time_slot" add column "remaining_appointments" integer;
alter table "public"."time_slot" add column "status" timeslot_status default 'Pending'::timeslot_status;

-- Step 2: Copy data from old column to new column
UPDATE "public"."time_slot" 
SET "remaining_appointments" = COALESCE("max_appointments", 1);

-- Step 3: Set default value for remaining_appointments
alter table "public"."time_slot" alter column "remaining_appointments" set default 1;

-- Step 4: Make remaining_appointments NOT NULL
alter table "public"."time_slot" alter column "remaining_appointments" set not null;

-- Step 5: Now drop the old column
alter table "public"."time_slot" drop column "max_appointments";

alter table "public"."time_slot" enable row level security;

alter table "public"."user_auth" enable row level security;

alter table "public"."user_document" enable row level security;


