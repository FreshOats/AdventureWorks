P(R) represents a pattern drawn by Julia in R rows. The following pattern represents P(5):
* * * * * 
* * * *
* * * 
* * 
*

-- Doing this in 2 Queries. First declare @P as an integer 20
DECLARE @P INT = 20;

-- Start a while loop that only works if P is greater than 1 to avoid an infinite loop
-- Begin the loop to print the replication of '* ' P times, resetting P each time by reducing by 1
WHILE @P >= 1 
BEGIN 
    PRINT REPLICATE('* ',@P);
    SET @P = @P - 1;
END;


-- P(R) represents a pattern drawn by Julia in R rows. The following pattern represents P(5):
* 
* * 
* * * 
* * * * 
* * * * *

DECLARE @P INT = 1;

WHILE @P <=20
BEGIN
    PRINT REPLICATE('* ', @P)
    SET @P = @P + 1
END;

-- Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically
-- and displayed underneath its corresponding Occupation. The output column headers should be Doctor, Professor, Singer, and Actor,
--     respectively. Note: Print NULL when there are no
-- more names corresponding to an occupation.

SELECT max(CASE 
               WHEN occupation = 'Doctor' THEN name
               ELSE Null
           END) AS Doctor,
       max(CASE
               WHEN occupation = 'Professor' THEN name
               ELSE Null
           END) AS Professor,
       max(CASE
               WHEN occupation = 'Singer' THEN name
               ELSE Null
           END) AS Singer,
       max(CASE
               WHEN occupation = 'Actor' THEN name
               ELSE Null
           END) AS Actor
FROM
    ( SELECT occupation,
             name,
             ROW_NUMBER() OVER(PARTITION BY occupation
                               ORDER BY name) rn
     FROM OCCUPATIONS ) x
GROUP BY rn
-- This needs the Max to create an aggregate function for the group by 

-- This method for the same problem uses the PIVOT function instead of using cases
SELECT [Doctor],
       [Professor],
       [Singer],
       [Actor]
FROM
    (SELECT ROW_NUMBER()OVER(PARTITION BY Occupation
                             ORDER BY Name) AS  ROWNUMBER,
                                                NAME,
                                                OCCUPATION
     FROM OCCUPATIONS) AS SOURCE_DATA PIVOT (MAX(NAME)
                                             FOR OCCUPATION IN ([Doctor],[Professor],[Singer],[Actor])) AS PIVOT_TABLE


-- You are given a table, BST, containing two columns: N and P,
-- where N represents the value of a node in Binary Tree, and P is the parent of N.
-- Write a query to find the node type of Binary Tree ordered by the value of the node. Output one of the following
-- for each node: Root: If node is root node. Leaf: If node is leaf node. Inner: If node is neither root nor leaf node.

SELECT N,
       CASE
           WHEN P IS null THEN 'Root'
           WHEN N IN
                    (SELECT P
                     FROM BST) THEN 'Inner'
           ELSE 'Leaf'
       END
FROM BST
ORDER BY N;



-- Given the table schemas below, write a query to print the company_code, founder name, total number of lead managers, total number of senior managers, total number of managers, and total number of employees. Order your output by ascending company_code.
-- In company C1, the only lead manager is LM1. There are two senior managers, SM1 and SM2, under LM1. There is one manager, M1, under senior manager SM1. There are two employees, E1 and E2, under manager M1.
-- In company C2, the only lead manager is LM2. There is one senior manager, SM3, under LM2. There are two managers, M2 and M3, under senior manager SM3. There is one employee, E3, under manager M2, and another employee, E4, under manager, M3.

SELECT Company.company_code,
       Company.founder,
       COUNT(DISTINCT e.lead_manager_code),
       COUNT(DISTINCT e.senior_manager_code),
       COUNT(DISTINCT e.manager_code),
       COUNT(DISTINCT e.employee_code)
FROM Company
INNER JOIN Employee AS e ON e.company_code = Company.company_code
GROUP BY Company.company_code,
         Company.founder
ORDER BY Company.company_code;


-- Write a query to print all prime numbers less than
-- or equal to . Print your result on a single line,
-- and use the ampersand () character as your separator (instead of a space).

DECLARE @Iteration INT = 2; -- Start with first Prime Number
DECLARE @Output VARCHAR(1000) = ''
WHILE @Iteration < 1000
BEGIN 
    DECLARE @Prime INT = 1;-- This assumes the number is prime  
    DECLARE @Divisor INT = 2; -- Check if there are any other factors than 1 and self

    WHILE @Divisor < @Iteration
    BEGIN
        IF @Iteration % @Divisor = 0
        BEGIN
            SET @Prime = 0; -- The number is not prime if the modulus is 0
            BREAK;
    END
    SET @Divisor = @Divisor + 1;
END
IF @Prime = 1 -- The prime will reach 1 when it gets to itself
BEGIN 
    IF @Iteration = 2
    BEGIN
        SET @Output = CONVERT(VARCHAR(4), @Iteration)
    END ELSE
        SET @Output = @Output + '&' + CONVERT(VARCHAR(4), @Iteration)
    END
    SET @Iteration = @Iteration + 1 -- Move on to the next number
END
SELECT @Output
    

-- Julia just finished conducting a coding contest,
-- and she needs your help assembling the leaderboard! Write a query to print the respective hacker_id
-- and name of hackers who achieved full scores
-- for
-- more than one challenge.
-- Order your output in descending
-- order by the total number of challenges in which the hacker earned a full score. If
-- more than one hacker received full scores in same number of challenges,
--                                                             then
-- sort them by ascending hacker_id.

SELECT h.hacker_id, h.name
FROM Hackers h
INNER JOIN Submissions s ON s.hacker_id = h.hacker_id
INNER JOIN Challenges c ON c.challenge_id = s.challenge_id
INNER JOIN Difficulty d ON d.difficulty_level = c.difficulty_level
WHERE s.score = d.score
GROUP BY h.hacker_id, h.name
HAVING COUNT(h.hacker_id)>1
ORDER BY COUNT(h.hacker_id) DESC, h.hacker_id ASC;




-- Write a query to output the names of those students whose best friends got offered a higher salary than them. 
-- Names must be ordered by the salary amount offered to the best friends. It is guaranteed that no two students got same salary offer.

-- This query joins the same table twice, once for the student info and again for the friend info
SELECT s.name
FROM Friends f
LEFT JOIN Packages Sp ON Sp.ID = f.ID -- To get Student Salary
LEFT JOIN Packages Fp ON Fp.ID = f.Friend_ID -- To get the Friend Salary
LEFT JOIN Students s ON s.ID = f.ID -- To get the Student Name
WHERE Sp.Salary < Fp.Salary -- Where the Friend salary is greater than student salary
ORDER BY Fp.Salary


-- Two pairs (X1, Y1)
-- and (X2,
--      Y2) are said to be symmetric pairs if X1 = Y2
-- and X2 = Y1. Write a query to output all such symmetric pairs in ascending
-- order by the value of X. List the rows such that X1 ≤ Y1.

WITH CTE AS
    ( SELECT X, Y, rn = ROW_NUMBER() 
        OVER(ORDER BY X)
        FROM Functions ) -- applying a common table expression to create a temp table with row numbers
SELECT DISTINCT f1.X,
                f1.Y -- don't select all, because it contains rn now
FROM CTE f1
INNER JOIN CTE f2 ON f1.X = f2.Y
AND f1.Y = f2.X 
AND f1.rn <> f2.rn -- it's not referring to itself in cases where X1 = Y1
AND f1.X <= f1.Y -- meets the X is less than Y condition
ORDER BY f1.x


-- Hermione decides the best way to choose is by determining the minimum number of gold galleons needed to buy
--  each non-evil wand of high power and age. Write a query to print the id, age, coins_needed, and power of the
--   wands that Ron's interested in, sorted in order of descending power. 
--   If more than one wand has same power, sort the result in order of descending age.

-- SELECT w.id,
--        wp.age,
--        MIN(w.coins_needed),
--        w.power
-- FROM Wands w
-- INNER JOIN Wands_Property wp ON w.code = wp.code
-- WHERE wp.is_evil = 0
-- GROUP BY w.id
-- ORDER BY w.power DESC,
--          wp.age DESC
-- The above does not work because it doesn't take into account that there are multiple wands that are the same power and same age with different costs



-- This creates a query with the subquery in the FROM clause, which includes all necessary incormation but aggregates
-- the coins_needed as coins to find the minimum, saving this as subquery sq. After the FROM clause, the 
-- subquery is used, establishing this having the same code, power and coins needed prior to ordering 
-- My solution
SELECT id,
       age,
       coins,
       sq.power
FROM Wands w,
    -- This subquery joins the tables and groups by code, age and power to select the minimum value for coins_needed.
    -- This eliminates the duplicates from those that have the same power and age
    (SELECT w.code,   -- code must be here as the aggregate to set equal so we can use it in the WHERE clause 
            age,
            w.power,
            MIN(coins_needed) AS coins
     FROM wands w
     INNER JOIN wands_property wp ON w.code = wp.code
     WHERE is_evil = 0
     GROUP BY w.code, -- code must be in the group by in order to keep in the select list as an aggregate
              age,
              w.power) AS sq
WHERE w.code = sq.code
    AND w.power = sq.power
    AND w.coins_needed = sq.coins
ORDER BY sq.power DESC,
         age DESC


-- SakshiUArora solution -- She avoids the inner join by including the equalities in the WHERE clause
SELECT id,
       age,
       cn,
       T.power
FROM Wands as w,

    (SELECT w.code,
            age,
            w.power,
            MIN(coins_needed) as cn
     FROM Wands as w,
          Wands_Property as wp
     WHERE w.code = wp.code
         and is_evil=0
     GROUP BY w.code,
              age,
              w.power) AS T
WHERE w.code = T.code
    and w.power=T.power
    and w.coins_needed=T.cn
ORDER BY T.power DESC,
         age DESC;


-- _____ hpaditar457 solution -- this seemed to take a long timea
WITH cte AS
(                           -- Creating this common table expression uses the original query I had made, but includes a row number, ranking the rows for 
                            -- coins needed in ascending order, so the top is the cheapest 
    SELECT
        w.id,
        wp.age,
        w.coins_needed,
        ROW_NUMBER() OVER(PARTITION BY wp.age, w.power ORDER BY w.coins_needed) AS rn,
        w.power
    FROM Wands w
    INNER JOIN Wands_Property wp
    ON w.code = wp.code
    WHERE wp.is_evil = 0
)
SELECT
    id,
    age,
    coins_needed,
    power
FROM cte
WHERE rn = 1
ORDER BY power DESC, age DESC





------- Chase2Learn solution -- this uses a subquery in the Where clause only selecting the 
-- minimum number of coins needed rather than creating the subquery in the FROM clause or createing a ranking variable 
SELECT w.id,
       wp.age,
       w.coins_needed,
       w.power
FROM wands w
JOIN wands_property wp ON w.code = wp.code
WHERE wp.is_evil = 0
    AND w.coins_needed =
        (SELECT MIN(ww.coins_needed)
         FROM wands ww
         JOIN wands_property wpp ON ww.code = wpp.code
         WHERE wp.age = wpp.age
             AND w.power = ww.power)
ORDER BY w.power DESC,
         wp.age DESC;



-- Julia asked her students to create some coding challenges. Write a query to print the hacker_id, name, 
-- and the total number of challenges created by each student. Sort your results by the total number of 
-- challenges in descending order. If more than one student created the same number of challenges, then 
-- sort the result by hacker_id. If more than one student created the same number of challenges and the 
-- count is less than the maximum number of challenges created, then exclude those students from the result.


SELECT c.hacker_id,
       h.name,
       COUNT(c.hacker_id) challenges_created
FROM challenges c
LEFT JOIN hackers h ON h.hacker_id = c.hacker_id
GROUP BY c.hacker_id,
         h.name
ORDER BY challenges_created DESC,
         hacker_id ASC;
-- THIS block gets everyone sorted in order, but does not filter out the dupes below the max


--This works.... the cte is required because we need to create a new table to use for the next part, which is filtering out 
-- the values that have dupes except for the max value


--The total score of a hacker is the sum of their maximum scores
-- for all of the challenges. Write a query to print the hacker_id, name,
-- and total score of the hackers ordered by the descending score. If
-- more than one hacker achieved the same total score, then
-- sort the result by ascending hacker_id. Exclude all hackers with a total score of
-- from your result.

-- Total Score = sum of each hacker's max scores per challenge
-- Show hacker_id, name, total score desc (3 outputs)
-- If more than 1 has same total, ascending hacker_id
-- Only include total score > 0 

-- Tables: 
-- Hacker: hacker_id, name
-- Submissions: submission_id, hacker_id, challenge_id, score

-- Each hacker can have multiple submissions per challenge, only want the max score submission
-- Start with only the submissions table - name is easy to add at the end
WITH max_scores_per_challenge AS
    (SELECT MAX(s.score) AS score,
            h.hacker_id,
            h.name,
            s.challenge_id
     FROM submissions AS s
     INNER JOIN hackers AS h ON h.hacker_id = s.hacker_id
     GROUP BY h.hacker_id,
              s.challenge_id,
              h.name)
SELECT hacker_id,
       name,
       SUM(score)
FROM max_scores_per_challenge
GROUP BY name,
         hacker_id
HAVING SUM(score) > 0
ORDER BY SUM(score) DESC, hacker_id ASC;



--THIS uses a cte with window functions to work through the ranks and counts
WITH ranks_and_counts AS
(   SELECT h.hacker_id,
             h.name,
             COUNT(c.challenge_id) AS total_per_challenge,
             DENSE_RANK() OVER(ORDER BY COUNT(c.challenge_id)DESC) AS rn,
             COUNT(COUNT(c.challenge_id)) OVER (PARTITION BY COUNT(c.challenge_id)) AS totals_count
     FROM 
        challenges c
        INNER JOIN 
        hackers h 
            ON h.hacker_id = c.hacker_id
     GROUP BY h.hacker_id,
              h.name
     ORDER BY 
        total_per_challenge DESC, 
        h.hacker_id
)
SELECT hacker_id,
       name,
       total_per_challenge
FROM 
    ranks_and_counts
WHERE 
    totals_count = 1
    OR 
    rn = 1
ORDER BY 
    total_per_challenge DESC,
    hacker_id





-- You are given a table, Projects, containing three columns: 
-- Task_ID, Start_Date and End_Date. 
-- It is guaranteed that the difference between the End_Date and the Start_Date is equal to 1 day for each row in the table.

/* If the End_Date of the tasks are consecutive, then they are part of the same project. 
Samantha is interested in finding the total number of different projects completed.
Write a query to output the start and end dates of projects listed by the number of days 
it took to complete the project in ascending order. If there is more than one project 
that have the same number of completion days, then order by the start date of the project.
*/

WITH Project_Start AS
    (SELECT Start_Date,
            ROW_NUMBER() OVER (
                               ORDER BY Start_Date) AS Project_Number
     FROM projects
     WHERE Start_Date NOT IN
             (SELECT End_Date
              FROM projects) ),
     Project_End AS
    (SELECT End_Date,
            ROW_NUMBER() OVER (
                               ORDER BY END_Date) AS Project_Number
     FROM projects
     WHERE End_Date NOT IN
             (SELECT Start_Date
              FROM projects) )
SELECT S.Start_Date,
       E.End_Date
FROM Project_Start AS S
INNER JOIN Project_End AS E ON S.Project_Number = E.Project_Number
ORDER BY DATEDIFF(day, S.Start_Date, E.End_Date) ASC, Start_Date ASC