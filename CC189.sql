/*
    Apartments: (AptID: int, UnitNumber: varchar, BuildingID: int)
    Buildings: (BuildingID: int, ComplexID: int, BuildingName: varchar, Address: varchar)
    Requests: (RequestID: int, Status: varchar, AptID: int, Description: varchar)
    Complexes: (ComplexID:int, ComplexName: varchar)
    AptTenants: (TenantID: int, AptID: int)
    Tenants: (TenantID: int, TenantName: varchar)
*/

-- Q5: What is denormalization? Explain the Pros and Cons
/*
    ANS: 
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

