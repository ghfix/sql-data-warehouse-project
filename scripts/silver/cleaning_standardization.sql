/*
============================
crm_cust_info
============================
These tests were applied as follows
Null and Duplicates ==> cst_id
Unwanted Spaces ==> cst_firstname, cst_lastname, cst_gndr and cst_marital_status
Full meanings and n/a ==> cst_gndr and cst_marital_status
*/

--Check for Nulls or Duplicates in Primary Key
--Expectation: No results

SELECT cst_id, COUNT (*)
FROM bronze.crm_cust_info
group by cst_id
having count (*) > 1 OR cst_id IS NULL

-- check for unwanted spaces
-- Expectation: No Results
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM (cst_firstname)

-- Data Standardization & Consistency
SELECT DISTINCT cst_marital_status
from bronze.crm_cust_info

/*
============================
crm_prd_info
============================
*/
  
-- Check for Nulls or Duplicates in Primary Key
-- Expectation: No Result
select prd_id, count (*)
from silver.crm_prd_info
group by prd_id
having count (*) > 1 or prd_id is null

-- Check for unwanted spaces
-- Expectation: No Result
select prd_nm
from silver.crm_prd_info
where prd_nm != TRIM(prd_nm)  

-- Check for Nulls or Negative Numbers
-- Expectation: No results
Select prd_cost
FROM silver.crm_prd_info
where prd_cost < 0 OR prd_cost IS NULL

-- Data Standardization & Consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info

-- Check for Invalid Date Orders
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt


