DROP FUNCTION public.generate_range_crossmatch(VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, FLOAT, FLOAT, FLOAT);

CREATE OR REPLACE FUNCTION public.generate_range_crossmatch(out_view_name VARCHAR, 
	in_source_l VARCHAR, in_col_list_l VARCHAR, in_field_l VARCHAR, 
	in_source_r VARCHAR, in_col_list_r VARCHAR, in_field_r VARCHAR, 
	in_range_count FLOAT, 
	in_total_width FLOAT, 
	in_overlap_width FLOAT) 
RETURNS VOID 
AS $$
BEGIN
	EXECUTE '
		DROP VIEW IF EXISTS public.' || out_view_name || ';
		CREATE VIEW public.' || out_view_name || ' AS
		WITH enriched1 AS (
			SELECT ' 
				|| in_col_list_l || ', '
				|| in_range_count || ' AS left_range_count,
				( ' || in_total_width || ' /' || in_range_count || '::float) AS left_range_width,' 
				|| in_overlap_width || ' AS left_overlap_width
			FROM '
				|| in_source_l ||
		'),
		enriched2 AS (
			SELECT ' 
				|| in_col_list_r || ', '
				|| in_range_count || ' AS right_range_count,
				( ' || in_total_width || ' /' || in_range_count || '::float) AS right_range_width,'
				|| in_overlap_width || ' AS right_overlap_width
			FROM '
				|| in_source_r ||
		'),
		labeled1 AS (
		SELECT
			*,
			( left_' || in_field_l || ' / left_range_width::float - trunc( left_' || in_field_l || ' / left_range_width )) * left_range_width AS left_range_margin,
			( floor( left_' || in_field_l || ' / left_range_width )::int + left_range_count ) % left_range_count AS left_range_label
			FROM
			enriched1),
		labeled2 AS (
		SELECT
			*,
			( right_' || in_field_r || ' / right_range_width::float - trunc( right_' || in_field_r || ' / right_range_width )) * right_range_width AS right_range_margin,
			( floor( right_' || in_field_r || ' / right_range_width )::int + right_range_count ) % right_range_count AS right_range_label
			FROM
			enriched2),
		overlap_labeled1 AS (
			SELECT
				*,
				CASE WHEN (
					left_range_margin < 0 
					AND left_range_margin > ( 0 - left_overlap_width ))
					OR (
						left_range_margin > ( left_range_width - left_overlap_width ))
				THEN 1
				WHEN (
					left_range_margin > 0
					AND left_range_margin < left_overlap_width)
					OR (
						left_range_margin < ( 0 - left_range_width + left_overlap_width )) 
				THEN -1
				ELSE 0
				END AS left_range_overlap
			FROM
				labeled1),
		all1 AS (
			SELECT *, 
				NULL AS left_range_label_new
			FROM overlap_labeled1 
			UNION ALL 
			SELECT *, 
				left_range_label + left_range_overlap AS left_range_label_new
			FROM
				overlap_labeled1
			WHERE
				left_range_overlap <> 0 )
		
		SELECT
			gdr1.*,
			gdr2.*
		FROM
			all1 AS gdr1,
			labeled2 AS gdr2
		WHERE q3c_join( gdr1.left_ra,
			gdr1.left_dec,
			gdr2.right_ra,
			gdr2.right_dec,
			0.5 / 3600 )
			AND (gdr2.right_dec < gdr1.left_dec + ' || in_overlap_width || ') 
			AND (gdr2.right_dec > gdr1.left_dec - ' || in_overlap_width || ')
			AND gdr2.right_range_label = gdr1.left_range_label_new';
END;
$$
LANGUAGE plpgsql;
