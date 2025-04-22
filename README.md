# Mensahs_Portfolio
# Google Data Analytics Capstone Project: Cyclist Bike Share Case Study
This is a cumulative capstone project that I have completed to conclude my Google Data Analytics course. This work is an accumulation of the skills I have learned, including data accumulation, data cleaning, data manipulation, data analysis, and data visualization.Throughout this project, I have applied various techniques to collect and clean raw data, ensuring its accuracy and reliability. I have also utilized different data manipulation strategies to structure and transform the data, making it suitable for analysis. Using statistical and analytical methods, I have derived meaningful insights and trends from the data. Finally, I have created visualizations to present the findings in an engaging and comprehensible manner. This capstone project serves as a demonstration of my proficiency in data analytics and my ability to apply these skills to real-world scenarios. It showcases my competence in handling data-driven decision-making processes and effectively communicating insights through visual storytelling.

# Introduction

You are a junior data analyst working on the marketing analyst team at Cyclistic, a bike-share
company in Chicago. The director of marketing believes the company’s future success
depends on maximizing the number of annual memberships. Therefore, your team wants to
understand how casual riders and annual members use Cyclistic bikes differently. From these
insights, your team will design a new marketing strategy to convert casual riders into annual
members. But first, Cyclistic executives must approve your recommendations, so they must be
backed up with compelling data insights and professional data visualizations

# Company History 
About the company
In 2016, Cyclistic launched a successful bike-share offering. Since then, the program has grown
to a fleet of 5,824 bicycles that are geotracked and locked into a network of 692 stations across
Chicago. The bikes can be unlocked from one station and returned to any other station in the
system anytime.
Until now, Cyclistic’s marketing strategy relied on building general awareness and appealing to
broad consumer segments. One approach that helped make these things possible was the
flexibility of its pricing plans: single-ride passes, full-day passes, and annual memberships.
Customers who purchase single-ride or full-day passes are referred to as casual riders.
Customers who purchase annual memberships are Cyclistic members.
Cyclistic’s finance analysts have concluded that annual members are much more profitable
than casual riders. Although the pricing flexibility helps Cyclistic attract more customers,
Moreno believes that maximizing the number of annual members will be key to future growth.
Rather than creating a marketing campaign that targets all-new customers, Moreno believes
there is a solid opportunity to convert casual riders into members. She notes that casual riders
are already aware of the Cyclistic program and have chosen Cyclistic for their mobility needs.
Moreno has set a clear goal: Design marketing strategies aimed at converting casual riders into
annual members. In order to do that, however, the team needs to better understand how
annual members and casual riders differ, why casual riders would buy a membership, and how
digital media could affect their marketing tactics. Moreno and her team are interested in
analyzing the Cyclistic historical bike trip data to identify trends.

# StakeHolders
- **Lily Moreno**: The director of marketing and your manager. Moreno is responsible for
the development of campaigns and initiatives to promote the bike-share program.
These may include email, social media, and other channels.
- **Cyclistic marketing analytics team**: A team of data analysts who are responsible for
collecting, analyzing, and reporting data that helps guide Cyclistic marketing strategy.
You joined this team six months ago and have been busy learning about Cyclistic’s
mission and business goals—as well as how you, as a junior data analyst, can help
Cyclistic achieve them.
- **Cyclistic executive team**: The notoriously detail-oriented executive team will decide
whether to approve the recommended marketing program.

# Key Questions 
1. How do annual members and casual riders use Cyclistic bikes differently?
2. Why would casual riders buy Cyclistic annual memberships?
3. How can Cyclistic use digital media to influence casual riders to become members?

# Buisness task
Lily Moreno has tasked me with answering the first question. How do annual members and casual riders use Cyclistic bikes different?

# Prepare 
Involves collecting data and information and ensuring it satisfies necessary parameters.

## Data Collection 
Data was collected from Motivate International Inc., which provided it under this [license](https://divvybikes.com/data-license-agreement). The dataset consists of rides recorded throughout each month of 2024. I retrieved my data from [Trip Data](https://divvy-tripdata.s3.amazonaws.com/index.html) public data. The data satisfies the ROCCC standard which means that it is reliable, original, comprehensive, current, and cited.

 # Process
Due to the large volume of data across the 12 downloaded files, I imported each Excel sheet into a MySQL database. I then merged all datasets into a single table labeled '2024_bike_data.' The next step in the process was to remove columns that were not relevant to this case study, ensuring a streamlined and efficient analysis.

``` CREATE TABLE 2024_bike_data
CREATE TABLE 2024_bike_data
SELECT * from 01_2024tripdata
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
```


The next step in the process was to remove columns that were not relevant to this case study, ensuring a streamlined and efficient analysis.
```
### Drop columns that are not needed for this analysis

Alter Table 2024_bike_data
DROP COLUMN start_lng,
DROP Column start_lat,
DROP COLUMN end_lat,
Drop COLUMN end_lng;
```

I then proceeded to remove columns that were blank or returned null data to ensure data that would be used would not be skewed but empty values. 
```DELETE     
FROM
    2024_bike_data
WHERE
    end_station_name = '' or null;

Delete
 from 2024_bike_data
 Where
 start_station_name = "";
```
Now that I have deleted columns without a start or end station name, I created three new columns to enhance data analysis: one calculating travel time for each ride, one identifying the day of the week, and one indicating the month each ride took place.
```
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
```
I used the 'trip_duration' column to identify and remove rides lasting over 24 hours or under one minute for more accurate data analysis.
``` ### Delete rows that have travel time over 24hrs or under 1 second 
DELETE FROM 2024_bike_data 
WHERE
    trip_duration >= TIME_FORMAT('24:00:00', '%T')
    OR trip_duration <= TIME_FORMAT('00:00:01', '%T');
```
# Analysis 

During this stage of the study, I used various data manipulation strategies to gain a better understanding of the data and its potential insights. A summary of those findings are below:

![Sheet 3](https://github.com/user-attachments/assets/5d7531b2-f63d-47d5-87a3-b2f4fdad970c)

When anaylyzing the rides there were a total of 4,207,396. There were two types of user types for these rides, Casual rides and Member rides. The total of casual rides amounted to 1,521,226 which is 36% percent of the total amount of rides. While member rides amounted to 2,686,170 in total which counts for 64% of those rides. 
```
### Number of Member riders is 2686170  Number of Casual riders are 1521226

SELECT member_casual,
	count(ride_id)
FROM 2024_bike_data
GROUP BY member_casual;
```

![Sheet 17](https://github.com/user-attachments/assets/8c3cd0e3-7fe6-43ed-8d10-d49fffe57696)


Even though member rides outnumbered casual rides throughout the year, the average ride time for casual riders was significantly higher at 23 minutes and 57 seconds, compared to 12 minutes and 27 seconds for member rides.
```
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
```

![Sheet 8 (2) (1)](https://github.com/user-attachments/assets/5d479f9c-63a4-47b3-a13b-a0db64bc0413)



- Casual rides occurred most often on Saturdays and Sundays, with 14% of total rides happening on weekends. In contrast, casual rides were much lower during weekdays, staying below 5% of total rides from Monday through Thursday.
- Member rides were more frequent on weekdays, peaking on Wednesdays and accounting for 11% of total rides. Throughout the week, member rides consistently remained above 10% of total rides, but dipped on weekends to around 7%.





![Sheet 16](https://github.com/user-attachments/assets/4e17bc66-306c-466e-9460-adbea548966a)

  
- Casual rides througout the entire week were much longer than than member rides. The longest rides were on Sundays averaging 33 minutes per ride while the longest member rides were on Saturdays averaging 15 minutes.
- Member rides were consitnely at 12-13 minutes during the weekday



![Average Trip Duration ](https://github.com/user-attachments/assets/5840ec5b-5a98-42cc-9235-3a2b2f9f9ae9)


- Casual rides saw a noticeable increase in average duration during the summer, peaking in May at around 33 minutes and staying near 30 minutes from April to August. The shortest average duration occurred in December, dropping to 16 minutes. 
- In contrast, member rides remained relatively consistent throughout the year, ranging from 10 to 14 minutes, with the longest average duration in June and the shortest in December.

![Total Trip by User Type Per Month](https://github.com/user-attachments/assets/f3abe940-b4fb-45cb-8ade-679f334c94b3)



- Both user types followed similar patterns throughout the year: ride numbers were low at the beginning of the year, gradually increased through spring, summer, and fall, then declined in late fall and into winter. 
- Casual rides peaked in July with 231,925 rides and hit their lowest point in January with 17,701 rides. 
- Member rides peaked in September with 320,833 rides and also had their lowest in January, with 96,401 rides.






# Share

To effectively present insights from the Cyclistic Bike Share data, I designed clear and engaging visualizations that support easier interpretation and decision-making for stakeholders.I've developed [interactive dashboards](https://public.tableau.com/views/2024BikeData/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link) to allow for deliver quick, accessible insights.
 

![Dashboard 1](https://github.com/user-attachments/assets/abbd2735-44ec-45ae-8420-9c3481941b0f)  ![Dashboard 2](https://github.com/user-attachments/assets/c42b265d-ab04-4c46-bcf5-76a884b47a83)




# Act

In this final phase, I have developed recommendations to address the business task, drawing on data insights, visualizations, and my overall analysis. The recommendations are as follows:



- I recommend the 'Weekday Ride & Reward Program'  to incentivize casual riders to choose weekday rides by offering tangible rewards. This initiative involves launching a loyalty program that tracks rides taken from Monday through Friday. Riders can earn tiered rewards—such as coffee shop gift cards, discounts on bike gear, or free ride credits—by completing a set number of weekday rides each month. To keep engagement high, the program will also include themed ride challenges like “Midweek Miles” or “Friday Freedom,” which offer bonus incentives. Progress and upcoming rewards will be communicated through app notifications and targeted email marketing. 

- I recommend implementing the “Weekend Double Points” incentive program to increase weekend member rides, which currently see only a slight increase compared to casual riders who experience a larger boost. By offering double reward points for rides taken on Saturdays and Sundays, members can redeem these points for rewards like discounted memberships, bike gear, or entries into local experience raffles. This program targets a shift in riding habits from weekday commutes to more weekend leisure trips.

- Based on seasonal ridership trends, I recommend a winter engagement strategy to maintain usage during colder months, particularly among casual riders who experience the largest decline. This includes incentivizing consistent riding through a weekly ride challenge, bundling casual passes with discounted winter gear, and promoting short routes to warm destinations like cafés and museums. To address station-specific drop-offs, targeted digital ads can highlight cozy routes near Kingsbury & Kinzie for casual riders, while push notifications with weather updates and ride streak tracking can support member riders at DuSable & Monroe. This data-informed approach is designed to stabilize winter ridership and support year-round engagement.
