/*
    Apartments: (AptID: int, UnitNumber: varchar, BuildingID: int)
    Buildings: (BuildingID: int, ComplexID: int, BuildingName: varchar, Address: varchar)
    Requests: (RequestID: int, Status: varchar, AptID: int, Description: varchar)
    Complexes: (ComplexID:int, ComplexName: varchar)
    AptTenants: (TenantID: int, AptID: int)
    Tenants: (TenantID: int, TenantName: varchar)
*/
-- Q7: Image a simple database storing information for students' grades. 
--     Design what this databse might look like and provide a SQL query 
--     to return a list of honor roll students (top 10%), sorted by their grade point average

/*
    Students(StudentID: int, StudentName: varchar, Address: varchar)
    Courses(CourseID: int, StudentID: int, TeacherID: int)
    CourseEnrollment(CourseID: int, StudentID: int, Grade: float, Term: int)
*/

/*
    Study MYSQL? Create a SQL variable
                 10% Usage?
                 Limit
Step 0: Should not run  ( because of TIE Situations!!!)
    SELECT TOP 10 PERCENT AVG(Grade) AS GPA, StudentID
    FROM CourseEnrollments
    GROUP BY StudentID
    ORDER BY AVG(Grade) DESC

Step 1: Get the value of top 10% min, 
    DECLARE @GPACutOff float;
    SET @GPACutOff = 
    (SELECT min(GPA) AS 'GPAMin' FROM
        (SELECT TOP 10 PERCENT AVG(CourseEnrollment.Grade) AS GPA
         FROM CourseEnrollment 
         GROUP BY CourseEnrollment.StudentID
         ORDER BY GPA DESC
        ) AS Grades
    ); 

Step 2: Run the second SQL statement to get the results
    SELECT StudentName, GPA
    FROM (SELECT AVG(Grade) AS GPA, StudentID
          FROM CourseEnrollment
          GROUP BY StudentID
          HAVING AVG(Grade) >= @GPACutOff
    ) AS Honors
    INNER JOIN Students
    ON Students.StudentID = Honors.StudentID


*/


/*
        review the ER diagram with relation such as
        
            Professionals --> WorksFor --> Companies
            Professionals --> IsA --> People
*/


-- Q5: What is denormalization? Explain the Pros and Cons
/*
    ANS: Denormalization is a database optimizing technique, where we add redundant data to >=1
         tables. This helps us avoid costly joins in a relational database

        Cons:
            - updating and inserts are more expensive
            - updating and insert code are harder 
            - maintaining consistent data is tricky (--inconsistency, which is "correct"?)
            - redundancy means more storage 

        Pros:
            - retrieving data is faster
            - queries to retrieve data is simpler

         Ex: Courses (CourseID: int, TeacherID: int)
             Teachers (TeacherID: int, TeacherName: varchar)
        1.
         When we need teacher name with his/her listed courses, we need to do join
         and the tables grow very large, then we may spend an unnecessariliy long time joining 
         two tables. Denormalization saves teacher's name in Courses table as well.
        2. 
         But, if a teacher changes his/her name, then updating is very simple as we only need to
         update the Teachers table. 
*/

-- Q4: What are the different types of joins? Please explain how they differ 
--     and why certain types are better in certain situations.

/*
    ANS: JOIN, LEFT JOIN, RIGHT JOIN
    JOIN: the fastest join as it only outputs both two tables' common rows ( as specified )
    LEFT JOIN: the idea is that A LEFT JOIN B, and there are rows in A that may not have
               matching ones in B, but this is a case of 0, and this information should 
               not be omitted, so this way LEFT JOIN is important
    RIGHT JOIN: similiar to LEFT JOIN 
    FULL OUTER JOIN:!! ALL records (combine LEFT & RIGHT JOIN Results)
*/

-- Q3: Close All Requests: Building #11 is undergoing a major renovation. 
--     Implement a query to close all requests from apartments in this building
-- Usage of IN!!!!!!!
UPDATE Requests
SET Status = 'Close'
WHERE Requests.AptID IN (SELECT AptID 
    FROM Apartments
    WHERE BuildingID = '11'
)


-- Q1: Write a SQL query to get a list of tenants who are renting more than one apartment
SELECT TenantName, COUNT(TenantID) AS CNT
FROM Tenants
JOIN Apartments
ON Tenants.TenantID = Apartments.TenantID
GROUP BY Tenants.TenantID, Tenants.TenantName
HAVING COUNT(Tenants.TenantID) > 1

-- Q2: Write a SQL query to get a list of all buildings and the number of open requests 
SELECT BuildingName, ISNULL(BuildingRequests.CNT, 0) as 'Count' FROM 
Buildings 
LEFT JOIN 
(SELECT BuildingID, COUNT(RequestID) AS CNT
FROM Apartments
JOIN Requests
ON Apartments.AptID = Requests.AptID
WHERE STATUS = 'Open'
GROUP BY BuildingID ) AS BuildingRequests 
ON Buildings.BuildingID = BuildingRequests.BuildingID 

