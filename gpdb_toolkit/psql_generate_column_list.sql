DROP FUNCTION public.generate_column_list(VARCHAR, VARCHAR, VARCHAR);

CREATE OR REPLACE FUNCTION public.generate_column_list(in_nmspace VARCHAR, in_class VARCHAR, in_prefix_name VARCHAR) 
RETURNS TEXT AS $$
DECLARE
	res TEXT;
BEGIN
	SELECT string_agg(new_column_name, ', ') INTO res
	FROM (
		SELECT pg_attribute.attname::TEXT || ' AS ' || generate_col_list.in_prefix_name || '_' || pg_attribute.attname::TEXT AS new_column_name 
		FROM pg_attribute, pg_class, pg_namespace
		WHERE pg_attribute.attrelid = pg_class.oid
		AND pg_class.relnamespace = pg_namespace.oid
		AND pg_class.relname = generate_col_list.in_class
		AND pg_namespace.nspname = generate_col_list.in_nmspace
		AND pg_attribute.attnum > 0
		ORDER BY attnum) B;
	RETURN res;
END;
$$ LANGUAGE plpgsql; 
