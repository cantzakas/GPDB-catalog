CREATE OR REPLACE FUNCTION random_num_generator(int)
RETURNS bigint
AS $$
SELECT array_to_string(ARRAY(
	SELECT substr('0123456789',((random()*(10-1)+1)::integer),1)
	FROM generate_series(1, $1)), '')::bigint;
$$ LANGUAGE SQL
RETURNS NULL ON NULL INPUT;
