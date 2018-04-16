CREATE SCHEMA gpdb_calendar;

// CREATE BASIC TABLE calendar_dates
DROP TABLE IF EXISTS gpdb_calendar.calendar_dates;
CREATE TABLE gpdb_calendar.calendar_dates(
	cal_date DATE) 
DISTRIBUTED BY (cal_date);

//Create view to get calendar date as number/integer
CREATE OR REPLACE VIEW gpdb_calendar.calendar_dates_int
AS
SELECT 
	to_number(to_char(cal_date, 'YYYYMMDD'), '99999999') AS cal_date
FROM 
	gpdb_calendar.calendar_dates;
	
//Create view basic_calendar	
CREATE OR REPLACE VIEW gpdb_calendar.basic_calendar(
  calendar_date,
  day_of_calendar,
  day_of_month,
  day_of_year,
  month_of_year,
  year_of_calendar)
AS  
SELECT
  cal_date,
  case
    when (((cal_date % 10000) / 100) > 2) then
      (146097 * ((cal_date/10000 + 1900) / 100)) / 4
      +(1461 * ((cal_date/10000 + 1900) - ((cal_date/10000 + 1900) / 100)*100) ) / 4
      +(153 * (((cal_date % 10000)/100) - 3) + 2) / 5
      + cal_date % 100 - 693901
    else
      (146097 * (((cal_date/10000 + 1900) - 1) / 100)) / 4
      +(1461 * (((cal_date/10000 + 1900) - 1) - (((cal_date/10000 + 1900) - 1) / 100)*100) ) / 4
      +(153 * (((cal_date % 10000)/100) + 9) + 2) / 5
      + cal_date % 100 - 693901
  end,
  cal_date % 100,
  (case (cal_date % 10000)/100
     when 1  then cal_date % 100
     when 2  then cal_date % 100 + 31
     when 3  then cal_date % 100 + 59
     when 4  then cal_date % 100 + 90
     when 5  then cal_date % 100 + 120
     when 6  then cal_date % 100 + 151
     when 7  then cal_date % 100 + 181
     when 8  then cal_date % 100 + 212
     when 9  then cal_date % 100 + 243
     when 10 then cal_date % 100 + 273
     when 11 then cal_date % 100 + 304
     when 12 then cal_date % 100 + 334 
  end)
  +
  (case 
    when ((((cal_date / 10000 + 1900) % 4 = 0) AND ((cal_date / 10000 + 1900) % 100 <> 0)) OR
         ((cal_date / 10000 + 1900) % 400 = 0)) AND ((cal_date % 10000)/100 > 2) then
      1
    else
      0
  end),
  (cal_date % 10000)/100,
  cal_date/10000
FROM gpdb_calendar.calendar_dates_int;
