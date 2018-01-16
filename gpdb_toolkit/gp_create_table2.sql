CREATE OR REPLACE FUNCTION gpdb_toolkit.gp_create_table2(in_dbname text, in_schema text, in_tblname text) 
RETURNS text
AS $$
    import os
    import re

    out_pg_dump = os.popen('/usr/local/greenplum-db/bin/pg_dump -U ' + in_dbname + ' -c -s --gp-syntax ' + in_dbname + ' | grep  -vE \'^SET\'')
    out_tables = re.findall(r'^(?:--\n-- Name: )([^;]*)(?:; Type: )([^;]*)(?:; Schema: )([^\s]*)(?:; Owner: )([^\s]*)(?:; Tablespace: )([^\s]*)(?:\n--\n)([^-]+-{1}[^-]+|[^-]+)', out_pg_dump.read(), flags = re.MULTILINE)
    
    table_pattern = re.compile(r'^.+\b' + in_tblname + r'{1}\b.+$', re.DOTALL)
    
    out_results = [v[5] for i, v in enumerate(out_tables) if v[2] == in_schema and table_pattern.match(v[5])]

    return 'SET search_path = gptika;' + '\n'.join(out_results) $$ 
LANGUAGE plpythonu;
