CREATE OR REPLACE FUNCTION random_string_generator(int)
RETURNS text
AS $$
SELECT array_to_string(ARRAY(
	SELECT substr(' ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',((random()*(36-1)+1)::integer),1)
	FROM generate_series(1,$1)), '');
$$ LANGUAGE SQL
RETURNS NULL ON NULL INPUT;
