-- PostgreSQL Functions for Service Booking System

-- Function to create appointment and update remaining appointments atomically
CREATE OR REPLACE FUNCTION create_appointment_with_slot_update(
    p_citizen_id INTEGER,
    p_officer_id INTEGER DEFAULT NULL,
    p_service_id INTEGER,
    p_timeslot_id INTEGER,
    p_status appointment_status DEFAULT 'Pending'
) 
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_appointment_id INTEGER;
    v_remaining_appointments INTEGER;
    v_timeslot_status timeslot_status;
    v_service_id_check INTEGER;
    v_existing_appointment_count INTEGER;
    v_result JSON;
BEGIN
    -- Check if timeslot exists and get its details
    SELECT remaining_appointments, status, service_id 
    INTO v_remaining_appointments, v_timeslot_status, v_service_id_check
    FROM time_slot 
    WHERE timeslot_id = p_timeslot_id;
    
    -- Validate timeslot exists
    IF NOT FOUND THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Timeslot not found'
        );
    END IF;
    
    -- Validate timeslot is available
    IF v_timeslot_status != 'Available' THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Timeslot is not available for booking'
        );
    END IF;
    
    -- Validate remaining appointments
    IF v_remaining_appointments <= 0 THEN
        RETURN json_build_object(
            'success', false,
            'error', 'No remaining appointments available for this timeslot'
        );
    END IF;
    
    -- Validate service matches timeslot
    IF v_service_id_check != p_service_id THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Service ID does not match the timeslot service'
        );
    END IF;
    
    -- Check if citizen already has an active appointment for this timeslot
    SELECT COUNT(*)
    INTO v_existing_appointment_count
    FROM appointment 
    WHERE citizen_id = p_citizen_id 
    AND timeslot_id = p_timeslot_id 
    AND status IN ('Pending', 'Confirmed');
    
    IF v_existing_appointment_count > 0 THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Citizen already has an active appointment for this timeslot'
        );
    END IF;
    
    -- Create the appointment
    INSERT INTO appointment (
        citizen_id, 
        officer_id, 
        service_id, 
        timeslot_id, 
        status
    )
    VALUES (
        p_citizen_id,
        p_officer_id,
        p_service_id,
        p_timeslot_id,
        p_status
    )
    RETURNING appointment_id INTO v_appointment_id;
    
    -- Update remaining appointments count
    UPDATE time_slot 
    SET remaining_appointments = remaining_appointments - 1
    WHERE timeslot_id = p_timeslot_id;
    
    -- Return success with appointment details
    SELECT json_build_object(
        'success', true,
        'appointment_id', v_appointment_id,
        'message', 'Appointment created successfully'
    ) INTO v_result;
    
    RETURN v_result;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Return error details
        RETURN json_build_object(
            'success', false,
            'error', 'Database error: ' || SQLERRM
        );
END;
$$;

-- Function to get appointment with related data
CREATE OR REPLACE FUNCTION get_appointment_with_details(p_appointment_id INTEGER)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_result JSON;
BEGIN
    SELECT json_build_object(
        'appointment_id', a.appointment_id,
        'citizen_id', a.citizen_id,
        'officer_id', a.officer_id,
        'service_id', a.service_id,
        'timeslot_id', a.timeslot_id,
        'status', a.status,
        'created_at', a.created_at,
        'updated_at', a.updated_at,
        'service', json_build_object(
            'title', s.title,
            'department', json_build_object(
                'title', d.title
            )
        ),
        'timeslot', json_build_object(
            'start_time', ts.start_time,
            'end_time', ts.end_time
        ),
        'citizen', json_build_object(
            'full_name', cu.full_name,
            'email', cu.email
        ),
        'officer', CASE 
            WHEN a.officer_id IS NOT NULL THEN 
                json_build_object(
                    'full_name', ou.full_name,
                    'email', ou.email
                )
            ELSE NULL
        END
    )
    INTO v_result
    FROM appointment a
    LEFT JOIN service s ON a.service_id = s.service_id
    LEFT JOIN department d ON s.department_id = d.department_id
    LEFT JOIN time_slot ts ON a.timeslot_id = ts.timeslot_id
    LEFT JOIN app_user cu ON a.citizen_id = cu.user_id
    LEFT JOIN app_user ou ON a.officer_id = ou.user_id
    WHERE a.appointment_id = p_appointment_id;
    
    IF v_result IS NULL THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Appointment not found'
        );
    END IF;
    
    RETURN json_build_object(
        'success', true,
        'data', v_result
    );
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'success', false,
            'error', 'Database error: ' || SQLERRM
        );
END;
$$;

-- Function to cancel appointment and restore remaining appointments
CREATE OR REPLACE FUNCTION cancel_appointment_with_slot_update(p_appointment_id INTEGER)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
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
$$;
