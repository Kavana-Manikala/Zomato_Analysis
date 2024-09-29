Use zomato_analysis;

SET SQL_SAFE_UPDATES = 0;

UPDATE zomato
  SET Datekey_Opening = REPLACE(Datekey_Opening,'_','/')
  WHERE Datekey_Opening LIKE '_';
  
alter table zomato modify column Datekey_Opening date;
select * from zomato;
  
 -- #2.
select year(Datekey_Opening) years,
month(Datekey_Opening)  months,
day(datekey_opening) day ,
monthname(Datekey_Opening) monthname,
Quarter(Datekey_Opening)as quarter,
concat(year(Datekey_Opening),'-',monthname(Datekey_Opening)) yearmonth, 
weekday(Datekey_Opening) weekday,
dayname(datekey_opening)dayname, 

case when monthname(datekey_opening) in ('January' ,'February' ,'March' )then 'Q1'
when monthname(datekey_opening) in ('April' ,'May' ,'June' )then 'Q2'
when monthname(datekey_opening) in ('July' ,'August' ,'September' )then 'Q3'
else  'Q4' end as quarters,

case when monthname(datekey_opening)='January' then 'FM9' 
when monthname(datekey_opening)='January' then 'FM10'
when monthname(datekey_opening)='February' then 'FM11'
when monthname(datekey_opening)='March' then 'FM12'
when monthname(datekey_opening)='April'then'FM1'
when monthname(datekey_opening)='May' then 'FM2'
when monthname(datekey_opening)='June' then 'FM3'
when monthname(datekey_opening)='July' then 'FM4'
when monthname(datekey_opening)='August' then 'FM5'
when monthname(datekey_opening)='September' then 'FM6'
when monthname(datekey_opening)='October' then 'FM7'
when monthname(datekey_opening)='November' then 'FM8'
when monthname(datekey_opening)='December'then 'FM9'
end Financial_months,

case when monthname(datekey_opening) in ('January' ,'February' ,'March' )then 'Q4'
when monthname(datekey_opening) in ('April' ,'May' ,'June' )then 'Q1'
when monthname(datekey_opening) in ('July' ,'August' ,'September' )then 'Q2'
else  'Q3' end as financial_quarters

from zomato;

Select * from country;

#3.Find the Numbers of Resturants based on City and Country.
select country.countryname,zomato.city,count(restaurantid) no_of_restaurants
from zomato join country 
on zomato.countrycode=country.countryid 
group by country.countryname,zomato.city;

#4.Numbers of Resturants opening based on Year , Quarter , Month.
select year(datekey_opening)year,
quarter(datekey_opening)quarter,
monthname(datekey_opening)monthname,
count(restaurantid)as no_of_restaurants 
from zomato group by year(datekey_opening),quarter(datekey_opening),monthname(datekey_opening) 
order by year(datekey_opening),quarter(datekey_opening),monthname(datekey_opening) ;

#5. Count of Resturants based on Average Ratings.
select case when rating <=2 then "0-2" when rating <=3 then "2-3" when rating <=4 then "3-4" when Rating<=5 then "4-5" end rating_range,count(restaurantid) no_of_restaurants
from zomato
group by rating_range 
order by rating_range;

#7.Percentage of Resturants based on "Has_Table_booking"
select has_online_delivery, concat(round(count(Has_Online_delivery)/100,1),"%") percentage 
from zomato 
group by has_online_delivery;

#8.Percentage of Resturants based on "Has_Online_delivery"
select has_table_booking,concat(round(count(has_table_booking)/100,1),"%") percentage 
from zomato 
group by has_table_booking;


# highest rating restaurants in each country 
-- select  country_name,restaurantname,max(rating)highest_rating from sheet1 inner join sheet2 on
 -- sheet1.country_code=sheet2.countryid
-- group by sheet2.country_name;

# top 5 restaurants who has more number of votes
select  countryname, restaurantname, votes, Average_Cost_for_two from zomato inner join country on 
zomato.countrycode = country.countryid
group by country.countryname, restaurantname, votes, Average_Cost_for_two
order by votes desc limit 5;

# Style of Food in Different retaurent
SELECT 
  SUBSTRING_INDEX(cuisines, ',',1) AS split
FROM zomato;

# Style of food based on Retaurent
SELECT 
  restaurantname, cuisines,
  SUBSTRING_INDEX(cuisines, ',', 1) AS cuisine1,
  SUBSTRING_INDEX(SUBSTRING_INDEX(cuisines, ',', 2), ',', -1) AS cuisine2,
SUBSTRING_INDEX(SUBSTRING_INDEX(cuisines, ',', 3), ',', -1) AS cuisine3
FROM zomato;
