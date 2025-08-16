CREATE TABLE department (
    department_id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    description TEXT,
    email VARCHAR(100),
    phone_no VARCHAR(15),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE app_user (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(255),
    nic_no VARCHAR(16) UNIQUE,
    email VARCHAR(100) UNIQUE,
    phone_no VARCHAR(15),
    role user_role DEFAULT 'Citizen',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE document_type (
    doc_type_id SERIAL PRIMARY KEY,
    doc_type VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
