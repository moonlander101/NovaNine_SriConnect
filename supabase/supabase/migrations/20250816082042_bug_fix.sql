set check_function_bodies = off;

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
    
    RETURN json_build_object(
        'success', true,
        'message', 'Appointment cancelled successfully'
    );
EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Database error: ' || SQLERRM
        );
END;
$function$
;


