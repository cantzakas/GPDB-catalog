SELECT datname, 
  CASE WHEN SUM(blks_hit) = 0 THEN NULL ELSE round(sum(blks_hit)*100/sum(blks_hit+blks_read), 2) END as cache_hit_perc 
FROM 
  pg_stat_database 
WHERE 
  datname NOT IN ('template0', 'template1', 'postgres') 
GROUP BY 
  datname;
