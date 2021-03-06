# GPDB Catalog Functions

**Updated as of _15 August 2018_**

## GP Inventory
- **```gp_inventory(database-name):```** returns a list of objects in Greenplum in user database with name `<database-name>` in the format `<TYPE> <SCHEMA> <NAME>`. That said, objects in system databases, such as `gp_toolkit`, `information_schema`, `pg_aoseg`, `pg_bitmapindex` and `pg_catalog` are not returned in this report.

## Tables
1. Get list of tables in schema:
- **```gp_non_partitioned_tables:```** Returns a list (schema name, table name) of all, non-partitioned tables in $schema
2. Get TABLE (incl. EXTERNAL) DDL definition using pg_dump utility or pg_catalog dictionary table, on either Greenplum or Postgres syntax:
- **```gp_show_table(database-name, schema-name, table-name):```** get table definition (GPDB style) using `pg_dump -c -s --gp-syntax <database-name>`, including those for single and multi-level partitioned tables, table indexes and column constraints such as `CHECK(<constraint>)`, `NOT NULL`, `UNIQUE` & `PRIMARY KEY`.
- **```gp_create_table(database-name, schema-name, table-name):```** get table definition (GPDB style) using `pg_dump --gp-syntax -s -t <schema-name>.<table-name> <database-name>`
- **```pg_create_table(schema-name, table-name):```**: get table definition (PG style) using `pg_catalog` and other related dictionary table information
- **```psql_describe_table(database-name, schema-name, table-name):```** get table definition using `psql \d <schema-name>.<table-name>`
- **```psql_describe_table_extended(database-name, schema-name, table-name):```** get extended table definition using `psql \d+ <schema-name>.<table-name>`

#### Pending action items
- Check for completness & correctness: _CREATE TABLE <new_table_name> AS <template_table_name>_ definitions

## User-Defined Functions
Get UDF DDL definition using pg_dump or psql utility:
- Get UDF definition using `psql \df <schema>.<function>`
- Get extended UDF definition using `psql \df+ <schema>.<function>`

#### Pending action items
- Get UDF definition using `pg_dump -c -s --gp-syntax <database>`

## User-Defined Types
Get UDT DDL definition using pg_dump or psql utility:
- Get UDT definition using `psql \dT+ <schema>.<type>`
- Get extended UDT definition using `psql \dT+ <schema>.<type>`

#### Pending action items
- Get UDT definition using `pg_dump -c -s --gp-syntax <database>`


## Other Types of Database Objects - still pending, prioritized
- Index
- Database
- Schema
- View
- User
- Extension
- Language
- Resource Group
- Resource Queue
- Role
- Rule
- Sequence
- Tablespace

## Other Types of Database Objects - still pending, non-prioritized
- Aggregate
- Cast
- Conversion
- Domain
- Group
- Operator
- Operator Class
- Operator Family
- Protocol
