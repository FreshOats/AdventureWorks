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