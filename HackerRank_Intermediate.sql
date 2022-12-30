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
    ( SELECT X, Y, rn = ROW_NUMBER() OVER(
                                          ORDER BY X)
     FROM Functions ) -- applying a common table expression to create a temp table with row numbers
SELECT DISTINCT f1.X,
                f1.Y -- don't select all, because it contains rn now
FROM CTE f1
INNER JOIN CTE f2 ON f1.X = f2.Y
AND f1.Y = f2.X 
AND f1.rn <> f2.rn -- it's not referring to itself in cases where X1 = Y1
AND f1.X <= f1.Y -- meets the X is less than Y condition
ORDER BY f1.x