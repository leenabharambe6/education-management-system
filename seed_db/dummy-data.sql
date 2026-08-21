-- Dummy data for local testing.
-- Safe to re-run: unique conflicts are ignored.
-- Reuses the seeded admin password hash (password: 3OU4zn3q6Zh9).

INSERT INTO sections (name) VALUES
('A'),
('B'),
('C')
ON CONFLICT (name) DO NOTHING;

INSERT INTO classes (name, sections) VALUES
('Grade 8', 'A,B'),
('Grade 9', 'A,B'),
('Grade 10', 'A,B,C'),
('Grade 11', 'A,B'),
('Grade 12', 'A')
ON CONFLICT (name) DO NOTHING;

INSERT INTO departments (name) VALUES
('Science'),
('Mathematics'),
('English'),
('Administration')
ON CONFLICT (name) DO NOTHING;

INSERT INTO leave_policies (name, is_active) VALUES
('Casual Leave', true),
('Sick Leave', true),
('Earned Leave', true)
ON CONFLICT DO NOTHING;

-- Same argon2 hash as admin@school-admin.com
-- Password: 3OU4zn3q6Zh9
INSERT INTO users (name, email, role_id, created_dt, password, is_active, is_email_verified, reporter_id, leave_policy_id)
VALUES
('Priya Sharma', 'teacher.science@school.com', 2, now(), '$argon2id$v=19$m=65536,t=3,p=4$21a+bDbESEI60WO1wRKnvQ$i6OrxqNiHvwtf1Xg3bfU5+AXZG14fegW3p+RSMvq1oU', true, true, 1, 1),
('Rahul Mehta', 'teacher.math@school.com', 2, now(), '$argon2id$v=19$m=65536,t=3,p=4$21a+bDbESEI60WO1wRKnvQ$i6OrxqNiHvwtf1Xg3bfU5+AXZG14fegW3p+RSMvq1oU', true, true, 1, 2),
('Anita Joseph', 'teacher.english@school.com', 2, now(), '$argon2id$v=19$m=65536,t=3,p=4$21a+bDbESEI60WO1wRKnvQ$i6OrxqNiHvwtf1Xg3bfU5+AXZG14fegW3p+RSMvq1oU', true, true, 1, 1)
ON CONFLICT (email) DO NOTHING;

INSERT INTO users (name, email, role_id, created_dt, password, is_active, is_email_verified, reporter_id, leave_policy_id)
VALUES
('Ada Lovelace', 'ada@school.com', 3, now(), '$argon2id$v=19$m=65536,t=3,p=4$21a+bDbESEI60WO1wRKnvQ$i6OrxqNiHvwtf1Xg3bfU5+AXZG14fegW3p+RSMvq1oU', true, true, (SELECT id FROM users WHERE email = 'teacher.science@school.com'), 1),
('Ravi Kumar', 'ravi.kumar@school.com', 3, now(), '$argon2id$v=19$m=65536,t=3,p=4$21a+bDbESEI60WO1wRKnvQ$i6OrxqNiHvwtf1Xg3bfU5+AXZG14fegW3p+RSMvq1oU', true, true, (SELECT id FROM users WHERE email = 'teacher.science@school.com'), 1),
('Meera Nair', 'meera.nair@school.com', 3, now(), '$argon2id$v=19$m=65536,t=3,p=4$21a+bDbESEI60WO1wRKnvQ$i6OrxqNiHvwtf1Xg3bfU5+AXZG14fegW3p+RSMvq1oU', true, true, (SELECT id FROM users WHERE email = 'teacher.math@school.com'), 2),
('Arjun Patel', 'arjun.patel@school.com', 3, now(), '$argon2id$v=19$m=65536,t=3,p=4$21a+bDbESEI60WO1wRKnvQ$i6OrxqNiHvwtf1Xg3bfU5+AXZG14fegW3p+RSMvq1oU', true, true, (SELECT id FROM users WHERE email = 'teacher.english@school.com'), 1)
ON CONFLICT (email) DO NOTHING;

INSERT INTO user_profiles (
    user_id, gender, marital_status, phone, dob, join_dt, qualification, experience,
    class_name, section_name, roll, department_id, admission_dt,
    father_name, father_phone, mother_name, mother_phone,
    guardian_name, guardian_phone, emergency_phone, relation_of_guardian,
    current_address, permanent_address
)
SELECT u.id, p.gender, p.marital_status, p.phone, p.dob::date, p.join_dt::date, p.qualification, p.experience,
       p.class_name, p.section_name, p.roll, d.id, p.admission_dt::date,
       p.father_name, p.father_phone, p.mother_name, p.mother_phone,
       p.guardian_name, p.guardian_phone, p.emergency_phone, p.relation_of_guardian,
       p.current_address, p.permanent_address
FROM (
    VALUES
    ('teacher.science@school.com', 'Female', 'Married', '9876500001', '1988-03-12', '2018-06-01', 'M.Sc Physics', '8 years', NULL, NULL, NULL, 'Science', NULL, 'Raj Sharma', NULL, 'Neha Sharma', NULL, NULL, NULL, '9876500091', NULL, '12 Park Street', 'Pune'),
    ('teacher.math@school.com', 'Male', 'Married', '9876500002', '1985-11-20', '2016-06-01', 'M.Sc Mathematics', '10 years', NULL, NULL, NULL, 'Mathematics', NULL, 'Suresh Mehta', NULL, 'Kavita Mehta', NULL, NULL, NULL, '9876500092', NULL, '44 MG Road', 'Mumbai'),
    ('teacher.english@school.com', 'Female', 'Single', '9876500003', '1990-07-08', '2019-06-01', 'M.A English', '6 years', NULL, NULL, NULL, 'English', NULL, 'Thomas Joseph', NULL, 'Mary Joseph', NULL, NULL, NULL, '9876500093', NULL, '9 Lake View', 'Kochi'),
    ('ada@school.com', 'Female', NULL, '9876501001', '2009-12-10', NULL, NULL, NULL, 'Grade 10', 'A', 12, NULL, '2023-06-15', 'George Lovelace', '9876501101', 'Ann Lovelace', '9876501102', 'George Lovelace', '9876501101', '9876501101', 'Father', '1 Algorithm Lane', 'London'),
    ('ravi.kumar@school.com', 'Male', NULL, '9876501002', '2009-05-21', NULL, NULL, NULL, 'Grade 10', 'A', 13, NULL, '2023-06-15', 'Suresh Kumar', '9876501201', 'Lakshmi Kumar', '9876501202', 'Suresh Kumar', '9876501201', '9876501201', 'Father', '22 Nehru Nagar', 'Delhi'),
    ('meera.nair@school.com', 'Female', NULL, '9876501003', '2010-02-14', NULL, NULL, NULL, 'Grade 9', 'B', 7, NULL, '2024-06-10', 'Anil Nair', '9876501301', 'Suma Nair', '9876501302', 'Anil Nair', '9876501301', '9876501301', 'Father', '5 Marine Drive', 'Kochi'),
    ('arjun.patel@school.com', 'Male', NULL, '9876501004', '2008-09-03', NULL, NULL, NULL, 'Grade 11', 'A', 4, NULL, '2022-06-12', 'Nitin Patel', '9876501401', 'Pooja Patel', '9876501402', 'Nitin Patel', '9876501401', '9876501401', 'Father', '18 SG Highway', 'Ahmedabad')
) AS p(email, gender, marital_status, phone, dob, join_dt, qualification, experience, class_name, section_name, roll, department_name, admission_dt, father_name, father_phone, mother_name, mother_phone, guardian_name, guardian_phone, emergency_phone, relation_of_guardian, current_address, permanent_address)
JOIN users u ON u.email = p.email
LEFT JOIN departments d ON d.name = p.department_name
ON CONFLICT (user_id) DO NOTHING;

INSERT INTO class_teachers (teacher_id, class_name, section_name)
SELECT u.id, v.class_name, v.section_name
FROM (
    VALUES
    ('teacher.science@school.com', 'Grade 10', 'A'),
    ('teacher.math@school.com', 'Grade 9', 'B'),
    ('teacher.english@school.com', 'Grade 11', 'A')
) AS v(email, class_name, section_name)
JOIN users u ON u.email = v.email
WHERE NOT EXISTS (
    SELECT 1 FROM class_teachers ct
    WHERE ct.teacher_id = u.id AND ct.class_name = v.class_name AND ct.section_name = v.section_name
);

INSERT INTO user_leave_policy (user_id, leave_policy_id)
SELECT u.id, lp.id
FROM users u
JOIN leave_policies lp ON lp.name IN ('Casual Leave', 'Sick Leave')
WHERE u.email IN (
    'admin@school-admin.com',
    'teacher.science@school.com',
    'teacher.math@school.com',
    'teacher.english@school.com'
)
ON CONFLICT (user_id, leave_policy_id) DO NOTHING;

INSERT INTO user_leaves (user_id, leave_policy_id, from_dt, to_dt, note, submitted_dt, approver_id, approved_dt, status)
SELECT u.id, 1, DATE '2026-08-10', DATE '2026-08-12', 'Family function', now() - interval '10 days', 1, now() - interval '8 days', 2
FROM users u WHERE u.email = 'teacher.science@school.com'
AND NOT EXISTS (SELECT 1 FROM user_leaves ul WHERE ul.user_id = u.id AND ul.note = 'Family function');

INSERT INTO user_leaves (user_id, leave_policy_id, from_dt, to_dt, note, submitted_dt, status)
SELECT u.id, 2, DATE '2026-08-22', DATE '2026-08-23', 'Fever', now(), 1
FROM users u WHERE u.email = 'teacher.math@school.com'
AND NOT EXISTS (SELECT 1 FROM user_leaves ul WHERE ul.user_id = u.id AND ul.note = 'Fever');

INSERT INTO notice_recipient_types (role_id, primary_dependent_name, primary_dependent_select)
SELECT 3, 'Class', 'SELECT name FROM classes ORDER BY name'
WHERE NOT EXISTS (
    SELECT 1 FROM notice_recipient_types WHERE role_id = 3 AND primary_dependent_name = 'Class'
);

INSERT INTO notice_recipient_types (role_id, primary_dependent_name, primary_dependent_select)
SELECT 2, 'Department', 'SELECT name FROM departments ORDER BY name'
WHERE NOT EXISTS (
    SELECT 1 FROM notice_recipient_types WHERE role_id = 2 AND primary_dependent_name = 'Department'
);

INSERT INTO notice_recipient_types (role_id, primary_dependent_name, primary_dependent_select)
SELECT 1, NULL, NULL
WHERE NOT EXISTS (
    SELECT 1 FROM notice_recipient_types WHERE role_id = 1 AND primary_dependent_name IS NULL
);

INSERT INTO notices (author_id, title, description, status, recipient_type, recipient_role_id, recipient_first_field, created_dt, reviewed_dt, reviewer_id)
SELECT 1, 'Welcome to the new term', 'Classes resume on 1 September. Please complete fee payment.',
       (SELECT id FROM notice_status WHERE name = 'Approve'),
       'role', 3, 'Grade 10', now(), now(), 1
WHERE NOT EXISTS (SELECT 1 FROM notices WHERE title = 'Welcome to the new term');

INSERT INTO notices (author_id, title, description, status, recipient_type, recipient_role_id, created_dt)
SELECT (SELECT id FROM users WHERE email = 'teacher.science@school.com'),
       'Science lab safety',
       'Lab coats are mandatory from next week.',
       (SELECT id FROM notice_status WHERE name = 'Draft'),
       'role', 3, now()
WHERE NOT EXISTS (SELECT 1 FROM notices WHERE title = 'Science lab safety');

INSERT INTO permissions (role_id, access_control_id, type)
SELECT 1, ac.id, ac.type
FROM access_controls ac
ON CONFLICT (role_id, access_control_id) DO NOTHING;

INSERT INTO permissions (role_id, access_control_id, type)
SELECT 2, ac.id, ac.type
FROM access_controls ac
WHERE ac.path IN (
    '/api/v1/dashboard',
    '/api/v1/students',
    '/api/v1/students/:id',
    '/api/v1/leave/request',
    '/api/v1/leave/pending',
    '/api/v1/notices',
    '/api/v1/classes',
    '/api/v1/sections'
) OR ac.parent_path IN ('students_parent', 'leave_parent', 'academics_parent', 'communication_parent')
   OR ac.path IN ('', 'leave_parent', 'students_parent', 'academics_parent', 'communication_parent', 'account')
ON CONFLICT (role_id, access_control_id) DO NOTHING;

INSERT INTO permissions (role_id, access_control_id, type)
SELECT 3, ac.id, ac.type
FROM access_controls ac
WHERE ac.path IN (
    '/api/v1/dashboard',
    '/api/v1/leave/request',
    '/api/v1/leave/policies/me',
    '/api/v1/notices',
    'account'
) OR ac.path = ''
ON CONFLICT (role_id, access_control_id) DO NOTHING;
