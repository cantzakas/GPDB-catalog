-- cache-hits.sql
-- PG Supported Versions: 11 / 10 / 9.6 / 9.5 / 9.4
-- PG Unsupported versions: 9.3 / 9.2 / 9.1 / 9.0 / 8.4 / 8.3 / 8.2 / 8.1 / 8.0 / 7.4 / 7.3 / 7.2
-- Tested working on GPDB Version: 5.20.1

SELECT datname, 
  CASE WHEN SUM(blks_hit) = 0 THEN NULL ELSE round(sum(blks_hit)*100/sum(blks_hit+blks_read), 2) END as cache_hit_perc 
FROM 
  pg_stat_database 
WHERE 
  datname NOT IN ('template0', 'template1', 'postgres') 
GROUP BY 
  datname;
