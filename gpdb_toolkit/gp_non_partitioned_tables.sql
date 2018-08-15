----- Get all Non-Partitioned tables in $SCHEMA

SELECT
	nsp.nspname,
	c.relname
FROM
	pg_class c
	INNER JOIN pg_namespace nsp
		ON c.relnamespace = nsp.oid 
	LEFT OUTER JOIN pg_partition_rule prt
		ON c.oid = prt.parchildrelid
WHERE
	c.relkind = 'r'
	AND nspname = $SCHEMA
	AND prt.parchildrelid IS NULL
