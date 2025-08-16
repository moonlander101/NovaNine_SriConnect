CREATE TABLE service (
    service_id SERIAL PRIMARY KEY,
    department_id INTEGER REFERENCES department(department_id) ON DELETE SET NULL,
    title VARCHAR(255),
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE time_slot (
    timeslot_id SERIAL PRIMARY KEY,
    service_id INTEGER REFERENCES service(service_id) ON DELETE SET NULL,
    start_time TIMESTAMP WITH TIME ZONE,
    end_time TIMESTAMP WITH TIME ZONE,
    remaining_appointments INTEGER DEFAULT 1,
    status timeslot_status DEFAULT 'Pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE appointment (
    appointment_id SERIAL PRIMARY KEY,
    officer_id INTEGER REFERENCES app_user(user_id) ON DELETE SET NULL,
    citizen_id INTEGER REFERENCES app_user(user_id) ON DELETE SET NULL,
    service_id INTEGER REFERENCES service(service_id) ON DELETE SET NULL,
    timeslot_id INTEGER REFERENCES time_slot(timeslot_id) ON DELETE SET NULL,
    status appointment_status DEFAULT 'Pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
