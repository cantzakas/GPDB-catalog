CREATE OR REPLACE FUNCTION gpdb_toolkit.psql_describe_table_extended(p_db_name text, p_sch_name text, p_tbl_name text) 
RETURNS text
AS $$
    import os
    p = os.popen('psql -U ' + p_db_name + ' -c "\d+ '+ p_sch_name + '.' + p_tbl_name + '"')
    return p.read() $$ 
LANGUAGE plpythonu;
