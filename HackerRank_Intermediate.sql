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