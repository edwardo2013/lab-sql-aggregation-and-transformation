use sakila;

-- See names of tables
SELECT table_name
FROM information_schema.tables
WHERE table_type='BASE TABLE'
      AND table_schema = 'sakila';

-- 1.1 Determine the shortest and longest movie durations and name the values as max_duration and min_duration.
select min(length) as `min_duration`, 
max(length) as `max_duration`
from film;

-- 1.2 Express the average movie duration in hours and minutes. Don't use decimals.
-- Hint: Look for floor and round functions.
select (floor((round(avg(length))/60)) ) as hour,
      (round(avg(length))%60) as `minutes`, -- modulo operator
      concat(floor(round(avg(length))/60),'h ',(round(avg(length))%60),'mm') as avg_time
from film; -- can also use SEC_TO_TIME(avg(length)*60)

-- 2.1) Calculate the number of days that the company has been operating.
-- Hint: To do this, use the rental table, and the DATEDIFF() function to subtract the earliest date in the rental_date 
-- column from the latest date.
select min(rental_date) as `MIN_DATE`, 
max(rental_date) as `MAX_DATE`, 
datediff(max(rental_date), min(rental_date)) as `days in business`
 from rental;
 
-- 2.2  Retrieve rental information and add two additional columns to show the month and weekday of the rental. 
-- Return 20 rows of results.
select 
*,
month(rental_date) as `rental_month`,
weekday(rental_date) as `rental_weekday`
from rental limit 20;

-- 2.3  Bonus: Retrieve rental information and add an additional column called DAY_TYPE with values 'weekend' or 'workday', 
-- depending on the day of the week. Hint: use a conditional expression.
select 
*,
month(rental_date) as `rental_month`,
weekday(rental_date) as `rental_weekday`,
CASE WHEN weekday(rental_date) in (5,6) then 'weekend'
ELSE 'workday'
END as `DAY_TYPE`
from rental;

/*-- 3 You need to ensure that customers can easily access information about the movie collection. To achieve this, 
retrieve the film titles and their rental duration. If any rental duration value is NULL,replace it with the string 'Not Available'. 
Sort the results of the film title in ascending order. Please note that even if there are currently no null values in the 
rental duration column, the query should still be written to handle such cases in the future. 
Hint: Look for the IFNULL() function.*/
select 
   title,
   IFNULL(rental_duration, 'Not available') as `rental_duration`
 from film;

 /*
 Bonus: The marketing team for the movie rental company now needs to create a personalized email campaign for customers. 
 To achieve this, you need to retrieve the concatenated first and last names of customers, along with the first 3 characters 
 of their email address, so that you can address them by their first name and use their email address to send personalized 
 recommendations. The results should be ordered by last name in ascending order to make it easier to use the data.
 */
 select 
    first_name,
    last_name, 
    email,
    concat(first_name,' ',last_name) as `cust_name`, 
    left(email,3) as `First 3 char of email`
 from customer order by last_name asc;
 
 -- Challenge 2 Next, you need to analyze the films in the collection to gain some more insights. 
 -- Using the film table, determine:
 
 -- 1.1 The total number of films that have been released.
 SELECT 
    COUNT(film_id)
FROM
    film;
 
 -- 1.2  The number of films for each rating.
 SELECT 
    COUNT(rating),
    rating
FROM
    film
GROUP BY rating;

-- 1.3 The number of films for each rating, sorting the results in descending order of the number of films. 
-- This will help you to better understand the popularity of different film ratings and adjust purchasing decisions accordingly.
 SELECT 
    COUNT(rating) as `count of rating`,
    rating
FROM
    film
GROUP BY rating 
order by COUNT(rating) desc;

-- 2 (film tbl) 2.1 The mean film duration for each rating, and sort the results in descending order of the mean duration. 
-- Round off the average lengths to two decimal places. This will help identify popular movie lengths for each category.
select
  round(avg(length),2) as `mean duration`,
  rating
  from film
  group by rating order by avg(length) desc;
  
  -- 2.2 Identify which ratings have a mean duration of over two hours in order to help select films for 
  -- customers who prefer longer movies.
select
  round(avg(length),2) as `mean duration`,
  rating
  from film
  group by rating
  having round(avg(length),2) >= 120
  order by avg(length) desc;
  
 -- 3 Bonus: determine which last names are not repeated in the table actor.
SELECT 
    last_name, 
    COUNT(last_name) as `verify_count`
FROM
    actor
GROUP BY last_name
HAVING COUNT(*) = 1;

-- select * from actor order by last_name asc; -- to check manually