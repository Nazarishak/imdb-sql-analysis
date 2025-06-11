-- 1. Динаміка кількості фільмів і середнього рейтингу по роках
SELECT year,
       COUNT(*) AS num_movies,
       ROUND(AVG(rating), 2) AS avg_rating,
       MIN(rating) AS min_rating,
       MAX(rating) AS max_rating
FROM imdb_top_movies
GROUP BY year
ORDER BY year;






-- 2. ТОП-10 режисерів за кількістю фільмів у топ-250
SELECT directors,
       COUNT(*) AS movie_count,
       ROUND(AVG(rating), 2) AS avg_rating
FROM imdb_top_movies
GROUP BY directors
HAVING COUNT(*) >= 2
ORDER BY movie_count DESC, avg_rating DESC
LIMIT 10;






-- 3. Жанри з найбільшим середнім прибутком (box office - budget)
SELECT genre,
       COUNT(*) AS num_movies,
       ROUND(AVG(budget), 0) AS avg_budget,
       ROUND(AVG(box_office), 0) AS avg_box_office,
       ROUND(AVG(box_office) - AVG(budget), 0) AS avg_profit
FROM imdb_top_movies
WHERE budget IS NOT NULL AND box_office IS NOT NULL
GROUP BY genre
ORDER BY avg_profit DESC;






-- 4. Фільми з найбільшим відхиленням від середнього рейтингу свого року
WITH year_avg AS (
  SELECT year, AVG(rating) AS avg_rating_year
  FROM imdb_top_movies
  GROUP BY year
)
SELECT m.name, m.year, m.rating,
       ROUND(m.rating - y.avg_rating_year, 2) AS deviation_from_year_avg
FROM imdb_top_movies m
JOIN year_avg y ON m.year = y.year
ORDER BY ABS(m.rating - y.avg_rating_year) DESC
LIMIT 15;






-- 5. Найдовші фільми з топ-рейтингом
SELECT name, rating,
       CAST(REPLACE(run_time, ' min', '') AS INTEGER) AS duration
FROM imdb_top_movies
WHERE rating >= 8.8 AND run_time LIKE '%min'
ORDER BY duration DESC
LIMIT 10;

