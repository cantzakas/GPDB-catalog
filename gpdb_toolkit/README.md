# GPDB Catalog Functions

**Updated as of _12 January 2018_**

## Tables
Get EXTERNAL and INTERNAL TABLE DDL definition using pg_dump utility or pg_catalog dictionary table, on either Greenplum or Postgres syntax:
- Get table definition (GPDB style) using `pg_dump --gp-syntax -s -t <schema>.<table> <database>`
- Get table definition (GPDB style) using `pg_dump -c -s --gp-syntax <database>`
- Get table definition (PG style) using `pg_catalog` and other similar dictionary table information
- Get table definition using `psql \d <schema>.<table>`
- Get extended table definition using `psql \d+ <schema>.<table>`

#### Pending action items
- Check for table DDL correctness & completeness:
  - Single- and multi-level partitioned tables
  - Table indexes
  - Column constraints

## User-Defined Functions
Get UDF DDL definition using pg_dump or psql utility:
- Get UDF definition using `psql \df <schema>.<function>`
- Get extended UDF definition using `psql \df+ <schema>.<function>`

#### Pending action items
- Get function definition using `pg_dump -c -s --gp-syntax <database>`

## User-Defined Types
Get UDT DDL definition using pg_dump or psql utility:
- Get UDT definition using `psql \dT+ <schema>.<type>`
- Get extended UDT definition using `psql \dT+ <schema>.<type>`

#### Pending action items
- Get function definition using `pg_dump -c -s --gp-syntax <database>`
