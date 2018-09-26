CREATE OR REPLACE FUNCTION plpy_hash(in_str text, in_alg text)
RETURNS text
AS $$
try:
	import hashlib
	if in_alg in ["md5", "sha1", "sha224", "sha256", "sha384", "sha512"] :
		if in_alg == "md5" : m = hashlib.md5() 
		elif in_alg == "sha1" : m = hashlib.sha1()
		elif in_alg == "sha224" : m = hashlib.sha224()
		elif in_alg == "sha256" : m = hashlib.sha256()
		elif in_alg == "sha384" : m = hashlib.sha384()
		elif in_alg == "sha512" : m = hashlib.sha512()
	m.update(in_str)
	return m.hexdigest()
except Exception, e:
	return 'FAILURE'
$$ LANGUAGE plpythonu;
