--Birthyear
SELECT name FROM movies WHERE year=1985;
--1982--------------------------------------------------------------
SELECT * FROM movies GROUP BY year --this will give us a table with one row for every year. We only 
--see the first movies from every wyear in each row(without the count funcitoin). It is king of making
--metatables 
SELECT year, COUNT(*) FROM movies GROUP BY year;
SELECT count(*) FROM movies WHERE year=1982;
--Stacktors
SELECT first_name, last_name FROM actors where last_name LIKE '%stack%';


--Fame Name Game------------------
--first name 
SELECT first_name, COUNT(*) as occurances 
FROM actors 
GROUP BY first_name
ORDER BY occurances DESC
LIMIT 10;
--last name
SELECT last_name, COUNT(*) as occurances 
FROM actors 
GROUP BY last_name
ORDER BY occurances DESC
LIMIT 10;

--full name 
SELECT first_name ||' '|| last_name as full_name, COUNT(*) as occurances
FROM actors
GROUP BY full_name
ORDER BY occurances DESC
LIMIT 10;

--- Prolific--------------------------------------------

SELECT actor_id, first_name ||' '|| last_name as full_name,  COUNT (*) as occurrences 
FROM roles 
JOIN actors ON actor_id = actors.id
GROUP BY actor_id
ORDER BY occurrences DESC
LIMIT 100;
            ---OR----

SELECT first_name, last_name, count(*) as num_roles
FROM actors
INNER JOIN roles ON actors.id = roles.actor_id
GROUP BY actors.id
ORder BY num_roles DESC
LIMIT 100;

--Bottom of the Barrel-----------------------------
---- some movies generes point ot movie that have never been made "are not in our moies table"
SELECT genre, count(movie_id) as occurrences
FROM movies_genres
JOIN movies ON movies_genres.movie_id=movies.id
GROUP BY genre
ORDER BY occurrences;


---BRAVEHEART--------------
SELECT first_name,last_name
FROM roles 
JOIN actors ON roles.actor_id=actors.id
JOIN movies ON roles.movie_id=movies.id
WHERE name='Braveheart' AND year=1995
ORDER BY last_name;


---LEAP NOIR---------
SELECT first_name, last_name, name, year
FROM movies_genres
JOIN movies on movies_genres.movie_id=movies.id
JOIN movies_directors on movies_genres.movie_id = movies_directors.movie_id
JOIN directors on movies_directors.director_id = directors.id
WHERE genre = 'Film-Noir' and year%4=0;

---BACON ---------------REVIEW THIS!!!!
    SELECT  m.name, first_name, last_name
    FROM ROLES AS r 
    JOIN movies AS m on r.movie_id=m.id
    JOIN movies_genres AS mg on r.movie_id=mg.movie_id
    JOIN actors on r.actor_id=actors.id
    WHERE r.movie_id IN (
        SELECT  movie_id
        FROM  roles 
        JOIN actors ON roles.actor_id = actors.id
        JOIN movies ON roles.movie_id = movies.id
        Where  actor_id = (SELECT id
        FROM actors 
        WHERE first_name='Kevin' AND last_name='Bacon'
        )
    ) 
    AND GENRE='Drama'
    AND first_name <> 'Kevin'
    AND last_name <> 'Bacon'
    ORDER BY m.name DESC
    ;
    --FROM VIDEO
    SELECT *, a.first_name || " " || a.last_name AS full_name
    FROM actors AS a 
        INNER JOIN roles AS r ON r.actor_id=a.id
        INNER JOIN movies AS m ON r.movie_id=m.id
        INNER JOIN movies_genres AS mg
            ON mg.movie_id =m.id
            AND mg.genre = 'Drama'
    WHERE m.id IN (
        SELECT m2.id
        FROM movies AS m2
            INNER JOIN roles AS r2 ON r2.movie_id = m2.id
            INNER JOIN actors AS a2
            ON r2.actor_id= a2.id
            AND a2.first_name ='Kevin'
            AND a2.last_name = 'Bacon'
    )
    AND full_name != 'Kevin Bacon';

    ----IMORTALS--------------

    SELECT first_name, last_name, actors.id
    FROM actors
        JOIN roles ON roles.actor_id= actors.id
        JOIN movies ON movies.id=roles.movie_id
    WHERE movies.year<1900
    INTERSECT
    SELECT first_name, last_name, actors.id
    FROM actors
        JOIN roles ON roles.actor_id= actors.id
        JOIN movies ON movies.id=roles.movie_id
    WHERE movies.year>2000
    ORDER BY last_name
    ;
---BUSY FILMING 
    SELECT count(DISTINCT roles.role) as num_roles_in_movies, *
    FROM actors
    JOIN roles on roles.actor_id=actors.id
    JOIN movies on roles.movie_id= movies.id
    WHERE movies.year>1990 
    GROUP BY actors.id,movies.id
    HAVING  num_roles_in_movies > 4;

--FEMALE ACTORS ONLY
    SELECT movies.year, COUNT(*) as movies_in_year
    FROM movies 
    WHERE movies.id NOT IN(
    SELECT DISTINCT movies.id
    FROM movies 
    JOIN roles on movies.id =roles.movie_id
    JOIN actors 
    ON roles.actor_id = actors.id
    AND actors.gender = 'M'
    --this gives us all the movies that have at least one male actor
    )
    AND movies.id IN (
         SELECT DISTINCT movies.id
    FROM movies 
    JOIN roles on movies.id =roles.movie_id
    JOIN actors 
    ON roles.actor_id = actors.id
    AND actors.gender = 'F'
    )
    GROUP BY movies.year;