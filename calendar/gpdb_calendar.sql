CREATE SCHEMA gpdb_calendar;

// CREATE BASIC TABLE CALTABLE
DROP TABLE IF EXISTS GPDB_CALENDAR.CALENDAR_DATES;
CREATE TABLE GPDB_CALENDAR.CALENDAR_DATES(
	gpdb_cal_date DATE) 
DISTRIBUTED BY (gpdb_cal_);
