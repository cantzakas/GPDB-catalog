# GPDB Catalog Functions

## Table Definition (DDL)
Get EXTERNAL and INTERNAL TABLE DDL definition using pg_dump utility or pg_catalog dictionary table, on either Greenplum or Postgres syntax:
- Get table definition (GPDB style) using 
```
pg_dump --gp-syntax -s -t  <schema>.<table> <database>
```
- Get table definition (GPDB style) using
```
pg_dump -c -s --gp-syntax  + <database>
```
- Get table definition (PG style) using *pg_catalog* table information
- Get table definition using
```
psql \d+ <schema>.<table>
```
### Pending action items
- Check for DDL correctness & completeness - *Single- and multi-level partitioned tables*
- Check for DDL correctness & completeness - *Table indexes*
- Check for DDL correctness & completeness - *Column constraints*
