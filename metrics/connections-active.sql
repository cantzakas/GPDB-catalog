-- connections-active.sql
-- Supported Versions: 11 / 10 / 9.6 / 9.5 / 9.4
-- Unsupported versions: 9.3 / 9.2 / 9.1 / 9.0 / 8.4 / 8.3 / 8.2 / 8.1 / 8.0 / 7.4 / 7.3 / 7.2
-- Tested working on GPDB Version: 5.20.1
 
--SELECT	count(*)
--FROM	pg_stat_activity
--WHERE	state = 'active'
 
SELECT	count(*)
FROM	pg_catalog.pg_stat_activity
WHERE	current_query <> '<IDLE>'
AND		NOT waiting;
