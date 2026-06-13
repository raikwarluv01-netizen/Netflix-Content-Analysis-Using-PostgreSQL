-- netflix_project 
drop table  if exists netflix;

create table netflix(
show_id VARCHAR(6),
type VARCHAR(20),
title VARCHAR(300),
director VARCHAR(500),
casts VARCHAR(2000),
country VARCHAR(500),
date_added VARCHAR(100),
release_year VARCHAR(10),
rating VARCHAR(20),
duration VARCHAR(50),
listed_in VARCHAR(500),
description TEXT );

select count(show_id) from netflix;


-- 15 Business Problems & Solutions

--1. Count the number of Movies vs TV Shows

select type,
count(*) as Total_content
from netflix
group by type ;




--2. Find the most common rating for movies and TV shows

select type,
rating
from 
(select
   type,
   rating,
   count(*),
   rank() over( partition by type order by count(*) desc) as ranking
   from netflix
   group by 1,2) as t1
   where ranking  = 1
   

--3. List all movies released in a specific year (e.g., 2020)

select * from netflix
where 
 type = 'Movie'
 And
 release_year ='2020';



--4. Find the top 5 countries with the most content on Netflix

select 
 unnest(string_to_array(country,',')as new_country),
 count(show_id) as Total_content
from netflix
group by 1
order ;

--5. Identify the longest movie
 
 select * from netflix
 where 
 type = 'Movie'
 and 
 duration = (select max(duration) from netflix)
 
--6. Find content added in the last 5 years

select * from netflix
where
 to_date(date_added,'month DD,YYYY') >= Current_date-interval '5 years'

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select * from netflix
where 
 director Ilike '%Rajiv Chilaka%'


--8. List all TV shows with more than 5 seasons

select * from netflix
where
   type = 'TV Show'
   and 
   split_part(duration,' ' ,1)::numeric>5 

   



--9. Count the number of content items in each genre

select 
 unnest(string_to_array(listed_in,',')) as genre,
 count(show_id)
 from netflix
 group by 1

--10.Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release!

select
 extract(YEAR from to_date(date_added, 'Month DD,YYYY')) as year,
 count(*) as Yearly_content,
 round(
 count(*)::numeric/(select count(*) from netflix where country = 'India')::numeric*100,2) 
 as avg_content_per_year
 from netflix
 where country = 'India'
 group by 1
 

11. List all movies that are documentaries

select * from netflix
where 
 listed_in ilike '%documentaries%'

12. Find all content without a director

select * from netflix
where 
 director is null


--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT * FROM netflix
WHERE 
	casts LIKE '%Salman Khan%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10



14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select 
 unnest(string_to_array(casts,',')) as actors,
 count(*) as total_content
 from netflix
 where country ilike '%India%'
 group by 1
 order by 2 desc 
 limit 10


15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.


SELECT 
    category,
	TYPE,
    COUNT(*) AS content_count
FROM (
    SELECT 
		*,
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY 1,2
ORDER BY 2