CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TYPE notification_type AS ENUM ('Confirmation', 'Reminder', 'Update');
CREATE TYPE send_via_type AS ENUM ('Email', 'SMS', 'Both');
CREATE TYPE user_role AS ENUM ('Citizen', 'Officer', 'Admin');
CREATE TYPE appointment_status AS ENUM ('Pending', 'Confirmed', 'Completed', 'Canceled', 'Absent');
CREATE TYPE verification_status AS ENUM ('Pending', 'Approved', 'Rejected');
CREATE TYPE timeslot_status AS ENUM ('Pending', 'Available');
