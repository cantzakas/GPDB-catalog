DROP FUNCTION public.generate_view (VARCHAR, VARCHAR, VARCHAR, VARCHAR);

CREATE OR REPLACE FUNCTION public.generate_view(in_schema VARCHAR, in_table VARCHAR, out_schema VARCHAR, out_view VARCHAR) 
RETURNS VOID 
AS $$
BEGIN
  EXECUTE '
    DROP VIEW IF EXISTS ' || out_schema || '.' || out_view || ';
		CREATE VIEW ' || out_schema || '.' || out_view || ' AS
			SELECT * FROM ' || in_schema || '.' || in_table || ';';
END;
$$ LANGUAGE plpgsql;
