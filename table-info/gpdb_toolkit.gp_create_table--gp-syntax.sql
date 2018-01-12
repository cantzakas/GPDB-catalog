CREATE OR REPLACE FUNCTION gpdb_toolkit.gp_create_table(p_db_name text, p_sch_name text, p_tbl_name text) 
RETURNS text
AS $$
    import os
    p = os.popen('/usr/local/greenplum-db/bin/pg_dump --gp-syntax -s -t ' + p_sch_name + '.' + p_tbl_name + ' ' + p_db_name)
    return p.read() $$ 
LANGUAGE plpythonu;
