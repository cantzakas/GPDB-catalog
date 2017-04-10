/*	CREATE VIEW public.pg_indexes2	*/
CREATE VIEW public.pg_indexes2 AS
SELECT n.nspname AS schemaname, 
	n.oid AS schemaoid, 
	c.relname AS tablename, 
	c.oid AS tableoid, 
	i.relname AS indexname, 
	i.oid AS indexoid, 
	t.spcname AS tablespace, 
	t.oid AS tablespaceoid
FROM pg_index x
	JOIN pg_class c 
		ON c.oid = x.indrelid
	JOIN pg_class i
		ON i.oid = x.indexrelid
	LEFT JOIN pg_namespace n 
		ON n.oid = c.relnamespace
	LEFT JOIN pg_tablespace t 
		ON t.oid = i.reltablespace, 
	(
		SELECT s.spcname
		FROM pg_database, 
			pg_tablespace s
		WHERE pg_database.datname = current_database() 
			AND pg_database.dattablespace = s.oid
	) d(dfltspcname)
WHERE c.relkind = 'r'::"char"
	AND i.relkind = 'i'::"char";
