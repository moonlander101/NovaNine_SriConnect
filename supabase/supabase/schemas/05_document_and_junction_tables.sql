CREATE TABLE officer_department (
    officer_id INTEGER REFERENCES app_user(user_id) ON DELETE CASCADE,
    department_id INTEGER REFERENCES department(department_id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    PRIMARY KEY (officer_id, department_id)
);

CREATE TABLE user_document (
    user_doc_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES app_user(user_id) ON DELETE CASCADE,
    doc_type_id INTEGER REFERENCES document_type(doc_type_id) ON DELETE CASCADE,
    file_path VARCHAR(500),
    upload_time TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    verification_status verification_status DEFAULT 'Pending'
);

CREATE TABLE required_doc_for_service (
    service_id INTEGER REFERENCES service(service_id) ON DELETE CASCADE,
    doc_type_id INTEGER REFERENCES document_type(doc_type_id) ON DELETE CASCADE,
    is_mandatory BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    PRIMARY KEY (service_id, doc_type_id)
);

CREATE TABLE appointment_document (
    appointment_doc_id SERIAL PRIMARY KEY,
    appointment_id INTEGER REFERENCES appointment(appointment_id) ON DELETE CASCADE,
    file_path VARCHAR(500),
    doc_type INTEGER REFERENCES document_type(doc_type_id) ON DELETE CASCADE,
    uploaded_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    verification_status verification_status DEFAULT 'Pending',
    review TEXT
);

CREATE TABLE user_auth (
    user_id INTEGER REFERENCES app_user(user_id) ON DELETE CASCADE,
    auth_user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, auth_user_id),
    UNIQUE(user_id),
    UNIQUE(auth_user_id)
);