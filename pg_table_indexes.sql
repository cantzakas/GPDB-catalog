/* CREATE VIEW public.pg_table_indexes	*/

CREATE VIEW public.pg_table_indexes AS 

SELECT i.schemaname, 
	p.tablename AS basetablename, 
	i.tablename, 
	i.indexname 
FROM pg_indexes2 i, 
	pg_partitions2 p 
WHERE i.schemaoid = p.schemaoid 
	AND (i.tableoid = p.tableoid 
		OR i.tableoid = p.partitiontableoid) 
GROUP BY
	1, 2, 3, 4 
ORDER BY
	1, 2, 3, 4;
