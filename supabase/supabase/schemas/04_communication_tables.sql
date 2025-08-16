CREATE TABLE notification (
    notification_id SERIAL PRIMARY KEY,
    appointment_id INTEGER REFERENCES appointment(appointment_id) ON DELETE SET NULL,
    citizen_id INTEGER REFERENCES app_user(user_id) ON DELETE SET NULL,
    type notification_type,
    message TEXT,
    send_via send_via_type,
    send_time TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE complaint (
    complaint_id SERIAL PRIMARY KEY,
    citizen_id INTEGER REFERENCES app_user(user_id) ON DELETE SET NULL,
    appointment_id INTEGER REFERENCES appointment(appointment_id) ON DELETE SET NULL,
    title VARCHAR(255),
    field TEXT,
    type TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE message (
    message_id SERIAL PRIMARY KEY,
    appointment_id INTEGER REFERENCES appointment(appointment_id) ON DELETE SET NULL,
    sender_id INTEGER REFERENCES app_user(user_id) ON DELETE SET NULL,
    receiver_id INTEGER REFERENCES app_user(user_id) ON DELETE SET NULL,
    message TEXT,
    send_time TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE feedback (
    feedback_id SERIAL PRIMARY KEY,
    appointment_id INTEGER REFERENCES appointment(appointment_id) ON DELETE SET NULL,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    review TEXT,
    submit_time TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
