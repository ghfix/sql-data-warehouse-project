=====================================================================
DDL Script: Create Gold Views for customers
=====================================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key, -- Surrogate Key
	ci.cst_id 			AS customer_id,
	ci.cst_key 			AS customer_number,
	ci.cst_firstname 		AS first_name,
	ci.cst_lastname 		AS last_name,
	la.cntry 			AS country,
	ci.cst_marital_status 		AS marital_status,
	CASE 
		WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the Master for gender Info
		ELSE COALESCE (ca.gen, 'n/a')		   -- Fallback to ERP Data
	END 				AS gender,
	ca.bdate 			AS birthdate,
	ci.cst_create_date 		AS create_date
	
FROM 
	silver.crm_cust_info ci
LEFT JOIN
	silver.erp_cust_az12 ca
ON 
	ci.cst_key = ca.cid
LEFT JOIN
	silver.erp_loc_a101 la
ON
	ci.cst_key = la.cid
