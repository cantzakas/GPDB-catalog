CREATE OR REPLACE FUNCTION gpdb_toolkit.gp_inventory(in_dbname text) 
RETURNS text
AS $$
	import os
	import re

	out_pg_dump = os.popen('/usr/local/greenplum-db/bin/pg_dump -U ' + in_dbname + ' -c -s --gp-syntax ' + in_dbname + ' | sed -e \'s/^--/§/\' | grep -vE \'^SET\'')
	out_db = re.findall(r'^(?:§ Name: )([^;]*)(?:; Type: )([^;]*)(?:; Schema: )([^;]*)(?:; Owner: )([^\s]*)(?:; Tablespace: )?([^\s]*)?\n*$', out_pg_dump.read(), flags = re.MULTILINE)

	out_objs = [v for i, v in enumerate(out_db)]
	out_objs.sort(key = lambda x: (x[1], x[2], x[0]))
	out_objs.insert(0, ('NAME', 'TYPE', 'SCHEMA', None, None))

	out_ = ['%-5s%-20s%-20s%-35s' % ((str(i), str(''))[i == 0], v[1], v[2], v[0]) for i, v in enumerate(out_objs)]

	return '\n'.join(out_) 
$$ LANGUAGE plpythonu;
