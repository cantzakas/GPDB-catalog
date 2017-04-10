select oid,oid::regclass as table_name,nb_datafile,nb_rows_hidden,nb_rows_total
from
	(select 
		oid
		,count(distinct (aoinfo::gp_toolkit.__gp_aovisimap_hidden_t).seg) as nb_datafile
		,sum((aoinfo::gp_toolkit.__gp_aovisimap_hidden_t).hidden) as nb_rows_hidden
		,sum((aoinfo::gp_toolkit.__gp_aovisimap_hidden_t).total) as nb_rows_total
	from 
		(select 
			c.oid,relnamespace,relname as table_name,gp_segment_id 
			, (gp_toolkit.__gp_aovisimap_hidden_typed(oid)) as aoinfo
		FROM gp_dist_random('pg_class') c
		where c.relstorage in ('a','c')
		and relnamespace not in (select oid from pg_namespace where nspname in ('pg_catalog','information_schema','gp_toolkit','p_muster'))
		--and relnamespace in (select oid from pg_namespace where nspname = 'daisy_20150418')
		--and relname like 'tmp_verd_ppu_prod_agt_dm_0001'
	) T
	group by 1
	)T2
where nb_datafile > 1
or nb_rows_hidden > 100000
order by nb_datafile desc, nb_rows_hidden desc
limit 100;
