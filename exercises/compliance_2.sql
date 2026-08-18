/*==============================================
           BRONZE LAYER
================================================*/

SELECT *
INTO bronze_workers
FROM workers

SELECT *
INTO bronze_contractors 
FROM contractors

SELECT *
INTO bronze_certifications
FROM certifications

SELECT *
INTO bronze_worker_certifications
FROM worker_certifications


/*===============================================
           SILVER LAYER
-- Assume no data cleaning is done
=================================================*/
SELECT *
INTO silver_workers
FROM bronze_workers

SELECT *
INTO silver_contractors 
FROM bronze_contractors 

SELECT *
INTO silver_certifications
FROM bronze_certifications

SELECT *
INTO silver_worker_certifications
FROM bronze_worker_certifications

/*=================================================
           GOLD LAYER
-- Load the dim and fact tables using star schema
================================================== */
CREATE VIEW vw_dim_workers AS 
    SELECT
    worker_id
    , worker_name
    , contractor_id
  FROM silver_workers;
GO

CREATE VIEW vw_dim_contractors AS 
  SELECT 
    contractor_id
    , contractor_name
  FROM silver_contractors;
GO


CREATE VIEW vw_dim_certifications AS
  SELECT 
    cer_id
    , cert_name
  FROM silver_certifications;

GO

CREATE VIEW vw_fact_worker_certifications AS 
SELECT 
  ROW_NUMBER() OVER() AS compliance_id
  , wc. worker_id
  , wc.cert_id
  , w.coontractor_id 
  , wc.expiry_date
FROM silver_worker_certifications wc
LEFT JOIN silver_workers w
  ON wc.worker_id = w.worker_id;

  GO

  /* =========================================

        BUSINESS QUESTIONS

   =========================================== */

-- Write a SQL query returning: worker_name, cert_name, expiry_date, status

  WITH certification_status AS (
      SELECT 
       wc. worker_id
      , wc.cert_id
      , w.worker_name
      , w.cert_name
      , wc.expiry_date 
          
      FROM vw_fact_worker_certifications wc
      LEFT JOIN vw_dim_workers w
        ON w.worker_id = wc.worker_id
      LEFT JOIN vw_dim_certifications c  
        ON wc.cert_id = c.cert_id
        
  )
    SELECT 
      worker_name
    , cert_name
    , expiry_date
    , CASE 
        WHEN expiry_date < '2026-01-15' THEN 'Expired'
        WHEN expiry_date between '2026-01-15' and '2026-02-14' THEN 'Expiring Soon'
        ELSE 'Active'
      END AS status
    FROM certification_status

  -- Certification Summary
     WITH certification_status AS (
      SELECT 
       wc. worker_id
      , wc.cert_id
      , w.worker_name
      , w.cert_name
      , wc.expiry_date 
          
      FROM vw_fact_worker_certifications wc
      LEFT JOIN vw_dim_workers w
        ON w.worker_id = wc.worker_id
      LEFT JOIN vw_dim_certifications c  
        ON wc.cert_id = c.cert_id
        
  )
    SELECT 
      worker_name
    , cert_name
    , expiry_date
    , CASE 
        WHEN expiry_date < '2026-01-15' THEN 'Expired'
        WHEN expiry_date between '2026-01-15' and '2026-02-14' THEN 'Expiring Soon'
        ELSE 'Active'
      END AS status
    , COUNT(*) OVER (PARTTION BY worker_name) AS total_certifications
    FROM certification_status

    -- Compliance Rate by Contractor
    WITH certification_status AS (
      SELECT 
       wc. worker_id
      , wc.cert_id
      , w.worker_name
      , w.cert_name
      , wc.expiry_date 
          
      FROM vw_fact_worker_certifications wc
      LEFT JOIN vw_dim_workers w
        ON w.worker_id = wc.worker_id
      LEFT JOIN vw_dim_certifications c  
        ON wc.cert_id = c.cert_id
        
  )
    SELECT 
      worker_name
    , cert_name
    , expiry_date
    , CASE 
        WHEN expiry_date < '2026-01-15' THEN 'Expired'
        WHEN expiry_date between '2026-01-15' and '2026-02-14' THEN 'Expiring Soon'
        ELSE 'Active'
      END AS status
    , COUNT(*) OVER (PARTTION BY worker_name) AS total_certifications
    FROM certification_status

      




















  
SELECT
  role_id
  , competency_id
  , is_mandatory
FROM silver_role_required_competencies
WHERE is_mandatory = 1;
GO


CREATE VIEW vw_fact_worker_credentials_summary AS

  WITH get_workername_contractorname_sites_roles_worker_site_assignments AS (
  
      SELECT
        wsa.assignment_id
        , wsa.worker_id
        , w.worker_name
        , w.contractor_id
        , c.contractor_name
        , wsa.site_id
        , wsa.role_id
        , r.role_name
        , wsa.assignment_status
        , w.worker_status
        , wsa.start_date
        , s.sitename
        , s.region
        
      FROM silver_worker_site_assignments wsa
      LEFT JOIN silver_workers w
        ON w.worker_id = wsa.worker_id
      LEFT JOIN silver_contractors c
        ON w.contractor_id = c.contractor_id
      LEFT JOIN silver_sites s
        ON s.site_id = wsa.site_id
      LEFT JOIN silver_roles r
        ON r.role_id = wsa.role_id
  );
    role_required_competencies_summary AS (
  
        SELECT 
          wcsr.assignment_id
        , wcsr.worker_id
        , wcsr.worker_name
        , rrc.competency_id
        , com.competency_name
        , com.competency_type
        , wcsr.contractor_id
        , wcsr.contractor_name
        , wcsr.site_id
        , wcsr.sitename
        , wcsr.role_id
        , wcsr.role_name
        , wcsr.assignment_status
        , wcsr.worker_status
        , wcsr.start_date
        , wcsr.region
        , wc.issue_date
        , wc.expiry_date
        , wc.verification_status
        FROM get_workername_contractorname_sites_roles_worker_site_assignments wcsr
        LEFT JOIN silver_role_required_competencies rrc
          ON rrc.role_id = wcsr.role_id
        LEFT JOIN silver_competencies com
          ON com.competency_id = rrc.competency_id
        LEFT JOIN silver_worker_credentials wc
          ON wc.worker_id = wcsr.worker_id AND
            wc.competency_id = rrc.competency_id 
    )
    
      SELECT 
         assignment_id
        , worker_name
        , role_name
        , competency_id
        , contractor_id
        , site_id
        , issue_date
        , expiry_date
        , verification_status
          
    FROM role_required_competencies_summary

/* ===========================================================
                SQL QUESTIONS
===============================================================*/
-- 1. write an SQL query that returns each credential with a calculated status

WITH get_workername_contractorname_sites_roles_worker_site_assignments AS (
  
      SELECT
        wsa.assignment_id
        , wsa.worker_id
        , w.worker_name
        , w.contractor_id
        , c.contractor_name
        , wsa.site_id
        , wsa.role_id
        , r.role_name
        , wsa.assignment_status
        , w.worker_status
        , wsa.start_date
        , s.sitename
        , s.region
        
      FROM silver_worker_site_assignments wsa
      LEFT JOIN silver_workers w
        ON w.worker_id = wsa.worker_id
      LEFT JOIN silver_contractors c
        ON w.contractor_id = c.contractor_id
      LEFT JOIN silver_sites s
        ON s.site_id = wsa.site_id
      LEFT JOIN silver_roles r
        ON r.role_id = wsa.role_id
  );
    role_required_competencies_summary AS (
  
        SELECT 
          wcsr.assignment_id
        , wcsr.worker_id
        , wcsr.worker_name
        , rrc.competency_id
        , com.competency_name
        , com.competency_type
        , wcsr.contractor_id
        , wcsr.contractor_name
        , wcsr.site_id
        , wcsr.sitename
        , wcsr.role_id
        , wcsr.role_name
        , wcsr.assignment_status
        , wcsr.worker_status
        , wcsr.start_date
        , wcsr.region
        , wc.issue_date
        , wc.expiry_date
        , wc.verification_status
        FROM get_workername_contractorname_sites_roles_worker_site_assignments wcsr
        LEFT JOIN silver_role_required_competencies rrc
          ON rrc.role_id = wcsr.role_id
        LEFT JOIN silver_competencies com
          ON com.competency_id = rrc.competency_id
        LEFT JOIN silver_worker_credentials wc
          ON wc.worker_id = wcsr.worker_id AND
            wc.competency_id = rrc.competency_id 
)
  SELECT 
  * 
  INTO compliance_check_summary
  FROM role_required_competencies_summary

WITH check_compliance_status AS (
  SELECT 
    

)






