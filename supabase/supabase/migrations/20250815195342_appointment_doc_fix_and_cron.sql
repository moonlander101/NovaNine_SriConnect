alter table "public"."app_user" drop column "password";

alter table "public"."appointment_document" alter column "doc_type" set data type integer using 1;

alter table "public"."time_slot" alter column "remaining_appointments" drop not null;

alter table "public"."appointment_document" add constraint "appointment_document_doc_type_fkey" FOREIGN KEY (doc_type) REFERENCES document_type(doc_type_id) ON DELETE CASCADE not valid;

alter table "public"."appointment_document" validate constraint "appointment_document_doc_type_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.generate_weekly_timeslots()
 RETURNS json
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    v_service_record RECORD;
    v_current_date DATE;
    v_week_start DATE;
    v_day_offset INTEGER;
    v_hour INTEGER;
    v_start_time TIMESTAMP WITH TIME ZONE;
    v_end_time TIMESTAMP WITH TIME ZONE;
    v_slots_created INTEGER := 0;
    v_total_services INTEGER := 0;
BEGIN
    -- Calculate the start of next week (Monday)
    v_current_date := CURRENT_DATE;
    v_week_start := v_current_date + INTERVAL '1 week' - INTERVAL '1 day' * EXTRACT(DOW FROM v_current_date + INTERVAL '1 week') + INTERVAL '1 day';
    
    -- Count total services for reporting
    SELECT COUNT(*) INTO v_total_services FROM service WHERE service_id IS NOT NULL;
    
    -- Loop through each service
    FOR v_service_record IN 
        SELECT service_id FROM service WHERE service_id IS NOT NULL
    LOOP
        -- Generate slots for 7 days (Monday to Sunday)
        FOR v_day_offset IN 0..6 LOOP
            -- Generate slots from 8AM to 5PM (9 slots total)
            FOR v_hour IN 8..16 LOOP
                -- Calculate start and end times
                v_start_time := (v_week_start + INTERVAL '1 day' * v_day_offset + INTERVAL '1 hour' * v_hour) AT TIME ZONE 'UTC';
                v_end_time := v_start_time + INTERVAL '1 hour';
                
                -- Check if this timeslot already exists for this service
                IF NOT EXISTS (
                    SELECT 1 FROM time_slot 
                    WHERE service_id = v_service_record.service_id 
                    AND start_time = v_start_time 
                    AND end_time = v_end_time
                ) THEN
                    -- Insert the timeslot with 'Pending' status (admin needs to activate)
                    INSERT INTO time_slot (
                        service_id, 
                        start_time, 
                        end_time, 
                        remaining_appointments, 
                        status
                    ) VALUES (
                        v_service_record.service_id,
                        v_start_time,
                        v_end_time,
                        1, -- Default 1 appointment per slot
                        'Pending' -- Admin needs to set to 'Available'
                    );
                    
                    v_slots_created := v_slots_created + 1;
                END IF;
            END LOOP;
        END LOOP;
    END LOOP;
    
    -- Return success response with statistics
    RETURN json_build_object(
        'success', true,
        'message', 'Weekly timeslots generated successfully',
        'slots_created', v_slots_created,
        'services_processed', v_total_services,
        'week_start_date', v_week_start::text
    );
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Failed to generate timeslots: ' || SQLERRM
        );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.run_timeslot_generation_now()
 RETURNS json
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    RETURN generate_weekly_timeslots();
END;
$function$
;

CREATE OR REPLACE FUNCTION public.cancel_appointment_with_slot_update(p_appointment_id integer)
 RETURNS json
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    v_timeslot_id INTEGER;
    v_appointment_status appointment_status;
    v_result JSON;
BEGIN
    -- Get appointment details
    SELECT timeslot_id, status
    INTO v_timeslot_id, v_appointment_status
    FROM appointment
    WHERE appointment_id = p_appointment_id;
    
    -- Validate appointment exists
    IF NOT FOUND THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Appointment not found'
        );
    END IF;
    
    -- Check if appointment can be cancelled
    IF v_appointment_status IN ('Completed', 'Canceled') THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Appointment cannot be cancelled - already ' || v_appointment_status
        );
    END IF;
    
    -- Update appointment status to Canceled
    UPDATE appointment 
    SET status = 'Canceled', updated_at = NOW()
    WHERE appointment_id = p_appointment_id;
    
    -- Restore remaining appointments count
    UPDATE time_slot 
    SET remaining_appointments = remaining_appointments + 1
    WHERE timeslot_id = v_timeslot_id;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Database error: ' || SQLERRM
        );
END;
$function$
;


