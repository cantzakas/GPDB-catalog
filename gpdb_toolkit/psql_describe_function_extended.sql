CREATE OR REPLACE FUNCTION gpdb_toolkit.psql_describe_function_extended(p_db_name text, p_sch_name text, p_fn_name text) 
RETURNS text
AS $$
    import os
    p = os.popen('psql -U ' + p_db_name + ' -c "\df+ '+ p_sch_name + '.' + p_fn_name + '"')
    return p.read() $$ 
LANGUAGE plpythonu;
