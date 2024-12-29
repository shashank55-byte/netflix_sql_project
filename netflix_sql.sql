CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
-- 15 Business Problems & Solutions

1. Count the number of Movies vs TV Shows
SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;

2. Find the most common rating for movies and TV shows
WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;

3. List all movies released in a specific year (e.g., 2020)
SELECT * 
FROM netflix
WHERE release_year = 2020;

4. Find the top 5 countries with the most content on Netflix
SELECT * 
FROM
(
    SELECT 
        UNNEST(STRING_TO_ARRAY(country, ',')) AS country,
        COUNT(*) AS total_content
    FROM netflix
    GROUP BY 1
) AS t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5;

5. Identify the longest movie
select * from netflix 
where type = 'Movie' AND duration=(select max(duration) from netflix )


6. Find content added in the last 5 years
SELECT *, 
       TO_DATE(date_added, 'Month DD, YYYY') AS formatted_date
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';


7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
select * from netflix 
where director ILIKE '%Rajiv Chilaka%'


8. List all TV shows with more than 5 seasons
select *
from netflix 
where
type = 'TV Show'
AND
SPLIT_PART(duration,' ',1)::numeric > 5  

9. Count the number of content items in each genre
select 
UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,
count(show_id) as total_content
from netflix 
group by 1 

10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!
select 
EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD, YYYY')) as year,
count(*),
ROUND(count(*)::numeric/(select count(*) from netflix where country = 'India')::numeric*100,2) as avg_content_per_year
from netflix 
where country = 'India'
group by 1

11. List all movies that are documentaries
select * 
from netflix 
where listed_in ILIKE '%Documentaries%'

12. Find all content without a director
select * from netflix 
where director IS NULL

13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select * from netflix 
where casts ILIKE '%Salman Khan%'
AND release_year> EXTRACT(YEAR FROM CURRENT_DATE)-10

14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
select
UNNEST(STRING_TO_ARRAY(casts,',')) as actors,
count(*) as total_content
from netflix 
where country ILIKE '%India'
group by 1 
order by 2 DESC limit 10

15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.

WITH new_table
AS(
select 
*,
CASE 
WHEN 
description ILIKE '%kill%'
or
description ILIKE '%violence%' THEN 'Bad_Content'
ELSE 'Good_	Content'
END category 
from netflix
) 
Select category,
count(*) as total_content 
from new_table 
group by 1








