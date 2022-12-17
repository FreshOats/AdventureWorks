-- Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result cannot contain duplicates.
SELECT DISTINCT(city)
FROM station
WHERE city LIKE '[AEIOU]%'


-- Query the list of CITY names from STATION that do not start with vowels and do not end with vowels. Your result cannot contain duplicates.
SELECT DISTINCT(city)
FROM station
WHERE city LIKE '[^AEIOU]%[^AEIOU]'

-- Query the Name of any student in STUDENTS who scored higher than  Marks. Order your output by the last three characters of each name. If two or more students both have names ending in the same last three characters (i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID.
SELECT name
FROM students
WHERE marks > 75
ORDER BY RIGHT(name, 3), ID

-- Write a query that prints a list of employee names (i.e.: the name attribute) from the Employee table in alphabetical order.
SELECT name
FROM employee
ORDER BY name ASC

-- Write a query that prints a list of employee names (i.e.: the name attribute) for employees in Employee having a salary greater than  per month who have been employees for less than  months. Sort your result by ascending employee_id.
SELECT name
FROM employee
WHERE (salary > 2000)
    AND (months < 10)
ORDER BY employee_id ASC

-- Query the sum of the populations for all Japanese cities in CITY. The COUNTRYCODE for Japan is JPN.
SELECT SUM(population)
FROM city
WHERE countrycode = 'JPN'

-- Query the difference between the maximum and minimum populations in CITY.
SELECT (MAX(population)-MIN(population)) AS diff
FROM city

-- Query the sum of Northern Latitudes (LAT_N) from STATION having values greater than  and less than . Truncate your answer to  decimal places.
SELECT CAST(SUM(LAT_N) AS decimal(18,4))  -- note: 18 is the default number of digits 
FROM station
WHERE LAT_N BETWEEN 38.7880 AND 137.2345

--Query the greatest value of the Northern Latitudes (LAT_N) from STATION that is less than . Truncate your answer to  decimal places.
SELECT CAST(MAX(LAT_N) as DECIMAL(18,4))
FROM station
WHERE LAT_N < 137.2345;

-- Query the Western Longitude (LONG_W) for the largest Northern Latitude (LAT_N) in STATION that is less than . Round your answer to decimal places.
SELECT TOP 1 CAST(LONG_W as DECIMAL(18,4))
FROM STATION
WHERE LAT_N < 137.2345
ORDER BY LAT_N DESC;

--Query the smallest Northern Latitude (LAT_N) from STATION that is greater than . Round your answer to  decimal places.
SELECT TOP 1 CAST(LAT_N as DECIMAL(18,4))
FROM station
WHERE LAT_N > 38.7780
ORDER BY LAT_N ASC;

-- Query the Western Longitude (LONG_W) where the smallest Northern Latitude (LAT_N) in STATION is greater than . Round your answer to decimal places.
SELECT TOP 1 CAST(LONG_W as DECIMAL(18,4))
FROM STATION
WHERE LAT_N > 38.7880
ORDER BY LAT_N ASC;


-- Query the Manhattan Distance between points and and round it to a scale of decimal places.
    --Consider and to be two points on a 2D plane.
    -- a happens to equal the minimum value in Northern Latitude (LAT_N in STATION).
    -- b happens to equal the minimum value in Western Longitude (LONG_W in STATION).
    -- c happens to equal the maximum value in Northern Latitude (LAT_N in STATION).
    -- d happens to equal the maximum value in Western Longitude (LONG_W in STATION).
SELECT CAST(MAX(LAT_N)-MIN(LAT_N)+MAX(LONG_W)-MIN(LONG_W) AS decimal(18,4)) AS ManDist
FROM station

-- Query the Euclidean Distance between points and and round it to a scale of decimal places.
    -- Consider  and  to be two points on a 2D plane where  are the respective minimum and maximum 
    -- values of Northern Latitude (LAT_N) and  are the respective minimum and maximum values of Western Longitude (LONG_W) in STATION.

SELECT CAST(SQRT(SQUARE(MAX(LAT_N)-MIN(LAT_N))+SQUARE(MAX(LONG_W)-MIN(LONG_W))) AS decimal(18,4))
FROM station

--A median is defined as a number separating the higher half of a data set from the lower half. Query the median of the Northern Latitudes (LAT_N) from STATION and round your answer to  decimal places.
SELECT CAST(((
                  (SELECT MAX(lat_n)
                   FROM
                       (SELECT TOP 50 PERCENT lat_n
                        FROM station
                        ORDER BY lat_n ASC) AS BottomHalf) +
                  (SELECT MIN(lat_n)
                   FROM
                       (SELECT TOP 50 PERCENT lat_n
                        FROM station
                        ORDER BY lat_n DESC) AS TopHalf)) / 2) AS decimal(18,4)) AS Median


-- Query the list of CITY names from STATION that either do not start with vowels or do not end with vowels. Your result cannot contain duplicates.
SELECT DISTINCT(city)
FROM station
WHERE city LIKE '[^AEIOU]%'
    OR city LIKE '%[^AEIOU]'

-- Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.
SELECT DISTINCT(city)
FROM station
WHERE city LIKE '%[AEIOU]'

-- Query the list of CITY names from STATION which have vowels (i.e., a, e, i, o, and u) as both their first and last characters. Your result cannot contain duplicates.
SELECT DISTINCT(city)
FROM station
WHERE city LIKE '[AEIOU]%[AEIOU]'


--Query the list of CITY names from STATION that do not start with vowels. Your result cannot contain duplicates.
SELECT DISTINCT(city)
FROM station
WHERE city NOT LIKE '[AEIOU]%'

--Query the list of CITY names from STATION that do not end with vowels. Your result cannot contain duplicates.
SELECT DISTINCT(city)
FROM station
WHERE city NOT LIKE '%[AEIOU]'


-- Write a query identifying the type of each record in the TRIANGLES table using its three side lengths.
--  Output one of the following statements for each record in the table: 
-- Equilateral: It's a triangle with  sides of equal length.
-- Isosceles: It's a triangle with sides of equal length.
-- Scalene: It's a triangle with  sides of differing lengths.
-- Not A Triangle: The given values of A, B, and C don't form a triangle.

SELECT CASE
           WHEN A + B <= C THEN 'Not A Triangle'
           WHEN A = B
                AND A = C THEN 'Equilateral'
           WHEN A = B
                OR B = C
                OR A = C THEN 'Isosceles'
           ELSE 'Scalene'
       END
FROM triangles;


--Generate the following two result
-- sets: Query an alphabetically ordered list of all names in OCCUPATIONS, immediately followed by the first letter of each profession as a parenthetical (i.e.: enclosed in parentheses).
-- For example: AnActorName(A),
--              ADoctorName(D),
--              AProfessorName(P),
-- and ASingerName(S). Query the number of ocurrences of each occupation in OCCUPATIONS.
-- Sort the occurrences in ascending
-- order, and output them in the following format: There are a total of [occupation_count] [occupation]s.
-- where [occupation_count] is the number of occurrences of an occupation in OCCUPATIONS
-- and [occupation] is the lowercase occupation name. If more than one Occupation has the same [occupation_count], they should be ordered alphabetically.

SELECT CONCAT(name, '(',SUBSTRING(occupation,1,1), ')')
FROM OCCUPATIONS
ORDER BY name;


SELECT 'There are a total of ',
       COUNT(occupation),
       CONCAT(LOWER(occupation), 's.')
FROM OCCUPATIONS
GROUP BY occupation
ORDER BY COUNT(occupation);

--Query a count of the number of cities in CITY having a Population larger than .
SELECT COUNT(name)
FROM city
WHERE population > 100000;


-- Samantha was tasked with calculating the average monthly salaries for all employees in the EMPLOYEES table, but did not realize her keyboard's  key was broken until after completing the calculation. She wants your help finding the difference between her miscalculation (using salaries with any zeros removed), and the actual average salary.
-- Write a query calculating the amount of error (i.e.:  average monthly salaries), and round it up to the next integer.

SELECT CEILING(AVG(CAST (salary AS decimal)) - AVG(CAST(REPLACE(salary,'0','') AS decimal)))
FROM employees;