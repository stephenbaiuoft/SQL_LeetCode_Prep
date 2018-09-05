# LeetCode SQL 


### Question L184 Deparment Highest Salary
	The Employee table holds all employees. Every employee has an Id, a salary, and there is also a column for the department Id.
	
	+----+-------+--------+--------------+
	| Id | Name  | Salary | DepartmentId |
	+----+-------+--------+--------------+
	| 1  | Joe   | 70000  | 1            |
	| 2  | Henry | 80000  | 2            |
	| 3  | Sam   | 60000  | 2            |
	| 4  | Max   | 90000  | 1            |
	+----+-------+--------+--------------+
	The Department table holds all departments of the company.
	
	+----+----------+
	| Id | Name     |
	+----+----------+
	| 1  | IT       |
	| 2  | Sales    |
	+----+----------+
	Write a SQL query to find employees who have the highest salary in each of the departments. For the above tables, Max has the highest salary in the IT department and Henry has the highest salary in the Sales department.
	
	+------------+----------+--------+
	| Department | Employee | Salary |
	+------------+----------+--------+
	| IT         | Max      | 90000  |
	| Sales      | Henry    | 80000  |
	+------------+----------+--------+
	

### **Idea**

* **USE** `GROUP BY` to retrieve the values for each department and its highest deparment Salary

### Solution Using Group By

	SELECT d.Name AS Department, 
	       e.Name AS Employee, 
	       e.Salary 
	  FROM    
	  Employee e 
	  JOIN 
	  Department d
	  JOIN
	    (SELECT MAX(Salary) AS Salary,
	           DepartmentId
	      FROM Employee
	      GROUP BY DepartmentId
	    ) v1
	
	  WHERE d.Id = e.DepartmentId AND e.Salary = v1.Salary AND e.DepartmentId = v1.DepartmentId
    	


<br>
### Question L185 Deparment Top 3 Highest Salary

	The Employee table holds all employees. Every employee has an Id, 
	and there is also a column for the department Id.
	
	+----+-------+--------+--------------+
	| Id | Name  | Salary | DepartmentId |
	+----+-------+--------+--------------+
	| 1  | Joe   | 70000  | 1            |
	| 2  | Henry | 80000  | 2            |
	| 3  | Sam   | 60000  | 2            |
	| 4  | Max   | 90000  | 1            |
	| 5  | Janet | 69000  | 1            |
	| 6  | Randy | 85000  | 1            |
	+----+-------+--------+--------------+
	The Department table holds all departments of the company.
	
	+----+----------+
	| Id | Name     |
	+----+----------+
	| 1  | IT       |
	| 2  | Sales    |
	+----+----------+
	Write a SQL query to find employees who earn the top three
	salaries in each of the department. 
	For the above tables, your SQL query should return the following 
	rows.
	
	+------------+----------+--------+
	| Department | Employee | Salary |
	+------------+----------+--------+
	| IT         | Max      | 90000  |
	| IT         | Randy    | 85000  |
	| IT         | Joe      | 70000  |
	| Sales      | Henry    | 80000  |
	| Sales      | Sam      | 60000  |
	+------------+----------+--------+
	
	
### SQL Solution 1 <br>Best solution, clean, easy, no subquery
	
	  SELECT D.Name as Department, E.Name as Employee, E.Salary 
	  FROM Department D, Employee E, Employee E2  
	  WHERE D.ID = E.DepartmentId and E.DepartmentId = E2.DepartmentId and 
	  E.Salary <= E2.Salary
	  group by D.ID,E.Name having count(distinct E2.Salary) <= 3
	  order by D.Name, E.Salary desc	

### SQL Solution 2 Subquery 
	SELECT d1.Name AS Department, e1.Name AS Employee, e1.Salary   
	  FROM Employee e1
	  JOIN Department d1
	  ON e1.DepartmentId = d1.Id
	  WHERE (SELECT COUNT(DISTINCT e2.Salary)
	         FROM Employee e2
	         WHERE e2.Salary >= e1.Salary AND e2.DepartmentId = e1.DepartmentId
	        ) <= 3
	  ORDER BY Department, Salary DESC 
