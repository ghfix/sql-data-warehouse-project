==================================================================
Inserting erp_cust_az12 from the bronze layer into the silver layer
===================================================================




INSERT INTO silver.erp_cust_az12 (
		cid,
		bdate,
		gen
)
SELECT
CASE
	WHEN cid LIKE 'NAS%' -- Remove 'NAS' prefix if present
	THEN SUBSTRING(cid, 4, LEN(cid))
	ELSE cid
END AS cid,
CASE
	WHEN bdate > GETDATE() 
	THEN NULL
	ELSE bdate
END AS bdate, -- Set future birthdates to NULL
CASE
	WHEN UPPER(TRIM(gen)) IN ('F' , 'FEMALE') THEN 'Female'
	WHEN UPPER(TRIM(gen)) IN ('M' , 'MALE') THEN 'Male'
	ELSE 'n/a'
END AS gen -- Normalize gender values and handle unknown cases
FROM bronze.erp_cust_az12
