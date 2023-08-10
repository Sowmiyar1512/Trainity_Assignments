SELECT * FROM moviesp.cleanedm;
use moviesp;
SELECT 
    director_name,
    movie_title,
    ROUND(budget, 0) AS budget,
    ROUND(gross - budget, 0) AS profit
FROM
    moviesp.cleanedm
ORDER BY gross - budget DESC
LIMIT 10;

SELECT row_number() over(order by imdb_score DESC, num_voted_users DESC) as ranking,   
imdb_score, num_voted_users, movie_title AS IMDb_Top_250, language 
FROM moviesp.cleanedm
WHERE num_voted_users > 30000 
LIMIT 250;
 
 SELECT row_number() over(order by imdb_score DESC, num_voted_users DESC) as ranking,  
 imdb_score, num_voted_users, movie_title AS Top_non_english, language 
 FROM moviesp.cleanedm
 WHERE num_voted_users > 30000  and language <> 'English' LIMIT 40;
 
SELECT 
    director_name AS Top_10_Director,
    ROUND(AVG(imdb_score), 2) AS avg_rating
FROM
    moviesp.cleanedm
GROUP BY director_name
ORDER BY avg_rating DESC , director_name
LIMIT 10;
 
 use moviesp;
 With d8 as
 (SELECT *, (CASE WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 8), '|', -1) = genre_1 THEN NULL 
 WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 8), '|', -1) = genre_2 THEN NULL
 WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 8), '|', -1) = genre_3 THEN NULL 
 WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 8), '|', -1) = genre_4 THEN NULL
 WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 8), '|', -1) = genre_5 THEN NULL
 WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 8), '|', -1) = genre_6 THEN NULL
 WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 8), '|', -1) = genre_7 THEN NULL
 ELSE SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 8), '|', -1) END) AS genre_8 
 FROM
 (SELECT *, (CASE WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 7), '|', -1) = genre_1 THEN NULL
 WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 7), '|', -1) = genre_2 THEN NULL
 WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 7), '|', -1) = genre_3 THEN NULL
 WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 7), '|', -1) = genre_4 THEN NULL
 WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 7), '|', -1) = genre_5 THEN NULL
  WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 7), '|', -1) = genre_6 THEN NULL
  ELSE SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 7), '|', -1) END) AS genre_7 
  FROM
  (SELECT *, (CASE WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 6), '|', -1) = genre_1 THEN NULL
  WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 6), '|', -1) = genre_2 THEN NULL
  WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 6), '|', -1) = genre_3 THEN NULL
  WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 6), '|', -1) = genre_4 THEN NULL
  WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 6), '|', -1) = genre_5 THEN NULL
  ELSE SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 6), '|', -1) END) AS genre_6
  FROM
  (SELECT *, (CASE WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 5), '|', -1) = genre_1 THEN NULL
  WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 5), '|', -1) = genre_2 THEN NULL
  WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 5), '|', -1) = genre_3 THEN NULL
  WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 5), '|', -1) = genre_4 THEN NULL
  ELSE SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 5), '|', -1) END) AS genre_5
  FROM(SELECT *, (CASE WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 4), '|', -1) = genre_1 THEN NULL
  WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 4), '|', -1) = genre_2 THEN NULL
  WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 4), '|', -1) = genre_3 THEN NULL
  ELSE SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 4), '|', -1) END) AS genre_4 
  FROM
  (SELECT *,(CASE WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 3), '|', -1) = genre_1 THEN NULL
  WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 3), '|', -1) = genre_2 THEN NULL
  ELSE SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 3), '|', -1) END) AS genre_3
  FROM
  (SELECT *, (CASE WHEN SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 2), '|', -1) = genre_1 THEN NULL
  ELSE SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', 2), '|', -1) END) AS genre_2
  FROM 
  (SELECT SUBSTRING(genres, 2) as genres, SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING(genres, 2), '|', 1), '|', - 1) AS genre_1 
  FROM moviesp.cleanedm) d1) d2) d3) d4) d5) d6) d7),
  list as
  (SELECT DISTINCT genre_1 AS genre_list
  FROM 
  (
  (SELECT genre_1 FROM d8) UNION ALL
  (SELECT genre_2 FROM d8) UNION ALL
  (SELECT genre_3 FROM d8) UNION ALL
  (SELECT genre_4 FROM d8) UNION ALL 
  (SELECT genre_5 FROM d8) UNION ALL 
  (SELECT genre_6 FROM d8) UNION ALL
  (SELECT genre_7 FROM d8) UNION ALL
  (SELECT genre_8 FROM d8)) g12 
  WHERE genre_1 IS NOT NULL ORDER BY genre_1)     
  SELECT genre_list,round(AVG(DISTINCT CASE WHEN INSTR(genres, genre_list) THEN gross ELSE NULL END), 2) AS avg_grossing,    
  COUNT(DISTINCT CASE WHEN INSTR(genres, genre_list) THEN genres ELSE NULL END) AS no_of_movies 
  FROM cleanedm JOIN list 
  GROUP BY genre_list 
  ORDER BY avg_grossing DESC;
  
  SELECT actor_1_name, COUNT(movie_title) AS no_of_movies,
  ROUND(AVG(num_user_for_reviews), 2) AS user_reviews,
  ROUND(AVG(num_critic_for_reviews), 2) AS critic_reviews
  FROM
  (
  (SELECT actor_1_name, movie_title,num_user_for_reviews, num_critic_for_reviews    
  FROM moviesp.cleanedm     
  WHERE actor_1_name = 'Meryl Streep')
  UNION ALL 
  (SELECT actor_1_name, movie_title,num_user_for_reviews, num_critic_for_reviews    
  FROM moviesp.cleanedm   
  WHERE actor_1_name = 'Leonardo DiCaprio')   
  UNION ALL
  (SELECT actor_1_name, movie_title, num_user_for_reviews, num_critic_for_reviews    
  FROM moviesp.cleanedm
  WHERE actor_1_name = 'Brad Pitt')) c
  GROUP BY actor_1_name
  ORDER BY user_reviews DESC , critic_reviews DESC;
  
 SELECT 
    CONCAT(CONVERT( FLOOR(title_year / 10) * 10 , CHAR),
            's') AS decade,
    SUM(num_voted_users) AS total_votes
FROM
    moviesp.cleanedm
GROUP BY decade
ORDER BY decade;