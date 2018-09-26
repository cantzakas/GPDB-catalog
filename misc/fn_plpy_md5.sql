CREATE OR REPLACE FUNCTION plpy_md5(in_str text)
RETURNS text
AS $$
try:
	import hashlib
	m = hashlib.md5()
	m.update(in_str)
	return m.hexdigest()
except ImportError, e:
	return 'FAILURE'
$$ LANGUAGE plpythonu;
