#!/bin/bash
#
#  get_partition_indexes.sh
#  cantzakas@pivotal.io - 2016
#  
#

# Function : To extract all user tables' partition indexes.

extr_idx_info_table() {

# echo "INFO - Extracting all the schema, table, partition & index names"
# echo

psql -d $PGDATABASE -p $PGPORT -Atc "SELECT i.tablename, i.indexname FROM ( SELECT n.nspname AS schemaname, n.oid AS schemaoid, c.relname AS tablename, c.oid AS tableoid, i.relname AS indexname FROM pg_index x JOIN pg_class c ON c.oid = x.indrelid JOIN pg_class i ON i.oid = x.indexrelid LEFT JOIN pg_namespace n ON n.oid = c.relnamespace LEFT JOIN pg_tablespace t ON t.oid = i.reltablespace, (SELECT s.spcname FROM pg_database, pg_tablespace s WHERE pg_database.datname = current_database() AND pg_database.dattablespace = s.oid) d(dfltspcname) WHERE c.relkind = 'r'::"char" AND i.relkind = 'i'::"char") i, (SELECT n.nspname AS schemaname, n.oid AS schemaoid, cl.relname AS tablename, cl.oid AS tableoid, cl2.oid AS partitiontableoid FROM pg_namespace n, pg_namespace n2, pg_class cl LEFT JOIN pg_tablespace sp ON cl.reltablespace = sp.oid, pg_class cl2 LEFT JOIN pg_tablespace sp3 ON cl2.reltablespace = sp3.oid, pg_partition pp, pg_partition_rule pr1 LEFT JOIN pg_partition_rule pr2 ON pr1.parparentrule = pr2.oid LEFT JOIN pg_class cl3 ON pr2.parchildrelid = cl3.oid, (SELECT s.spcname FROM pg_database, pg_tablespace s WHERE pg_database.datname = current_database() AND pg_database.dattablespace = s.oid) d(dfltspcname) WHERE pp.paristemplate = false AND pp.parrelid = cl.oid AND pr1.paroid = pp.oid AND cl2.oid = pr1.parchildrelid AND cl.relnamespace = n.oid AND cl2.relnamespace = n2.oid) p WHERE i.schemaoid = p.schemaoid AND (i.tableoid = p.tableoid OR i.tableoid = p.partitiontableoid) GROUP BY 1, 2 ORDER BY 1, 2" > $idx_tbl_info
}

# Function : To extract all the distribution policy.

extr_idx_info() {

# echo "INFO - Extracting the indexes for the collected table "
# echo

cat $idx_tbl_info | while read line
do 
	export t=`echo $line | cut -d'|' -f1`
	export i=`echo $line | cut -d'|' -f2`
	
	echo $t " " $i >> $idx_info

done 

}

# Function : To Print all the all the user tables.

print_idx_info() {

# echo "INFO - Priniting the distribution policy of the table in the database " $PGDATABASE
# echo
echo "----| Index Name and their associated Table Name |----"  
echo

awk 'BEGIN { printf "%-30s %s\n", "TABLE-NAME","INDEX-NAME"
	printf "%-30s %s\n", "-----------","-------------------" }
		{ printf "%-30s %s\n", $1, $2 }' $idx_info
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
export idx_tbl_info=/tmp/table_idx_info
export idx_info=/tmp/idx_info
export junkfile=/tmp/junkfile

# Remove old temporary files.

# echo "INFO - Removing the old / temporary files from previous run, if any"
# echo 

if (test -f $idx_tbl_info)
then
	rm -r $idx_tbl_info > $junkfile 2>> $junkfile
fi

if (test -f $idx_info)
then
	rm -r $idx_info > $junkfile 2>> $junkfile
fi

# Calling the Function to confirm the script execution 

extr_idx_info_table
extr_idx_info
print_idx_info

