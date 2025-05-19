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


--Check for invalid dates

SELECT
	NULLIF (sls_due_dt , 0) sls_due_dt
FROM 
	silver.crm_sales_details
WHERE 
	sls_due_dt <= 0 
OR LEN(sls_due_dt) != 8
OR sls_due_dt > 20500101
OR sls_due_dt < 19000101

-- Check for Invalid Date Orders
select * from silver.crm_sales_details
where sls_order_dt > sls_ship_dt OR sls_ship_dt > sls_due_dt



=================================
crm sales details quality checks
=================================
--Check Data Consistency: Between Sales, Quantity, and Price
-- >> Sales = Quantity * Price
-- >> Values must not be NULL, zero, or negative.

--Rules
-- If Sales is negative, zero, or null, derive it using Quantity and Price
-- If Price is zero or null, calculate it using Sales and Quantity
-- If price is negative, convert it to a positive value
SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

select * from silver.crm_sales_details


=================================
erp_cust_az12 quality checks
=================================
-- Identify out-of-range dates
SELECT DISTINCT
bdate
FROM silver.erp_cust_az12
where bdate < '1924-01-01' OR bdate > GETDATE()

-- Data Standardization & Consistency
SELECT DISTINCT
	gen,
CASE
	WHEN UPPER(TRIM(gen)) IN ('F' , 'FEMALE') THEN 'Female'
	WHEN UPPER(TRIM(gen)) IN ('M' , 'MALE') THEN 'Male'
	ELSE 'n/a'
END AS gen
FROM silver.erp_cust_az12


