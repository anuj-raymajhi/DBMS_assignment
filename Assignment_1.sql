/*1. Give an SQL schema definition for the employee database of Figure 5. Choose an appropriate
primary key for each relation schema, and insert any other integrity constraints (for example,
foreign keys) you find necessary.*/

create database db_EmployeeData;
show databases;
use db_EmployeeData;

create table Tbl_employee 
(
	employee_name varchar(255)  Primary key,
	street varchar(255),
	city varchar(255)
);

create table Tbl_works
(
	employee_name varchar(255)  Primary key,
	company_name varchar(255),
	salary int
);

create table Tbl_company
(
	company_name varchar(255)  Primary key,
	city varchar(255)
);

create table Tbl_manages
(
	employee_name varchar(255)  Primary key,
	manager_name varchar(255)
);

INSERT INTO tbl_employee (employee_name, street, city) VALUES 
('Jones', 'Street 1', 'New York'),
('Bikash Regmi', 'Dhumbarahi', 'Kathmandu'),
('Puja Khanal', 'Basundhara', 'Pokhara'),
('Anish Giri', 'Gairidhara', 'Lalitpur'),
('Nisha Pandey', 'Tinkune', 'Bhaktapur'),
('Pradeep Subedi', 'Budhanilkantha', 'Kathmandu'),
('Samira Dhungana', 'Thamel', 'Kathmandu'),
('Raju Karki', 'Jawalakhel', 'Lalitpur'),
('Sita Puri', 'Gongabu', 'Kathmandu'),
('Binod Chaudary', 'Dhapasi', 'Kathmandu'),
('Reshma KC', 'Patan Dhoka', 'Lalitpur');

INSERT INTO tbl_works (employee_name, company_name, salary) VALUES 
('Jones', 'First Bank Corporation','80000'),
('Bikash Regmi', 'First Bank Corporation', '27376'),
('Puja Khanal', 'Small Bank Corporation', '47850'),
('Anish Giri', 'Small Bank Corporation', '27120'),
('Nisha Pandey', 'First Bank Corporation', '39973'),
('Pradeep Subedi', 'First Bank Corporation', '24869'),
('Samira Dhungana', 'Small Bank Corporation', '32112'),
('Raju Karki', 'First Bank Corporation', '33000'),
('Sita Puri', 'Small Bank Corporation', '49000'),
('Binod Chaudary', 'Small Bank Corporation', '5000'),
('Reshma KC', 'First Bank Corporation', '30050');

INSERT INTO tbl_company (company_name, city) VALUES
  ('First Bank Corporation','Kathmandu'),
  ('Small Bank Corporation','Lalitpur');

INSERT INTO tbl_manages (employee_name, manager_name) VALUES
('Bikash Regmi', 'Nisha Pandey'),
('Pradeep Subedi', 'Jones'),
('Raju Karki', 'Reshma KC'),
('Puja Khanal', 'Anish Giri'),
('Samira Dhungana', 'Sita Puri'),
('Binod Chaudary', 'Anish Giri');
  
-- Adding foreign key 
ALTER TABLE Tbl_works
ADD FOREIGN KEY (employee_name) REFERENCES Tbl_employee(employee_name);

ALTER TABLE Tbl_works
Add FOREIGN KEY(company_name) REFERENCES Tbl_company(company_name);

ALTER TABLE Tbl_manages
ADD FOREIGN KEY(employee_name) REFERENCES Tbl_employee(employee_name);


-- Q2 (a) Finding the names of all employees who work for First Bank Corporation.

SELECT employee_name FROM Tbl_works WHERE company_name = 'First Bank coorporation';

-- Q2 (b) Finding the names and cities of residence of all employees who work for First Bank Corporation.

-- using subqueries
SELECT employee_name, city FROM tbl_employee WHERE employee_name IN (SELECT employee_name FROM tbl_works WHERE company_name = 'First Bank coorporation'); 

-- using join
SELECT Tbl_employee.employee_name, Tbl_employee.city FROM Tbl_employee INNER JOIN Tbl_works ON Tbl_employee.employee_name = Tbl_works.employee_name
WHERE Tbl_works.company_name = 'First Bank coorporation';

-- Q2 (c)  Find the names, street addresses, and cities of residence of all employees who work for First Bank Corporation and earn more than $10,000.

-- using Subqueries
SELECT Tbl_employee.employee_name, Tbl_employee.street, Tbl_employee.city FROM Tbl_employee WHERE employee_name IN (SELECT employee_name FROM Tbl_works WHERE company_name = 'First Bank coorporation' AND salary > 10000); 

-- using join
SELECT Tbl_employee.employee_name, Tbl_employee.street, Tbl_employee.city FROM Tbl_employee INNER JOIN Tbl_works ON Tbl_employee.employee_name = Tbl_works.employee_name
WHERE Tbl_works.company_name = 'First Bank coorporation' AND Tbl_works.salary > 10000;

-- Q2 (d) Find all employees in the database who live in the same cities as the companies for which they work.

-- using subqueries
SELECT Tbl_employee.employee_name, Tbl_employee.city FROM Tbl_employee  WHERE Tbl_employee.city 
= (SELECT city FROM Tbl_company  WHERE Tbl_company.company_name
= (SELECT company_name FROM Tbl_works WHERE Tbl_works.employee_name = Tbl_employee.employee_name));

-- using join
SELECT Tbl_employee.employee_name, Tbl_employee.city FROM Tbl_employee INNER JOIN Tbl_works ON Tbl_employee.employee_name = Tbl_works.employee_name
INNER JOIN Tbl_company ON Tbl_works.company_name = Tbl_company.company_name
WHERE Tbl_company.city = Tbl_employee.city;

-- Q2 (e) Find all employees in the database who live in the same cities and on the same streets as do their managers.



-- Q2 (f) Find all employees in the database who do not work for First Bank Corporation.
SELECT employee_name from Tbl_works WHERE company_name != 'First Bank coorporation';

-- Q2 (g) Find all employees in the database who earn more than each employee of Small Bank Corporation.
SELECT e1.employee_name
FROM employee e1
INNER JOIN works w1 ON e1.employee_name = w1.employee_name
WHERE w1.salary > ALL (
  SELECT w2.salary
  FROM works w2
  INNER JOIN employee e2 ON w2.employee_name = e2.employee_name
  INNER JOIN company c ON w2.company_name = c.company_name
  WHERE c.company_name = 'Small Bank coorporation'
);

-- Q2 (h) Assume that the companies may be located in several cities. Find all companies located in every city in which Small Bank Corporation is located.
SELECT * FROM Tbl_company
WHERE Tbl_company.city = (SELECT Tbl_company.city FROM Tbl_company WHERE Tbl_company.company_name = 'Small Bank coorporation');

-- Q2 (i) Find all employees who earn more than the average salary of all employees of their company.
SELECT tbl_works.employee_name, tbl_works.company_name FROM
(SELECT company_name, AVG(salary) AS average_salary FROM tbl_works GROUP BY company_name) AS average
JOIN tbl_works ON average.company_name = tbl_works.company_name
WHERE tbl_works.salary > average.average_salary;

-- Q2 (j) Find the company that has the most employees.
SELECT company_name, employee_count FROM (SELECT company_name, COUNT(employee_name) AS employee_count FROM tbl_works GROUP BY company_name) as C1
ORDER BY employee_count DESC;


-- Q2 (k) Find the company that has the smallest payroll.
SELECT company_name, payroll FROM (SELECT company_name, SUM(salary) AS payroll FROM tbl_works GROUP BY company_name) AS total_payroll
ORDER BY payroll ASC;

-- Q2 (l) Find those companies whose employees earn a higher salary, on average, than the average salary at First Bank Corporation
-- will be using Acme Inc instead of First Bank Corporation
select c.company_name
from tbl_company c join tbl_works w
on c.company_name = w.company_name
group by c.company_name
having avg(w.salary) > (select avg(w2.salary)
                        from tbl_company c2 join
                             tbl_works w2
                             on c2.company_name = w2.company_name
                        where c2.company_name = 'First Bank coorporation'
                       );



-- Q3 (a) Modify the database so that Jones now lives in Newtown.
select * from tbl_employee where employee_name='Jones';

-- update city
UPDATE Tbl_employee SET city='Newtown' WHERE employee_name='Jones';

-- Q3 (b) Give all employees of First Bank Corporation a 10 percent raise.

select * from tbl_works where company_name='First Bank coorporation';

-- update salary
UPDATE Tbl_works SET salary=salary *1.1 WHERE company_name='First Bank coorporation';

-- Q3 (c) Give all managers of First Bank Corporation a 10 percent raise.

UPDATE tbl_works  SET salary = salary * 1.1 WHERE employee_name = ANY (SELECT DISTINCT manager_name  FROM tbl_manages) AND company_name = 'First Bank coorporation';

SELECT * FROM tbl_works WHERE company_name='First Bank coorporation';

-- Q3 (d) Give all managers of First Bank Corporation a 10 percent raise unless the salary becomes greater than $100,000; in such cases, give only a 3 percent raise.
UPDATE tbl_works w
INNER JOIN (
  SELECT e.employee_name
  FROM tbl_employee e
  INNER JOIN tbl_works w ON e.employee_name = w.employee_name
  INNER JOIN tbl_company c ON w.company_name = c.company_name
  WHERE c.company_name = 'First Bank coorporation'
  AND e.employee_name IN (
    SELECT m.manager_name
    FROM tbl_manages m
  )
) m ON w.employee_name = m.employee_name
SET w.salary = 
  CASE WHEN w.salary * 1.1 <= 100000 THEN w.salary * 1.1
  ELSE w.salary * 1.03
  END;

-- Q3 (e) Delete all tuples in the works relation for employees of Small Bank Corporation.
DELETE w FROM works w
INNER JOIN company c ON w.company_name = c.company_name
WHERE c.company_name = 'Small Bank coorporation';

