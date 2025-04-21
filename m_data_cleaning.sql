use portfolio_project;

-- truncating table because it was imported partially using data wizard
truncate table melb_data;

-- importing file using LOAD DATA local Infile
LOAD DATA local Infile 'C:/Users/TOLK/Downloads/melb_data.csv'
Into table melb_data
Fields Terminated by ","
Enclosed by '"'
lines terminated by "\n"
ignore 1 rows;

-- checking all rows to ensure data is loaded correctly
Select * from melb_data;

-- we have a datatype problems with few columns in our table
-- Fixing date (text to date) 
select date, str_to_date(date, '%d/%m/%Y') from melb_data;

-- creating new column for fixed date values
alter table melb_data add column fixed_Date date after date;

-- now we will populate the new column with converted date values
SET SQL_SAFE_UPDATES = 0;
update melb_data set fixed_date = str_to_date(date, '%d/%m/%Y');

-- Fixing BuildingArea (text to int) and yearbuilt (text to int)
select buildingarea, yearbuilt from melb_data;

-- checking for empty or missing values in yearbuilt and buildingarea columns
select count(yearbuilt)/13580 from melb_data
Where yearbuilt = '';

select count(buildingarea)/13580 from melb_data
Where buildingarea = '';

-- we have almost 50% missing values in these two columns, and we will handle them now
-- filling missing values with average values for both columns
select avg(yearbuilt) from melb_data where yearbuilt != ''; -- average is 1965
select avg(buildingarea) from melb_data where buildingarea != '';  -- average is 146

-- filling missing yearbuilt and buildingarea with average values
update melb_data set yearbuilt = 1965 where yearbuilt = '';
update melb_data set buildingarea = 146 where buildingarea = '';

-- now let's check for outliers in our dataset
select max(lattitude), min(lattitude) from melb_data;
select max(rooms), min(rooms) from melb_data;

-- 10 rooms is unusually large; let's explore this on maps or real estate sites
select * from melb_data 
order by rooms desc limit 1;

-- This is indeed a very large house with 10 rooms, which seems reasonable
select min(landsize), max(landsize), avg(landsize) from melb_data;

-- we have strange values for landsize (0 and 433014); let's investigate further
select * from melb_data where landsize = 0; -- 2000 rows
select * from melb_data where landsize > 10000; -- returns 20 rows, could be outliers

-- we will replace landsize values greater than 10000 or equal to 0 with the average value
update melb_data set landsize = 460 where landsize > 10000 or landsize = 0; -- 460 is the average value

-- now let's check for rows where bedroom2 is set to 0, which is not possible
select count(bedroom2) from melb_data where bedroom2 = 0; -- 16 rows with 0 bedrooms, impossible

-- deleting rows with 0 bedrooms as they are clearly erroneous
delete from melb_data where bedroom2 = 0;

-- checking for any unusual yearbuilt values
select max(yearbuilt), min(yearbuilt) from melb_data; -- year 1196 seems incorrect, let's explore that

-- exploring the case for yearbuilt = 1196
select * from melb_data where yearbuilt = 1196;

-- replacing yearbuilt values of 1196 with the average yearbuilt (1965)
update melb_data set yearbuilt = 1965 where yearbuilt = 1196;

-- let's clean up any duplicate entries in the dataset
-- first, creating an id column to identify duplicates easily
ALTER TABLE melb_data
ADD COLUMN id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;

-- checking for duplicates based on certain columns (fixed_date, address, type, price)
with dupes as (select *, row_number() over(partition by fixed_date, address, Type, price) as rn from melb_data)

-- Uncomment the line below to see duplicates before deleting them
-- Select * from dupes where rn > 1;

-- deleting duplicate entries
delete from melb_data 
where id in (select id from dupes where rn > 1);

-- councilarea column has some missing values, which we don’t need for this analysis, so we will drop it
alter table melb_data drop column councilarea;

-- now, let's fix datatypes of some columns to be more logical
alter table melb_data modify yearbuilt INT;
alter table melb_data modify buildingarea INT;
alter table melb_data modify propertycount INT;
alter table melb_data modify car INT;
alter table melb_data modify bathroom INT;
alter table melb_data modify bedroom2 INT;
alter table melb_data modify postcode INT;

-- cleaning up the temporary id column we added earlier
alter table melb_data drop column id;

-- final check to ensure everything looks good
select * from melb_data;
