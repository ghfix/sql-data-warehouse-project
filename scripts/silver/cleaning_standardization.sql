/*
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

