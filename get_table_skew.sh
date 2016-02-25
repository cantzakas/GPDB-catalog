#!/bin/bash
#
#  get_partition_indexes.sh
#  cantzakas@pivotal.io - 2016
#  
#

# Function : To extract all user tables' partition indexes.

extr_table_info() {

# echo "INFO - Extracting all the schema, table, partition & index names"
# echo

psql -d $PGDATABASE -p $PGPORT -Atc "SELECT nspname AS namespacename, relname AS tablename FROM pg_class a , pg_namespace b WHERE relkind = 'r' AND b.oid=a.relnamespace AND relname NOT IN ('spatial_ref_sys') AND relnamespace IN (SELECT oid FROM pg_namespace WHERE nspname NOT IN ('gp_toolkit','pg_toast','pg_aoseg','information_schema','pg_catalog', 'madlib') AND nspname NOT LIKE 'pg_temp%') ORDER BY nspname, relname" > $tbl_info
}

# Function : To extract all the distribution policy.

extr_table_skew_info() {

# echo "INFO - Extracting the indexes for the collected table "
# echo

cat $tbl_info | while read line
do 
	export nsp=`echo $line | cut -d'|' -f1`
	export tbl=`echo $line | cut -d'|' -f2`
	
	psql -d $PGDATABASE -p $PGPORT -Atc "SELECT NAMESPACE,
			TABLENAME,
			(MAX(RECORDCOUNT)/NULLIF(AVG(RECORDCOUNT),0))::decimal(8,5) AS SKEW,
			((100 - (AVG(RECORDCOUNT) / NULLIF(MAX(RECORDCOUNT),0) * 100)))::decimal(3,0) AS SKEW_FCTR
		FROM (
			SELECT
				'$nsp' AS NAMESPACE,
				'$tbl' AS TABLENAME,
				COALESCE(s.gp_segment_id, sc.content) AS SEGMENTID,
				COUNT(s.gp_segment_id) AS RECORDCOUNT
			FROM
				gp_segment_configuration sc
				LEFT OUTER JOIN sales_1_prt_12 s
					ON sc.content = s.gp_segment_id
			WHERE
				sc.content > -1
			GROUP BY 
				s.gp_segment_id, sc.content) a
		GROUP BY 
			TABLENAME, NAMESPACE" | grep -v row > $tbl_skew_info
	
	export skew=`cat $tbl_skew_info | cut -d'|' -f3`
	export skew_factor=`cat $tbl_skew_info | cut -d'|' -f4`
	
	echo $nsp " " $tbl " " $skew " " $skew_factor >> $skew_info
done 

}

# Function : To Print all the all the user tables.

print_tbl_skew_info() {

# echo "INFO - Priniting the distribution policy of the table in the database " $PGDATABASE
# echo
echo "------------ User Table Skew Info ------------"  

awk 'BEGIN {
		printf "%-30s %-30s %-30s %s\n",	"SCHEMA NAME"	,"TABLE NAME"	,"SKEW (%)"		,"SKEW FACTOR"
		printf "%-30s %-30s %-30s %s\n",	"------------"	,"------------"	,"------------"	,"------------" }{
		printf "%-30s %-30s %-30s %s\n",	$1				,$2				,$3				,$4}' $skew_info

echo "----------------------------------------------"
}

# Main program starts here
# Checking the parameter passed

# echo
# echo "INFO - Checking the parameter passed for the script: " $0
# echo

if [ $# -lt 2 ]
then
	echo "ERR  - Script cannot execute since one / more parameters is missing"
	echo "ERR  - Usage: $0 { Please provide us the database name & port number }"
	echo "INFO - Example to run is /bin/sh get_partition_indexes.sh template1 5432"
	echo

	exit 1
fi

# Acception of the parameters

# echo "INFO - Passing the parameters passed to variables "
# echo

export PGDATABASE=$1
export PGPORT=$2
export tbl_info=/tmp/tbl_info
export tbl_skew_info=/tmp/tbl_skew_info
export skew_info=/tmp/skew_info
export skew_factor=/tmp/skew_factor
export skew=/tmp/skew
export junkfile=/tmp/junkfile

# Remove old temporary files.

# echo "INFO - Removing the old / temporary files from previous run, if any"
# echo 

if (test -f $tbl_info)
then
	rm -r $tbl_info > $junkfile 2>> $junkfile
fi

if (test -f $tbl_skew_info)
then
	rm -r $tbl_skew_info > $junkfile 2>> $junkfile
fi

if (test -f $skew_info)
then
	rm -r $skew_info > $junkfile 2>> $junkfile
fi

if (test -f $skew_factor)
then
	rm -r $skew_factor > $junkfile 2>> $junkfile
fi

if (test -f $skew)
then
	rm -r $skew > $junkfile 2>> $junkfile
fi
# Calling the Function to confirm the script execution 

extr_table_info
extr_table_skew_info
print_tbl_skew_info

