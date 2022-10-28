CREATE DATABASE COOKIE_COMPANY;
USE COOKIE_COMPANY;

-- Creating cookie company schemas.

CREATE TABLE employee(
			emp_id INT PRIMARY KEY,
            first_name VARCHAR(20),
            last_name VARCHAR(20),
            birth_day DATE,
            sex VARCHAR(1),
            salary INT,
            super_id INT,
            branch_id INT
);

CREATE TABLE branch(
			branch_id INT PRIMARY KEY,
            branch_name VARCHAR(20),
            mgr_id INT,
            FOREIGN KEY (mgr_id) REFERENCES employee(emp_id) 
            ON DELETE SET NULL
);
ALTER TABLE branch
ADD COLUMN mgr_start_date DATE;

SELECT * FROM branch;
DESCRIBE branch;

ALTER TABLE employee
ADD FOREIGN KEY (branch_id)
REFERENCES branch (branch_id) 
ON DELETE SET NULL;

ALTER TABLE employee
ADD FOREIGN KEY (super_id)
REFERENCES employee (emp_id) 
ON DELETE SET NULL;

CREATE TABLE client (
			client_id INT PRIMARY KEY,
            client_name VARCHAR(40),
            branch_id INT,
            FOREIGN KEY (branch_id)
            REFERENCES branch (branch_id)
            ON DELETE SET NULL
);

CREATE TABLE work_with (
			emp_id INT,
            client_id INT,
            total_sales INT,
            PRIMARY KEY (emp_id, client_id),
            FOREIGN KEY (emp_id)
            REFERENCES employee (emp_id)
            ON DELETE CASCADE,
			FOREIGN KEY (client_id)
            REFERENCES client (client_id)
            ON DELETE CASCADE
);

CREATE TABLE branch_supplier (
			branch_id INT,
            supplier_name VARCHAR (40),
            Supplier_type VARCHAR (40),
            PRIMARY KEY (branch_id, supplier_name),
            FOREIGN KEY (branch_id)
            REFERENCES branch (branch_id)
            ON DELETE CASCADE
);
SELECT * FROM employee;

-- Inserting records into various tables

INSERT INTO employee VALUES (100,'David','Wallace', '1976-11-17', 'M', 250000, NULL, NULL);
INSERT INTO branch VALUES (1,'Corporate', 100, '2006-02-09');

UPDATE employee
SET branch_id =1
WHERE emp_id = 100;

INSERT INTO employee VALUES (101,'Jan','Levison', '1961-05-11', 'F', 100000, 100, 1);

INSERT INTO employee VALUES (102,'Michael','Scot', '1964-03-15', 'M', 75000, 100, NULL);
INSERT INTO branch VALUES (2,'Scranton', 102, '1992-04-06');

UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO employee VALUES (103,'Angela','Martin', '1971-06-25', 'F', 63000, 102, 2);
INSERT INTO employee VALUES (104,'Kelly','Kapoor', '1980-02-05', 'F', 55000, 102, 2);
INSERT INTO employee VALUES (105,'Stanley','Hudson', '1958-02-19', 'M', 60000, 102, 2);

INSERT INTO employee VALUES (106,'Josh','Porter', '1969-01-05', 'M', 75000, 100, NULL);
INSERT INTO branch VALUES (3,'Stanford', 106, '1998-02-13');

UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;

INSERT INTO employee VALUES (107,'Andy','Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO employee VALUES (108,'Jim','Helpit', '1975-10-01', 'M', 71000, 106, 3);

INSERT INTO client VALUES (400, 'Dunmore Highschool',2),
						  (401, 'Lackumara County',2),
                          (402, 'FedEx',3),
                          (403, 'John Daly Law LLC',3),
                          (404, 'Scranton Newspaper',2),
                          (405, 'Times Newspaper',3),
                          (406, 'FedEx',2);

SELECT * FROM employee;
SELECT * FROM client;

INSERT INTO work_with 
					VALUES (100, 400, 55000),
						  (102, 401, 257000),
                          (108, 402,22500),
                          (107, 400,5000),
                          (108, 400,12000),
                          (106, 404,33000),
                          (107, 406,26000),
                          (102, 406,15000),
                          (106, 406,130000);
					
SELECT * FROM work_with;

INSERT INTO branch_supplier VALUES (2, 'Hammer Mill', 'paper'),
						  (2, 'uni-ball', 'writing utensil'),
							(3, 'Pamier paper', 'paper'),
                            (2, 'J.T Forms & Labels', 'Cussom Foams'),
                             (3, 'uni-ball', 'writing utensil'),
                              (3, 'Hammer Mill', 'paper'),
                               (3, 'Scanford Labels', 'Cussom Foams');
                               
SELECT * FROM employee;
SELECT * FROM client;
SELECT * FROM branch;
SELECT * FROM branch_supplier;
SELECT * FROM work_with;

-- Querry Time
-- Find all the total employees in the company?
SELECT * FROM employee;

-- Find all employees ordered by their salary?
SELECT * FROM employee
ORDER BY salary DESC;

-- Find all employees ordered by sex, then names?
SELECT * FROM employee
ORDER BY salary DESC, sex;

-- Find the first 5 employees in the table?
SELECT * FROM employee
LIMIT 5;

-- Find the first and last names of all employee?
SELECT first_name, last_name FROM employee
ORDER BY first_name;

-- Find the forename and surnames of all employees? 
SELECT first_name as forename, last_name as surname FROM employee
ORDER BY forename;

-- Find out all the different gender?
SELECT DISTINCT sex FROM employee;

-- Find the number of all employee?
SELECT COUNT(*) FROM employee;

-- Find the number of female employees born after 1970?
SELECT first_name, last_name, COUNT(emp_id) 
FROM employee
WHERE sex = 'F' AND YEAR(birth_day) > 1970;


SELECT concat(first_name," ", last_name) as Full_name, COUNT(emp_id) 
FROM employee
WHERE sex = 'F' AND birth_day > '1970-01-01';

-- Find the average of all employees salaries?
SELECT f.first_name, f.last_name, AVG(salary) 
FROM employee as f
WHERE sex = 'M';


-- Find how many males and females they are in the company?
SELECT COUNT(sex) as No_of_sex, sex 
FROM employee
GROUP BY sex;

-- Find the total sales of each salesmen?
SELECT emp_id, SUM(total_sales) 
FROM work_with
GROUP BY emp_id;

-- Find any clients who are in LLC?
SELECT * 
FROM client
WHERE client_name LIKE '%LLC';

-- Find any branche supplier who are in the label business?
SELECT * 
FROM branch_supplier
WHERE supplier_name LIKE '%label%';

-- Find any branche supplier who are in the school?
SELECT * 
FROM client
WHERE client_name LIKE '%school%';

-- Find the list of employees and branch name?
SELECT client_name, branch_id
FROM client
UNION
SELECT supplier_name, branch_id
FROM branch_supplier;


SELECT e.emp_id, e.first_name, e.last_name, b.branch_name
FROM employee as e
JOIN branch as b
ON e.emp_id=b.mgr_id;

-- Find all branches and the name of their manager?
SELECT employee.emp_id, employee.first_name, employee.last_name, branch.branch_name
FROM employee 
LEFT JOIN branch
ON employee.emp_id=branch.mgr_id
GROUP BY branch.branch_name;

-- Find name of all employees who have sold over 30,000 to single client?
SELECT employee.first_name, employee.last_name
FROM employee
WHERE employee.emp_id IN ( SELECT work_with.emp_id FROM work_with
							WHERE work_with.total_sales > 30000
						);
                        
-- Find all the clients who are in handled by the branch that micheal scot manages?					
SELECT client.client_name
FROM client
WhERE client.branch_id =(SELECT branch.branch_id
						  FROM branch
						  WHERE branch.mgr_id = 102
                          );
                          
-- Creation of triggers to perform trigger function.                          
CREATE DATABASE triggers;
USE triggers;
SHOW TABLES;
SHOW triggers;

CREATE TABLE business(id INT PRIMARY KEY, salary INT);


Delimiter //
CREATE trigger salary_take
BEFORE INSERT ON business
FOR EACH ROW
BEGIN
IF new.salary > 10000 THEN SET new.salary =10000;
END if; 
end //
DElimiter ;

INSERT INTO business VALUES (200, 10000000);

SELECT * FROM business;

USE Cookie_Company;
SHOW TABLES;

SELECT * FROM employee;

SELECT super_id, COUNT(branch_id) as branch_total
FROM employee
GROUP BY super_id
HAVING COUNT(branch_id) > 1; 

SELECT concat(e.first_name," ", e.last_name) as Employees, concat(s.first_name," ", s.last_name) as Supervisors
FROM employee as e
INNER JOIN employee as s
ON e.emp_id = s.super_id;

UPDATE employee
SET salary = 0.5 * salary
WHERE sex IN ( SELECT sex FROM employee
			   WHERE sex = 'M');


SELECT * FROM work_with;

DELIMITER //
CREATE PROCEDURE Sale()
BEGIN
SELECT emp_id, first_name, last_name
FROM employee
WHERE emp_id IN (SELECT emp_id
				FROM work_with
                WHERE total_sales < 10000);
END //
DELIMITER ;

          
                
CALL sale();		

SELECT * FROM work_with;

CREATE VIEW employee_details
AS
SELECT e.emp_id, e.first_name, e.last_name, w.client_id, w.total_sales
FROM employee as e
JOIN work_with as w
USING (emp_id);

Select *
From employee
Where emp_id is not null 
order by 1,2 ;

Select *
From employee as e
Where e.first_name is not null 
order by 3,4;

SELECT * FROM employee_details;

SELECT first_name, last_name, salary, ROW_NUMBER() OVER (ORDER BY salary) as row_num
FROM employee
ORDER BY Salary;  		

SELECT first_name, last_name, salary, RANK() OVER (ORDER BY salary) as rank_num
FROM employee
ORDER BY Salary;  		

SELECT * FROM employee;

SELECT emp_id, first_name, last_name, sex, FIRST_VALUE(first_name) OVER (PARTITION BY sex ORDER BY salary) as highest_earner
FROM employee;
