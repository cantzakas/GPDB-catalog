SELECT (gp_toolkit.gp_skew_details(usr.relid)).*, pg_namespace.nspname, pg_class.relname, now()::timestamp
FROM pg_stat_user_tables usr 
INNER JOIN pg_catalog.pg_class
	ON pg_class.oid = usr.relid
INNER JOIN pg_catalog.pg_namespace
	ON pg_namespace.oid = pg_class.relnamespace
LEFT OUTER JOIN pg_catalog.pg_exttable ext 
	ON ext.reloid = usr.relid
WHERE ext.reloid IS NULL
