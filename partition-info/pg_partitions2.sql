/* CREATE VIEW public.pg_partitions2 */

CREATE VIEW public.pg_partitions2 AS
SELECT n.nspname AS schemaname, 
	n.oid AS schemaoid, 
	cl.relname AS tablename, 
	cl.oid AS tableoid, 
	n2.nspname AS partitionschemaname, 
	n2.oid AS partitionschemaoid, 
	cl2.relname AS partitiontablename, 
	cl2.oid AS partitiontableoid, 
	pr1.parname AS partitionname, 
	pr1.oid AS partitionoid, 
	cl3.relname AS parentpartitiontablename, 
	cl3.oid AS parentpartitionstableoid, 
	pr2.parname AS parentpartitionname, 
	pr2.oid AS parentpartitionoid, 
	COALESCE(sp.spcname, d.dfltspcname) AS parentspace, 
	COALESCE(sp.oid, NULL::oid) AS parentspaceoid, 
	COALESCE(sp3.spcname, d.dfltspcname) AS partspace, 
	COALESCE(sp3.oid, NULL::oid) AS partitionspaceoid
FROM 
	pg_namespace n, 
	pg_namespace n2, 
	pg_class cl
	LEFT JOIN pg_tablespace sp 
		ON cl.reltablespace = sp.oid, 
	pg_class cl2
	LEFT JOIN pg_tablespace sp3 
		ON cl2.reltablespace = sp3.oid, 
	pg_partition pp, 
	pg_partition_rule pr1
	LEFT JOIN pg_partition_rule pr2 
		ON pr1.parparentrule = pr2.oid
	LEFT JOIN pg_class cl3 
		ON pr2.parchildrelid = cl3.oid, 
	(
		SELECT s.spcname
		FROM pg_database, 
			pg_tablespace s
		WHERE 
			pg_database.datname = current_database() 
			AND pg_database.dattablespace = s.oid) d(dfltspcname)
WHERE 
	pp.paristemplate = false 
	AND pp.parrelid = cl.oid 
	AND pr1.paroid = pp.oid 
	AND cl2.oid = pr1.parchildrelid 
	AND cl.relnamespace = n.oid 
	AND cl2.relnamespace = n2.oid;
