--1.) Draw a schema of the relationship between the people, salaries, and hof_inducted tables. There are several online database 
--schema drawers that you can use for free, including draw.io, which we recommend. We discuss the basics of how to use draw.io 
--at the end of this checkpoint.
--a.) Label the primary and foreign keys. (Note that a field can be a primary key to one table and a foreign key to another.)
--b.) What are the parent and child tables? Are these one-to-one, one-to-many, or many-to-many relationships?

--https://drive.google.com/open?id=13-P8oEtXzK4EG5qwfFqM-u-PvE_YiQ-L
--The parent table is the people table with the hof_inducted and salaries tables being the child tables. Between people and salaries, 
--it is a one to many relationship. Between people and hof_inducted tables, it is a one to one relationship. 

--2.)Write a query that returns the namefirst and namelast fields of the people table, along with the inducted field from the 
--hof_inducted table. All rows from the people table should be returned, and NULL values for the fields from hof_inducted 
--should be returned when there is no match found.

SELECT people.namefirst,
       people.namelast,
       hof_inducted.yearid AS year_inducted
FROM people
LEFT JOIN hof_inducted ON people.playerid = hof_inducted.playerid;

--3.) In 2006, a special Baseball Hall of Fame induction was conducted for players from the negro baseball leagues of the 20th century. 
--In that induction, 17 players were posthumously inducted into the Baseball Hall of Fame. Write a query that returns the first and 
--last names, birth and death dates, and birth countries for these players. Note that the year of induction was 2006, and the value 
--for votedby will be “Negro League.”

SELECT hof_inducted.yearid AS year_inducted,
	   people.namefirst,
	   people.namelast,
	   people.birthyear, 
	   people.deathyear, 
	   people.birthcountry
FROM hof_inducted 
LEFT OUTER JOIN people
ON people.playerid = hof_inducted.playerid
WHERE hof_inducted.yearid = 2006 AND hof_inducted.votedby = 'Negro League';

--4.) Write a query that returns the yearid, playerid, teamid, and salary fields from the salaries table, along with the category field 
--from the hof_inducted table. Keep only the records that are in both salaries and hof_inducted. Hint: While a field named yearid is 
--found in both tables, don’t JOIN by it. You must, however, explicitly name which field to include.

SELECT salaries.yearid, salaries.playerid, salaries.teamid, salaries.salary, hof_inducted.category
FROM salaries 
INNER JOIN hof_inducted
ON salaries.playerid = hof_inducted.playerid;

--5.) Write a query that returns the playerid, yearid, teamid, lgid, and salary fields from the salaries table and the inducted 
--field from the hof_inducted table. Keep all records from both tables.

SELECT salaries.playerid, salaries.yearid, salaries.teamid, salaries.lgid, salaries.salary, hof_inducted.yearid AS year_inducted
FROM salaries 
FULL OUTER JOIN hof_inducted
ON salaries.playerid = hof_inducted.playerid;

--6.) There are 2 tables, hof_inducted and hof_not_inducted, indicating successful and unsuccessful inductions into the Baseball 
--Hall of Fame, respectively.
--a.) Combine these 2 tables by all fields. Keep all records.
--b.) Get a distinct list of all player IDs for players who have been put up for HOF induction.

SELECT *
FROM hof_inducted
UNION
SELECT *
FROM hof_not_inducted;

SELECT DISTINCT(playerid) AS player_id_inducted
FROM hof_inducted
UNION
SELECT DISTINCT(playerid) AS player_id_inducted
FROM hof_not_inducted;

--7.) Write a query that returns the last name, first name (see people table), and total recorded salaries for all players found 
--in the salaries table.

SELECT people.namefirst || ' ' || people.namelast AS first_last_name, SUM(salaries.salary) AS total_salary
FROM salaries 
LEFT OUTER JOIN people
ON people.playerid = salaries.playerid
GROUP BY first_last_name
ORDER BY first_last_name;

--8.) Write a query that returns all records from the hof_inducted and hof_not_inducted tables that include playerid, yearid, 
--namefirst, and namelast. Hint: Each FROM statement will include a LEFT OUTER JOIN!

SELECT people.playerid, hof_inducted.yearid, people.namefirst, people.namelast
FROM hof_inducted 
LEFT OUTER JOIN people
ON people.playerid = hof_inducted.playerid
UNION
SELECT people.playerid, hof_not_inducted.yearid, people.namefirst, people.namelast
FROM hof_not_inducted 
LEFT OUTER JOIN people
ON people.playerid = hof_not_inducted.playerid;

--9.) Return a table including all records from both hof_inducted and hof_not_inducted, and include a new field, namefull, which 
--is formatted as namelast , namefirst (in other words, the last name, followed by a comma, then a space, then the first name). 
--The query should also return the yearid and inducted fields. Include only records since 1980 from both tables. Sort the 
--resulting table by yearid, then inducted so that Y comes before N. Finally, sort by the namefull field, A to Z.

SELECT people.namelast || ', ' || people.namefirst AS namefull, hof_inducted.yearid, hof_inducted.inducted
FROM hof_inducted 
LEFT OUTER JOIN people
ON people.playerid = hof_inducted.playerid
WHERE hof_inducted.yearid >= 1980
UNION
SELECT people.namelast || ', ' || people.namefirst AS namefull, hof_not_inducted.yearid, hof_not_inducted.inducted
FROM hof_not_inducted 
LEFT OUTER JOIN people
ON people.playerid = hof_not_inducted.playerid
WHERE hof_not_inducted.yearid >= 1980
ORDER BY yearid, inducted DESC, namefull;

--10.) Write a query that returns the highest annual salary for each teamid, ranked from high to low, along with the corresponding 
--playerid. Bonus! Return namelast and namefirst in the resulting table. (You can find these in the people table.)

SELECT DISTINCT ON (teamid) 
	teamid, people.playerid, MAX(salary), namelast, namefirst
FROM people
JOIN salaries
ON people.playerid = salaries.playerid
GROUP BY teamid, people.playerid, namelast, namefirst
HAVING MAX(salary) = MAX(salary)
ORDER BY teamid, MAX(salary) DESC;

--11.)Select birthyear, deathyear, namefirst, and namelast of all the players born since the birth year of Babe Ruth (playerid = ruthba01). 
--Sort the results by birth year from low to high.

SELECT birthyear, deathyear, namefirst, namelast
FROM people
WHERE birthyear >= (SELECT birthyear
FROM people
WHERE playerid = 'ruthba01')
ORDER BY birthyear;

--12.) Using the people table, write a query that returns namefirst, namelast, and a field called usaborn where. The usaborn field 
--should show the following: if the player's birthcountry is the USA, then the record is 'USA.' Otherwise, it's 'non-USA.' Order the 
--results by 'non-USA' records first.

SELECT namefirst, namelast, 
CASE
	WHEN birthcountry = 'USA' then 'USA'
	ELSE 'non-USA'
END AS usaborn
FROM people;

--13.) Calculate the average height for players throwing with their right hand versus their left hand. Name these fields right_height 
--and left_height, respectively.

SELECT throws,
ROUND(AVG(CASE WHEN throws = 'R' THEN height END)) AS right_height,
ROUND(AVG(CASE WHEN throws = 'L' THEN height END)) AS left_height
FROM people
WHERE throws IS NOT NULL AND throws <> 'S'
GROUP BY throws;

--14.) Get the average of each team's maximum player salary since 2010. Hint: WHERE will go inside your CTE

WITH cte AS 
	(
	SELECT teamid, max(salary) AS max_salary
	FROM salaries
	WHERE yearID >= 2010
	GROUP by teamid
	)
SELECT ROUND(AVG(max_salary))
FROM cte;