### Create 2024 bike data table join all data to one table 
CREATE TABLE 2024_bike_data
SELECT * from 03_2024tripdata
UNION
SELECT * FROM 02_2024tripdata
UNION
SELECT * FROM 03_2024tripdata
Union
SELECT * from 04_2024tripdata
UNION
SELECT * FROM 05_2024tripdata
UNION
SELECT * from 07_2024tripdata
UNION
Select * from 08_2024tripdata
UNION
Select * from 09_2024tripdata
Union
Select * from 10_2024tripdata
UNION
SELECT * from 11_2024tripdata
union 
SELECT * FROM 12_2024tripdata
UNION
SELECT * from `06_2024-divvy-tripdata`;
### Drop columns that are not needed for this analysis

Alter Table 2024_bike_data
DROP COLUMN start_lng,
DROP Column start_lat,
DROP COLUMN end_lat,
Drop COLUMN end_lng; 

### Delete rows that carry balnk or null data 

DELETE     
FROM
    2024_bike_data
WHERE
    end_station_name = '' or null;

Delete
 from 2024_bike_data
 Where
 start_station_name = "";
 ### Create column to calculate trip duration for each ride
Alter Table 2024_bike_data
Add Column trip_duration TIME;
    
UPDATE 2024_bike_data 
SET 
    trip_duration = TIMEDIFF(`ended_at`, `started_at`);
#### Create a column for day of week for rides 
Alter Table 2024_bike_data
Add Column day_of_week longtext;

UPDATE 2024_bike_data 
SET 
    day_of_week = DATE_FORMAT(started_at, '%a');
###  Create a column for months for rides
Alter table 2024_bike_data Add COLUMN Month longtext;

UPDATE 2024_bike_data set month = date_format(started_at,'%b');

### Delete rows that have travel time over 24hrs or under 1 second 
DELETE FROM 2024_bike_data 
WHERE
    trip_duration >= TIME_FORMAT('24:00:00', '%T')
    OR trip_duration <= TIME_FORMAT('00:00:01', '%T');
##Analyis

### Number of Member riders is 2686170  Number of Casual riders are 1521226

SELECT member_casual,
	count(ride_id)
FROM 2024_bike_data
GROUP BY member_casual;


###Create table for avg trip time of all bike users 

CREATE TABLE Average_trip1 SELECT SEC_TO_TIME(AVG(TIME_TO_SEC(trip_duration))) AS Average_Trip FROM
    2024_bike_data;
    
#  Average ride time for casual riders. Returned AVG of 23:57 of average ride time for casual riders
SELECT 
    SEC_TO_TIME(AVG(TIME_TO_SEC(trip_duration))) AS AVG_Casual_Ride
FROM
    2024_bike_data
WHERE
    member_casual = 'casual';

# Average ride time for members riders. Returned an AVG of 12:26 of ride time for members
SELECT 
    SEC_TO_TIME(AVG(TIME_TO_SEC(trip_duration))) AS AVG_member_Ride
FROM
    2024_bike_data
WHERE
    member_casual = 'member';

### Average trip duration of user by day  
SELECT 
    member_casual,
    day_of_week,
    SEC_TO_TIME(AVG(TIME_TO_SEC(trip_duration))) AS avg_ridetime_day
FROM
    2024_bike_data
GROUP BY member_casual , day_of_week
ORDER BY member_casual , avg_ridetime_day DESC;

### Created a table to analyze types of riders per user
Create table bike_type_users
SELECT rideable_type, member_casual,
	count(ride_id)
FROM 2024_bike_data
GROUP BY rideable_type, member_casual;

### Number of users per day 
select member_casual, day_of_week, 
count(ride_id) as trips from 2024_bike_data
group by member_casual, day_of_week
order by member_casual, trips desc;

### Number of users by month 
SELECT member_casual, month,
count(ride_id) as rides_per_month
FROM 2024_bike_data
GROUP BY member_casual ,month
order by member_casual, rides_per_month desc;

### Starting station for Casual riders
Select member_casual, start_station_name,
Count(ride_id) as casual_starting_station from 2024_bike_data where member_casual = 'casual'
GROUP BY member_casual, start_station_name
order by member_casual, casual_starting_station desc
limit 10;

### Starting station for member riders
Select member_casual, start_station_name,
Count(ride_id) as member_starting_station from 2024_bike_data where member_casual = 'member'
GROUP BY member_casual, start_station_name
order by member_casual, member_starting_station desc
limit 10;

### Ending station for casual riders

Select member_casual, end_station_name,
Count(ride_id) as Casual_ending_station from 2024_bike_data where member_casual = 'casual'
GROUP BY member_casual, end_station_name
order by member_casual, ending_station desc
limit 10;

### Ending station member riders
Select member_casual, end_station_name,
Count(ride_id) as Member_ending_station from 2024_bike_data where member_casual = 'member'
GROUP BY member_casual, end_station_name
order by member_casual, ending_station desc
limit 10;