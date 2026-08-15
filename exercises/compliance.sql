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

DROP TABLE role_credentials_requirements
CREATE TABLE role_credentials_requirements (
	requirement_id INT PRIMARY KEY,
	project_id INT,
	role_id INT,
	credential_type_id INT,
	is_mandatory INT
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

INSERT INTO role_credentials_requirements
VALUES
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


SELECT * FROM organizations
SELECT * FROM workers
SELECT * FROM projects
SELECT * FROM roles
SELECT * FROM credential_types
SELECT * FROM worker_assignments
SELECT * FROM role_credentials_requirements
SELECT * FROM worker_credentials

UPDATE roles
SET role_id = 400
WHERE role_id = 300

--  Step 4: Create a separate Compliance Check table starting from worker_assignments table
WITH workers_name_org AS (
	SELECT 
		wa.assignment_id,
		wa.worker_id,
		wa.project_id,
		wa.role_id,
		w.worker_name
	FROM worker_assignments wa
	LEFT JOIN workers w
		ON wa.worker_id = w.worker_id
)
, workers_projects_roleName AS(
	SELECT 
		wnm.assignment_id,
		wnm.worker_id, 
		wnm.project_id,
		wnm.role_id,
		wnm.worker_name,
		p.project_name,
		r.role_name
	FROM workers_name_org wnm
	LEFT JOIN projects p
		ON wnm.project_id = p.project_id
	LEFT JOIN roles r
		ON wnm.role_id = r.role_id


)
, fact_workers_check AS (

	SELECT 
		wpr.worker_id,
		wpr.worker_name,
		wpr.role_id,
		wpr.role_name,
		wpr.project_id,
		wpr.project_name,
		rcr.is_mandatory,
		ct.credential_type_id,
		ct.credential_name,
		wc.worker_credential_id,
		wc.credential_number,
		wc.verification_status,
		wc.issued_date,
		wc.expiry_date,
		wc.uploaded_at
	
	FROM workers_projects_roleName wpr
	LEFT JOIN role_credentials_requirements rcr
		ON rcr.role_id = wpr.role_id
			---AND rcr.project_id = wpr.project_id
	LEFT JOIN credential_types ct
		ON ct.credential_type_id = rcr.credential_type_id
	LEFT JOIN worker_credentials wc
		ON ct.credential_type_id = wc.credential_type_id
		AND wpr.worker_id = wc.worker_id
) 

-- Returns a table that will summarize all the submitted credentials and the required credentials of the workers and
-- Insert the returned records to fact_workers_check_compliance table for reporting reasons
SELECT *
INTO fact_workers_check_compliance
FROM fact_workers_check

-- Create a separate summary table to check workers who are compliant

WITH credential_count AS (
	SELECT
	worker_id
	, worker_name
	, role_name
	, project_name
	, credential_type_id
	, credential_name
	, verification_status
	, expiry_date
	, DATEDIFF(DAY, GETDATE(), expiry_date) AS days_to_expire
	, CASE
		WHEN verification_status = 'Verified' AND expiry_date > GETDATE() /*AND DATEDIFF(DAY, GETDATE(), expiry_date) >= 30*/ THEN 1
		ELSE 0
	  END AS credential_count
	  , SUM(SUM(CASE
		WHEN verification_status = 'Verified' AND expiry_date > GETDATE() /*AND DATEDIFF(DAY, GETDATE(), expiry_date) >= 30*/ THEN 1
		ELSE 0
	  END)) OVER(PARTITION BY worker_id) AS actual_credential_count
	, COUNT(CASE
		WHEN verification_status = 'Verified' AND expiry_date > GETDATE() /*AND DATEDIFF(DAY, GETDATE(), expiry_date) >= 30*/ THEN 1
		ELSE 0
	  END) OVER(PARTITION BY worker_name) total_credential_count
	, CASE WHEN 
				COUNT(CASE
				WHEN verification_status = 'Verified' AND expiry_date > GETDATE() /*AND DATEDIFF(DAY, GETDATE(), expiry_date) >= 30*/ THEN 1
				ELSE 0
			  END) OVER(PARTITION BY worker_name) = 
			  SUM(SUM(CASE
				WHEN verification_status = 'Verified' AND expiry_date > GETDATE() /*AND DATEDIFF(DAY, GETDATE(), expiry_date) >= 30*/ THEN 1
				ELSE 0
			  END)) OVER(PARTITION BY worker_id) 

		THEN 'Compliant' 
		ELSE 'Non-Compliant'
	END AS compliance_status
	FROM fact_workers_check_compliance
	GROUP BY worker_id, worker_name
	, role_name
	, project_name
	, credential_type_id
	, credential_name
	, verification_status
	, expiry_date  
)
-- Returns the records of workers who are Compliant and Non-Compliant
-- Load the records into a new table compliance_summary_by_worker for reporting

SELECT DISTINCT
  worker_id
  , worker_name
  , role_name
  , actual_credential_count
  , total_credential_count
  , compliance_status
INTO compliance_summary_by_worker
FROM credential_count

-- Create a table to return credentials that will expire in next 30 days
	SELECT 
		worker_id
		, worker_name
		, role_name
		, project_name
		, credential_type_id
		, credential_name
		, verification_status
		, expiry_date
		, DATEDIFF(DAY, GETDATE(), expiry_date) AS days_to_expire
		, CASE WHEN
			expiry_date > GETDATE() AND DATEDIFF(DAY, GETDATE(), expiry_date) <= 30 THEN 'Yes'
			ELSE 'No'
		END AS is_expire_in_30_days
	INTO worker_credentials_expire_in_30_days
	FROM fact_workers_check_compliance
	WHERE CASE WHEN
			expiry_date > GETDATE() AND DATEDIFF(DAY, GETDATE(), expiry_date) <= 30 THEN 'Yes'
			ELSE 'No'
		END = 'Yes'

-- Create a table to list all missing/invalid credentials
SELECT 
	worker_id
	, worker_name
	, role_name
	, project_name
	, credential_name
	, credential_number
	, verification_status
	, issued_date
	, expiry_date
INTO missing_invalid_credentials
FROM fact_workers_check_compliance
WHERE verification_status != 'Verified' OR verification_status IS NULL OR expiry_date < GETDATE()

SELECT * FROM missing_invalid_credentials
