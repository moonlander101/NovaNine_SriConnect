-- This file contains SQL statements that will be executed after the schema is created
-- Use this file to insert initial data into your database

-- ============================================================================
-- SEED DATA FOR SRI CONNECT GOVERNMENT SERVICES PLATFORM
-- ============================================================================

-- Clear existing data (in dependency order)
TRUNCATE appointment_document, user_document, required_doc_for_service, 
         officer_department, user_auth, feedback, message, complaint, 
         notification, appointment, time_slot, service, app_user, 
         document_type, department RESTART IDENTITY CASCADE;

-- ============================================================================
-- 1. DEPARTMENTS
-- ============================================================================
INSERT INTO department (title, description, email, phone_no) VALUES
('Education Department', 'Handles educational services, transcripts, and certifications', 'education@gov.lk', '0112345672'),
('Transport Department', 'Vehicle registration, driving licenses, and transport permits', 'transport@gov.lk', '0112345673'),
('Revenue Department', 'Tax services, revenue collection, and tax clearance certificates', 'revenue@gov.lk', '0112345674'),
('Registration Department', 'Birth certificates, marriage certificates, and vital records', 'registration@gov.lk', '0112345675'),
('Immigration Department', 'Passport services and immigration documentation', 'immigration@gov.lk', '0112345676');

-- ============================================================================
-- 2. DOCUMENT TYPES
-- ============================================================================
INSERT INTO document_type (doc_type, description) VALUES
('National ID', 'National Identity Card - Primary identification document'),
('Birth Certificate', 'Official birth certificate issued by registrar'),
('Marriage Certificate', 'Official marriage certificate'),
('Passport', 'Valid Sri Lankan passport'),
('Utility Bill', 'Recent utility bill for address verification (within 3 months)'),
('Medical Report', 'Medical examination report from certified physician'),
('Educational Certificate', 'Educational qualification certificate or diploma'),
('Police Report', 'Police clearance certificate'),
('Income Certificate', 'Certificate of income or employment'),
('Property Deed', 'Property ownership documentation'),
('Bank Statement', 'Recent bank statement for financial verification'),
('Divorce Certificate', 'Legal divorce decree if applicable');

-- ============================================================================
-- 3. USERS (Admin, Officers, Citizens)
-- ============================================================================
INSERT INTO app_user (full_name, nic_no, email, phone_no, password, role) VALUES
-- System Admin
('System Administrator', '200012345678', 'admin@sriconnect.gov.lk', '0771234567', 'hashed_password_admin', 'Admin'),

-- Department Officers
('Prof. Kamal Silva', '197803456789', 'kamal.silva@education.gov.lk', '0771234569', 'hashed_password_2', 'Officer'),
('Eng. Nimal Fernando', '198209876543', 'nimal.fernando@transport.gov.lk', '0771234570', 'hashed_password_3', 'Officer'),
('CA. Priya Rajapaksa', '197512345678', 'priya.rajapaksa@revenue.gov.lk', '0771234571', 'hashed_password_4', 'Officer'),
('Mrs. Kumari Wickrama', '198106789012', 'kumari.wickrama@registration.gov.lk', '0771234572', 'hashed_password_5', 'Officer'),
('Mr. Sunil Jayawardena', '197701234567', 'sunil.jayawardena@immigration.gov.lk', '0771234573', 'hashed_password_6', 'Officer'),

-- Additional Officers for workload distribution
('Mr. Ruwan Gunaratne', '198505432109', 'ruwan.gunaratne@transport.gov.lk', '0771234575', 'hashed_password_8', 'Officer'),

-- Citizens
('John Doe', '199012345678', 'john.doe@email.com', '0771234576', 'hashed_password_c1', 'Citizen'),
('Jane Smith', '199205432109', 'jane.smith@email.com', '0771234577', 'hashed_password_c2', 'Citizen'),
('Raj Patel', '198712345678', 'raj.patel@email.com', '0771234578', 'hashed_password_c3', 'Citizen'),
('Sara Johnson', '199507654321', 'sara.johnson@email.com', '0771234579', 'hashed_password_c4', 'Citizen'),
('Mike Brown', '198909876543', 'mike.brown@email.com', '0771234580', 'hashed_password_c5', 'Citizen'),
('Lisa Wong', '199311111111', 'lisa.wong@email.com', '0771234581', 'hashed_password_c6', 'Citizen'),
('David Chen', '199022222222', 'david.chen@email.com', '0771234582', 'hashed_password_c7', 'Citizen'),
('Maria Rodriguez', '199133333333', 'maria.rodriguez@email.com', '0771234583', 'hashed_password_c8', 'Citizen');

-- ============================================================================
-- 4. OFFICER-DEPARTMENT MAPPINGS
-- ============================================================================
INSERT INTO officer_department (officer_id, department_id) VALUES
-- Education Department Officers  
(2, 1),
-- Transport Department Officers
(3, 2), (7, 2),
-- Revenue Department Officers
(4, 3),
-- Registration Department Officers
(5, 4),
-- Immigration Department Officers
(6, 5);

-- ============================================================================
-- 5. SERVICES
-- ============================================================================
INSERT INTO service (department_id, title, description) VALUES
-- Education Department Services
(1, 'Birth Certificate Issuance', 'Official birth certificate for educational enrollment'),
(1, 'Educational Transcript Request', 'Official academic transcripts and certificates'),
(1, 'School Registration', 'Registration for new educational institutions'),
(1, 'Teacher Certification', 'Professional certification for teaching staff'),

-- Transport Department Services
(2, 'Driving License Application', 'New driving license application and testing'),
(2, 'Vehicle Registration', 'Registration of new or transferred vehicles'),
(2, 'License Renewal', 'Renewal of existing driving licenses'),
(2, 'Vehicle Transfer', 'Transfer of vehicle ownership'),

-- Revenue Department Services
(3, 'Tax Clearance Certificate', 'Certificate confirming tax compliance status'),
(3, 'Business Registration', 'Registration of new business entities'),
(3, 'VAT Registration', 'Value Added Tax registration for businesses'),

-- Registration Department Services
(4, 'Birth Certificate', 'Official birth registration and certificate issuance'),
(4, 'Marriage Certificate', 'Marriage registration and certificate issuance'),
(4, 'Death Certificate', 'Death registration and certificate issuance'),

-- Immigration Department Services
(5, 'Passport Application', 'New passport application for citizens'),
(5, 'Passport Renewal', 'Renewal of existing passports'),
(5, 'Emergency Travel Document', 'Emergency travel documentation for urgent travel');

-- ============================================================================
-- 6. REQUIRED DOCUMENTS FOR SERVICES
-- ============================================================================
INSERT INTO required_doc_for_service (service_id, doc_type_id, is_mandatory) VALUES
-- Birth Certificate Issuance (service_id: 1)
(1, 1, true),   -- National ID (of parent/guardian)

-- Educational Transcript (service_id: 2)
(2, 1, true),   -- National ID
(2, 7, true),   -- Educational Certificate

-- School Registration (service_id: 3)
(3, 1, true),   -- National ID
(3, 9, true),   -- Income Certificate
(3, 10, true),  -- Property Deed

-- Teacher Certification (service_id: 4)
(4, 1, true),   -- National ID
(4, 7, true),   -- Educational Certificate
(4, 8, true),   -- Police Report

-- Driving License Application (service_id: 5)
(5, 1, true),   -- National ID
(5, 6, true),   -- Medical Report
(5, 5, true),   -- Utility Bill

-- Vehicle Registration (service_id: 6)
(6, 1, true),  -- National ID
(6, 9, true),  -- Income Certificate
(6, 11, true), -- Bank Statement

-- License Renewal (service_id: 7)
(7, 1, true),  -- National ID
(7, 6, false), -- Medical Report (optional for certain renewals)

-- Vehicle Transfer (service_id: 8)
(8, 1, true),  -- National ID
(8, 11, true), -- Bank Statement

-- Tax Clearance Certificate (service_id: 9)
(9, 1, true),  -- National ID
(9, 9, true),  -- Income Certificate
(9, 11, true), -- Bank Statement

-- Business Registration (service_id: 10)
(10, 1, true),  -- National ID
(10, 10, true), -- Property Deed
(10, 11, true), -- Bank Statement

-- VAT Registration (service_id: 11)
(11, 1, true),  -- National ID
(11, 9, true),  -- Income Certificate
(11, 11, true), -- Bank Statement

-- Birth Certificate (service_id: 12)
(12, 1, true),  -- National ID (of parent)
(12, 3, false), -- Marriage Certificate (if applicable)

-- Marriage Certificate (service_id: 13)
(13, 1, true),  -- National ID
(13, 2, true),  -- Birth Certificate
(13, 12, false), -- Divorce Certificate (if applicable)

-- Death Certificate (service_id: 14)
(14, 1, true),  -- National ID (of deceased or next of kin)
(14, 6, true),  -- Medical Report

-- Passport Application (service_id: 15)
(15, 1, true),  -- National ID
(15, 2, true),  -- Birth Certificate
(15, 5, true),  -- Utility Bill

-- Passport Renewal (service_id: 16)
(16, 1, true),  -- National ID
(16, 4, true),  -- Current Passport

-- Emergency Travel Document (service_id: 17)
(17, 1, true),  -- National ID
(17, 8, true);  -- Police Report

-- ============================================================================
-- 7. TIME SLOTS (Next 30 days)
-- ============================================================================
INSERT INTO time_slot (service_id, start_time, end_time, remaining_appointments, status) VALUES
-- Education Department Time Slots
(1, '2025-08-17 10:00:00+05:30', '2025-08-17 11:00:00+05:30', 8, 'Available'),
(1, '2025-08-17 11:00:00+05:30', '2025-08-17 12:00:00+05:30', 8, 'Available'),
(2, '2025-08-18 09:00:00+05:30', '2025-08-18 10:00:00+05:30', 6, 'Available'),
(2, '2025-08-18 10:00:00+05:30', '2025-08-18 11:00:00+05:30', 6, 'Available'),

-- Transport Department Time Slots
(5, '2025-08-19 08:00:00+05:30', '2025-08-19 12:00:00+05:30', 15, 'Available'),
(6, '2025-08-19 13:00:00+05:30', '2025-08-19 16:00:00+05:30', 12, 'Available'),
(7, '2025-08-20 09:00:00+05:30', '2025-08-20 11:00:00+05:30', 10, 'Available'),
(8, '2025-08-20 14:00:00+05:30', '2025-08-20 16:00:00+05:30', 8, 'Available'),

-- Revenue Department Time Slots
(9, '2025-08-21 10:00:00+05:30', '2025-08-21 12:00:00+05:30', 20, 'Available'),
(10, '2025-08-21 13:00:00+05:30', '2025-08-21 15:00:00+05:30', 15, 'Available'),
(11, '2025-08-22 10:00:00+05:30', '2025-08-22 12:00:00+05:30', 12, 'Available'),

-- Registration Department Time Slots
(12, '2025-08-23 09:00:00+05:30', '2025-08-23 12:00:00+05:30', 25, 'Available'),
(13, '2025-08-23 14:00:00+05:30', '2025-08-23 16:00:00+05:30', 10, 'Available'),
(14, '2025-08-24 10:00:00+05:30', '2025-08-24 12:00:00+05:30', 15, 'Available'),

-- Immigration Department Time Slots
(15, '2025-08-25 09:00:00+05:30', '2025-08-25 12:00:00+05:30', 30, 'Available'),
(16, '2025-08-25 13:00:00+05:30', '2025-08-25 16:00:00+05:30', 20, 'Available'),
(17, '2025-08-26 10:00:00+05:30', '2025-08-26 12:00:00+05:30', 5, 'Available');

-- ============================================================================
-- 8. APPOINTMENTS (Current and upcoming)
-- ============================================================================
INSERT INTO appointment (citizen_id, officer_id, service_id, timeslot_id, status) VALUES
-- Current Appointments (Citizens: 8-15, Officers: 2-7)
(8, 2, 1, 1, 'Confirmed'),    -- John Doe -> Prof. Kamal Silva (Education)
(9, 2, 2, 3, 'Pending'),      -- Jane Smith -> Prof. Kamal Silva (Education)
(10, 3, 5, 5, 'Confirmed'),   -- Raj Patel -> Eng. Nimal Fernando (Transport)
(11, 7, 6, 6, 'Pending'),     -- Sara Johnson -> Mr. Ruwan Gunaratne (Transport)

-- Upcoming Appointments  
(12, 4, 9, 9, 'Confirmed'),   -- Mike Brown -> CA. Priya Rajapaksa (Revenue)
(13, 4, 10, 10, 'Pending'),   -- Lisa Wong -> CA. Priya Rajapaksa (Revenue)
(14, 5, 12, 12, 'Confirmed'), -- David Chen -> Mrs. Kumari Wickrama (Registration)
(15, 5, 13, 13, 'Pending'),   -- Maria Rodriguez -> Mrs. Kumari Wickrama (Registration)

-- Immigration Appointments
(8, 6, 15, 15, 'Confirmed'),  -- John Doe -> Mr. Sunil Jayawardena (Immigration)
(9, 6, 16, 16, 'Pending');    -- Jane Smith -> Mr. Sunil Jayawardena (Immigration)

-- ============================================================================
-- 9. SAMPLE USER DOCUMENTS
-- ============================================================================
INSERT INTO user_document (user_id, doc_type_id, file_path, verification_status) VALUES
-- John Doe documents (user_id: 8)
(8, 1, '/documents/users/8/national_id.pdf', 'Approved'),
(8, 2, '/documents/users/8/birth_certificate.pdf', 'Approved'),

-- Jane Smith documents (user_id: 9)
(9, 1, '/documents/users/9/national_id.pdf', 'Approved'),
(9, 7, '/documents/users/9/degree_certificate.pdf', 'Approved'),
(9, 6, '/documents/users/9/medical_report.pdf', 'Approved'),

-- Raj Patel documents (user_id: 10)
(10, 1, '/documents/users/10/national_id.pdf', 'Approved'),
(10, 6, '/documents/users/10/medical_report.pdf', 'Pending'),
(10, 5, '/documents/users/10/utility_bill.pdf', 'Approved'),

-- Sara Johnson documents (user_id: 11)
(11, 1, '/documents/users/11/national_id.pdf', 'Approved'),
(11, 9, '/documents/users/11/income_certificate.pdf', 'Approved'),
(11, 11, '/documents/users/11/bank_statement.pdf', 'Approved');

-- ============================================================================
-- 10. SAMPLE APPOINTMENT DOCUMENTS
-- ============================================================================
INSERT INTO appointment_document (appointment_id, file_path, doc_type, verification_status, review) VALUES
(1, '/documents/appointments/1/application_form.pdf', 'Application Form', 'Approved', 'All documents verified successfully'),
(2, '/documents/appointments/2/transcript_request.pdf', 'Transcript Request', 'Approved', 'Academic records verified'),
(3, '/documents/appointments/3/license_application.pdf', 'License Application', 'Pending', 'Under review'),
(4, '/documents/appointments/4/tax_forms.pdf', 'Tax Declaration', 'Approved', 'Tax compliance confirmed'),
(5, '/documents/appointments/5/birth_registration.pdf', 'Birth Registration', 'Approved', 'Registration completed successfully');

-- ============================================================================
-- 11. SAMPLE NOTIFICATIONS
-- ============================================================================
INSERT INTO notification (appointment_id, citizen_id, type, message, send_via, send_time) VALUES
(1, 8, 'Confirmation', 'Your Birth Certificate Issuance appointment has been confirmed for 2025-08-17 at 10:00 AM', 'Both', '2025-08-16 10:00:00+05:30'),
(2, 9, 'Confirmation', 'Your Educational Transcript Request appointment is confirmed for 2025-08-18 at 09:00 AM', 'Email', '2025-08-16 11:00:00+05:30'),
(3, 10, 'Reminder', 'Reminder: Your Driving License appointment is tomorrow at 08:00 AM. Please bring all required documents.', 'SMS', '2025-08-18 18:00:00+05:30'),
(4, 11, 'Confirmation', 'Your Vehicle Registration appointment is confirmed for 2025-08-19 at 13:00 PM', 'Both', '2025-08-16 14:00:00+05:30'),
(5, 12, 'Update', 'Your Tax Clearance Certificate has been processed successfully', 'Both', '2025-08-16 16:00:00+05:30');

-- ============================================================================
-- 12. SAMPLE MESSAGES
-- ============================================================================
INSERT INTO message (appointment_id, sender_id, receiver_id, message) VALUES
(1, 2, 8, 'Please ensure you bring the original birth documentation along with the photocopies.'),
(1, 8, 2, 'Thank you for the information. I will bring all required documents.'),
(2, 2, 9, 'Your educational transcript request is being processed. You will receive confirmation within 3 working days.'),
(3, 3, 10, 'Your driving test is scheduled for 08:00 AM. Please arrive 30 minutes early with medical certificate.'),
(4, 7, 11, 'All your vehicle registration documents have been verified. Registration will be completed after the appointment.');

-- ============================================================================
-- 13. SAMPLE COMPLAINTS
-- ============================================================================
INSERT INTO complaint (citizen_id, appointment_id, title, field, type) VALUES
(10, 3, 'Long waiting time', 'Service Quality', 'Process Delay'),
(8, 1, 'Unclear document requirements', 'Information', 'Communication Issue'),
(9, 2, 'Officer was not available at scheduled time', 'Staff Availability', 'Scheduling Issue');

-- ============================================================================
-- 14. SAMPLE FEEDBACK
-- ============================================================================
INSERT INTO feedback (appointment_id, rating, review) VALUES
(1, 5, 'Excellent service! The university certificate verification process was smooth and the staff was very helpful.'),
(3, 4, 'Good service overall for driving license application, but the waiting time could be improved.'),
(2, 5, 'Very professional service for school transfer. All documents were processed efficiently.');

-- ============================================================================
-- END OF SEED DATA
-- ============================================================================

-- Display summary of inserted data
SELECT 
    'Departments' as table_name, COUNT(*) as record_count FROM department
UNION ALL SELECT 'Document Types', COUNT(*) FROM document_type
UNION ALL SELECT 'Users', COUNT(*) FROM app_user  
UNION ALL SELECT 'Services', COUNT(*) FROM service
UNION ALL SELECT 'Time Slots', COUNT(*) FROM time_slot
UNION ALL SELECT 'Appointments', COUNT(*) FROM appointment
UNION ALL SELECT 'User Documents', COUNT(*) FROM user_document
UNION ALL SELECT 'Required Docs', COUNT(*) FROM required_doc_for_service
UNION ALL SELECT 'Officer Departments', COUNT(*) FROM officer_department
UNION ALL SELECT 'Notifications', COUNT(*) FROM notification
UNION ALL SELECT 'Messages', COUNT(*) FROM message
UNION ALL SELECT 'Complaints', COUNT(*) FROM complaint
UNION ALL SELECT 'Feedback', COUNT(*) FROM feedback
ORDER BY table_name;
