-- STEP1: CREATE DATABASE RiskDB;

USE RiskDB;
GO
-- STEP 2: Create Tables
CREATE TABLE organizations (
	organization_id INT PRIMARY KEY,
	organization_name VARCHAR(255)
);

CREATE TABLE workers (
	worker_id INT PRIMARY KEY,
	worker_name VARCHAR(255),
	organization_id INT,
	is_active BIT
);

DROP TABLE sites
CREATE TABLE projects (
	project_id INT PRIMARY KEY,
	project_name VARCHAR(255)
);

CREATE TABLE roles (
	role_id INT PRIMARY KEY,
	role_name VARCHAR (255)
);

DROP TABLE worker_assignments
CREATE TABLE worker_assignments (
	assignment_id INT PRIMARY KEY,
	worker_id INT,
	project_id INT,
	role_id INT,
	assignment_status VARCHAR(50)
);

CREATE TABLE credential_types (
	credential_type_id INT PRIMARY KEY,
	credential_name VARCHAR(255)
);

DROP TABLE role_sites_requirements
CREATE TABLE role_sites_requirements (
	requirement_id INT PRIMARY KEY,
	project_id INT,
	role_id INT,
	credential_type_id INT,
	is_mandatory BIT
);

CREATE TABLE worker_credentials (
	worker_credential_id INT PRIMARY KEY,
	worker_id INT,
	credential_type_id INT,
	credential_number VARCHAR(100),
	verification_status VARCHAR(50),
	issued_date DATE,
	expiry_date DATE,
	uploaded_at DATE,
);

-- STEP 3: Insert values into the tables 
INSERT INTO organizations VALUES
(1, 'Apex Technology Services'),
(2, 'Blueline Cloud Solutions'),
(3, 'Safeworks IT Consulting');

INSERT INTO workers VALUES
(107, 'Patrick Garcia', 1, 1),
(108, 'Elaine Tan', 2, 1),
(109, 'Miguel Ramos', 3, 1),
(110, 'Sofia Mendoza', 4, 1);

INSERT INTO projects VALUES
(10, 'Data Platform Project'),
(30, 'Application Development Platform');

INSERT INTO roles VALUES
(100, 'Data Engineer'),
(200, 'BI Engineer'),
(300, 'Software Engineer');

INSERT INTO credential_types VALUES
(1, 'Data Privacy Training'),
(2, 'SQL Certification'),
(3, 'Security Awareness Training'),
(4, 'Cloud Data Platform Certification'),
(5, 'PowerBI Certification'),
(7, 'Secure Coding Certification'),
(8, 'Git/DevOps Certification');

INSERT INTO role_sites_requirements VALUES
-- Data Engineer Requirements
(1, 10, 100, 1, 1),
(2, 10, 100, 2, 1),
(3, 10, 100, 3, 1),
(4, 10, 100, 4, 1),

-- BI Engineer Requirements
(5, 10, 200, 1, 1),
(6, 10, 200, 3, 1),
(7, 10, 200, 5, 1),

-- Software Engineer Requirements
(9, 30, 400, 1, 1),
(10, 30, 400, 3, 1),
(11, 30, 400, 7, 1),
(12, 30, 400, 8, 1);

INSERT INTO worker_assignments VALUES
(1, 107, 30, 400, 'Active'),
(2, 108, 30, 400, 'Active'),
(3, 109, 30, 100, 'Active'),
(4, 110, 30, 200, 'Active');

INSERT INTO worker_credentials VALUES
-- for Employee ID: 107
(1021, 107, 1, 'DPT-107', 'Verified', '2026-01-01', '2027-01-01', '2026-01-01'),
(1022, 107, 3, 'SAT-107', 'Verified', '2026-01-01', '2027-01-01', '2026-01-01'),
(1023, 107, 7, 'SC-107', 'Verified', '2026-02-01', '2027-02-01', '2026-02-01'),
(1024, 107, 8, 'GIT-107', 'Verified', '2026-03-01', '2027-03-01', '2026-03-01'),

-- for Employee ID: 108
(1025, 108, 1, 'DPT-108', 'Verified', '2026-01-01', '2027-01-01', '2026-01-01'),
(1026, 108, 3, 'SAT-108', 'Verified', '2026-01-01', '2027-01-01', '2026-01-01'),
(1027, 108, 7, 'SC-108', 'Pending', '2026-02-01', '2027-02-01', '2026-02-01'),

-- for Employee ID: 109
(1028, 109, 1, 'DPT-109', 'Verified', '2026-01-01', '2027-01-01', '2026-01-01'),
(1029, 109, 2, 'SQL-109', 'Verified', '2025-01-01', '2026-07-31', '2025-01-01'),
(1030, 109, 3, 'SAT-109', 'Verified', '2026-01-01', '2027-01-01', '2026-01-01'),

-- for Employee ID: 110
(1031, 110, 1, 'DPT-110', 'Verified', '2026-01-01', '2027-01-01', '2026-01-01'),
(1032, 110, 3, 'SAT-110', 'Verified', '2026-01-01', '2027-01-01', '2026-01-01'),
(1033, 110, 5, 'PBI-110', 'Verified', '2026-02-01', '2026-09-10', '2026-02-01');

