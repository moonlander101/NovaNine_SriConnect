
-- Enable pg_cron extension (requires superuser privileges)
-- This should be run separately by the database administrator
-- CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Schedule the function to run every Sunday at 11:59 PM
-- This generates timeslots for the upcoming week
-- The cron job runs weekly: every Sunday at 23:59
SELECT cron.schedule(
    'generate-weekly-timeslots',
    '59 23 * * 0',  -- Every Sunday at 23:59 (just before midnight)
    'SELECT generate_weekly_timeslots();'
);

-- Manual function to run the timeslot generation immediately (for testing)
CREATE OR REPLACE FUNCTION run_timeslot_generation_now()
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN generate_weekly_timeslots();
END;
$$;