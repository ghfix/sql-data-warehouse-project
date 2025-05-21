=================================================
Using subqueries to check for customer duplicates
=================================================
SELECT cst_id, COUNT(*) FROM
	(SELECT 
		ci.cst_id,
		ci.cst_key,
		ci.cst_firstname,
		ci.cst_lastname,
		ci.cst_marital_status,
		ci.cst_gndr,
		ci.cst_create_date,
		ca.bdate,
		ca.gen,
		la.cntry
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
)t GROUP BY cst_id
HAVING COUNT (*) > 1



=================================================
Using subqueries to check for product duplicates
=================================================
select prd_id, count(*) from
(select 
	pn.prd_id,
	pn.cat_id,
	pn.prd_key,
	pn.prd_nm,
	pn.prd_cost,
	pn.prd_line,
	pn.prd_start_dt,
	pc.cat,
	pc.subcat,
	pc.maintenance
from 
	silver.crm_prd_info pn  
left join silver.erp_px_cat_g1v2 pc
on pn.cat_id = pc.id
where prd_end_dt IS NULL -- Filter out all historical data
)t
group by prd_id
having count (*) > 1
