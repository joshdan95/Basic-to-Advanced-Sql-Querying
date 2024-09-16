/* Simple and Complex queries 
Skills: joins, operators, aggregate function, sub queries, 
With clause, window function using employee database*/


create database if not exists employees_proj; 
use employees_proj;
drop database employees_proj;
CREATE TABLE employees (
    emp_no INT NOT NULL,
    birth_date DATE NOT NULL,
    first_name VARCHAR(25) NOT NULL,
    last_name VARCHAR(25) NOT NULL,
    gender ENUM('M', 'F') NOT NULL,
    hire_date DATE NOT NULL,
    salary int NOT NULL,
    dept_no VARCHAR(10) NOT NULL,
    PRIMARY KEY (emp_no)
);

CREATE TABLE departments (
    dept_no VARCHAR(10) NOT NULL,
    dept_name VARCHAR(40) NOT NULL,
    PRIMARY KEY (dept_no),
	UNIQUE KEY (dept_name)
);

CREATE TABLE salaries (
    emp_no INT NOT NULL,
    salary INT NOT NULL,
    dept_name VARCHAR(40) NOT NULL
);

INSERT INTO employees(emp_no,birth_date,first_name,last_name,gender,hire_date,salary, dept_no) VALUES
(1104,'1995-02-19','Saniya','Kalloufi','M','2021-09-15',43655,'d001'),
(1101,'1995-11-07','Mary','Sluis','F','2021-01-22',49455,'d002'),
(1102,'1997-10-04','Patricio','Bridgland','M','2021-12-18',43745,'d003'),
(1106,'1996-05-02','Kazuhito','Cappelletti','M','2021-04-14', 44785,'d004'),
(1107,'1998-07-06','Cristinel','Bouloucos','F','2021-08-03',43655,'d005'),
(1109,'1996-01-23','Lillian','Haddadi','M','2021-04-30',53655,'d006'),
(1120,'1997-12-24','Mayuko','Warwick','M','2021-01-26',57655,'d007'),
(1112,'1999-07-08','Shahaf','Famili','M','2021-08-22',58655,'d008'),
(1117,'1994-09-05','Suzette','Pettey','F','2021-05-19',59655,'d009'),
(1116,'1995-04-03','Yongqiao','Berztiss','M','2021-03-20',63655,'d005'),
(1108,'1996-11-26','Domenick','Tempesti','M','2020-10-22',67655,'d006'),
(1113,'1996-07-14','Elvis','Demeyer','M','2020-02-17',62655,'d007'),
(1103,'1998-01-27','Karsten','Joslin','M','2020-09-01',71655,'d008'),
(1111,'1999-08-09','Jeong','Reistad','F','2020-06-20',92655,'d009'),
(1105,'1995-08-10','Adamantios','Portugali','M','2020-01-03',69655,'d001'),
(1119,'1998-07-22','Pradeep','Makrucki','M','2020-12-05',73655,'d001'),
(1118,'1997-09-13','Weiyi','Meriste','F','2020-02-14',75615,'d002'),
(1110,'1995-02-26','Magy','Stamatiou','F','2020-03-21',79655,'d005'),
(1114,'1996-09-19','Yishay','Tzvieli','M','2020-10-20',54755,'d009'),
(1115,'1994-09-21','Mingsen','Casley','F','2020-05-21',43747,'d008');


insert into departments (dept_no, dept_name) values
('d001','Marketing'), 
('d002','Finance'), 
('d003','Human Resources'), 
('d004','Production'), 
('d005','Development'), 
('d006','Quality Management'), 
('d007','Sales'), 
('d008','Research'), 
('d009','Customer Service');

insert into salaries (emp_no, salary, dept_name) values
(1104, 43655, 'marketing'),
(1101, 49455, 'production'),
(1102, 43745, 'finance'),
(1106, 44785, 'human resorce'),
(1107, 43655, 'development'),
(1109, 53655, 'sales'),
(1120, 57655, 'research'),
(1112, 58655, 'customer service'),
(1117, 59655, 'quality management'),
(1116, 63655, 'sales'),
(1108, 67655, 'research'),
(1113, 62655, 'marketing'),
(1103, 71655, 'finance'),
(1111, 92655, 'sales'),
(1105, 69655, 'development'),
(1119, 73655, 'customer service'),
(1118, 75615, 'human resouce'),
(1110, 79655, 'production'),
(1114, 54755, 'sales'),
(1115, 43747, 'human resource');

alter table employees
change first_name firstname varchar (50);


select * from employees;
select * from salaries;
select * from departments;

select firstname, emp_no
from employees
where firstname like 'j%';

select concat (first_name, '', last_name) as full_name 
from employees;

update employees
set firstname = 'jessica'
where emp_no = 1111;

SELECT first_name,
	   last_name,
       min(salary)
	from employees;
    
    select concat (first_name, '', last_name) as full_name , gender
    from employees
    where hire_date = '2021-03-20';
    
    select * from employees
    where hire_date between '2020-02-17' and '2021-04-30'
    order by salary desc;
    
/* Union all statement
query to display max and minimum salary using union all*/

(select emp_no, max(salary) as salary
from employees
group by emp_no
order by salary desc
limit 1)
union all
 (select emp_no, min(salary) as salary
from employees 
group by emp_no
order by salary 
limit 1);
    
   
/*query to display the name (first name and last name) for those employees 
who gets more salary than the employee whose ID is 1109*/

select concat (first_name, '', last_name) as Fullname , salary
from employees
where salary > ( select salary from
				  employees
                  where emp_no = 1109);
			
 /*query to display all the information of an employee 
 whose id is any of the number 1107, 1111 and 1103*/
  
SELECT *
  from employees
  where emp_no in (1107, 1111, 1103);
  
  /* query to display the employee name (first name and last name) and hire date for all employees 
  in the same department as magy. Exclude magy. */
  
SELECT first_name,
       last_name,
       hire_date
  FROM employees
  WHERE dept_no = (SELECT dept_no
                           FROM employees
                           WHERE first_name = 'magy')
    AND first_name != 'magy';
    
/* query to display the department id and the total salary 
for those departments which contains at least one employee */

SELECT dept_no,
       SUM(salary)
  FROM employees
  WHERE dept_no IN (SELECT dept_no
                            FROM departments)
  GROUP BY dept_no
  HAVING COUNT(dept_no) >= 1;
  
  /*CASE STATEMENT 
  query to display the employee id, name (first name and last name), salary and 
  the SalaryStatus column with a title HIGH and LOW respectively for those employees 
  whose salary is more than and less than the average salary of all employees. */
    
SELECT emp_no,
       first_name,
       last_name,
       salary,
       CASE WHEN salary >= (SELECT AVG(salary) FROM employees) THEN 'HIGH'
            ELSE 'LOW' END AS salary_status
  FROM employees;
  
  /* query to display the employee number and name (first name and last name) for all employees 
  who work in a department with any employee whose name contains a T. */
  
SELECT emp_no,
       first_name,
       last_name
  FROM employees
  WHERE dept_no IN (SELECT dept_no
                            FROM employees
                            WHERE first_name LIKE '%T%');
                            
 /*Write a query in SQL to display the first name, last name, salary, and department name for all employees. */  
 select e.first_name, e.last_name, s.salary, d.dept_name
 from employees e 
 join salaries s on e.emp_no = s.emp_no
 join departments d on s.dept_name = d.dept_name
 order by salary desc;
 
 /* query in SQL to display the first name, last name, department number and name, 
 for all employees who have or have not any department.*/
 
SELECT e.first_name,
       e.last_name,
       d.dept_no,
       d.dept_name
  FROM employees e
  LEFT JOIN departments d
    ON e.dept_no = d.dept_no;
    
    
  /* query in SQL to display the first name, last name, department number and department name,
  for all employees for departments d005 or d001. */

SELECT e.first_name,
       e.last_name,
       d.dept_no,
       d.dept_name
  FROM employees e
  INNER JOIN departments d
    ON e.dept_no = d.dept_no
      AND d.dept_no IN ('d001', 'd005')
  ORDER BY e.last_name;
  
  /*query in SQL to display the name of the department, average salary and 
  number of employees working in each department */
  
  SELECT d.dept_name,
       COUNT(e.emp_no) AS num_employees,
        AVG(s.salary) as avg_salary
  FROM departments d
  INNER JOIN employees e
  ON d.dept_no = e.dept_no
  INNER JOIN salaries s
  ON e.emp_no = s.emp_no
  GROUP BY d.dept_name;
  
  create table t_employees
  ( emp_id   INT NOT NULL,
    emp_name VARCHAR(25) NOT NULL,
    manager_id 	VARCHAR(25)
    );
    INSERT INTO t_employees (emp_id, emp_name, manager_id)
    values  (1, 'mike', 3),
            (2, 'rob', 1),
            (3, 'tod', 'NULL'),
            (4, 'ben', 1),
            (5, 'sam', 1);
/* Self Join
   Query to display employees who are also managers*/
   
   select e.emp_name as employee, m.emp_name as manager
   from
   t_employees e
   join t_employees m on e.manager_id = m.emp_id;
   
   
/* Cte statement */
/* query to display department where total salary greater than average salary of all departments */

WITH total_salary (dep_name, total_salary_per_dept) as 
 (select dept_name, sum(salary) as total_salary_per_dept
  from salaries
  group by dept_name),
  avg_salary (avg_sal_all_dept) as
  (select cast(avg(total_salary_per_dept) as char) as avg_sal_all_dept
  from total_salary)
   select * from total_salary ts
   join avg_salary av
   on ts.total_salary_per_dept > av.avg_sal_all_dept;
   
   /* window functions 
       query to display max(salary) using over clause */
    select e.first_name, 
	    max(salary) over(partition by dept_no) as max_salary
        from employees e;
        
       
  /* row_number ()
  query to display first 2 empployee from each department to join the company */
  
  select * from (
  select e.*,
  row_number () over(partition by dept_no order by emp_no) as rn
  from employees e) x
  where x.rn <3;
  
  /* rank()
     query to display top 2 salary of each department */
     
     select * from (
  select e.*,
  rank () over(partition by dept_no order by salary desc) as rnk
  from employees e) x
  where x.rnk <3;
  
  /* dense_rank ()
     query to display salary rank using dense_rank () */
     
     select e.*,
      rank () over(partition by dept_no order by salary desc) as rnk,
      dense_rank () over(partition by dept_no order by salary desc) as Dense_rnk
      from employees e;
----------------------------------------------------------------------------------------------

use employees;
select* from employees;

alter table nielsen_emp add column age INT NOT NULL;
alter table nielsen_emp drop column age;
alter table nielsen_emp change firstname first_name varchar(60); /* change is the alternate to rename column */
alter table nielsen_emp rename column first_name to firstname;

alter table employees modify column firstname varchar(50); /* use modify to change the datatype */

rename table employees to nielsen_emp;
alter table nielsen_emp rename to josh_emp;
  
select * from nielsen_emp;

insert into nielsen_emp (emp_no, birth_date, firstname, last_name, gender, hire_date) values
(895, '1995-04-09', 'Josh', 'Dan', 'M', '2017-05-17');

update josh_emp
set hire_date = '2022-10-18', firstname = 'Josh'
where emp_no = 895;
select * from josh_emp
where emp_no = 895;

delete from nielsen_emp where emp_no = 10001;

/*  DCL - Data Control Language
SQL GRANT statement to grant SQL SELECT, UPDATE, INSERT, DELETE, and other privileges on tables or views
GRANT SELECT, DELETE, UPDATE, DELETE ON Student TO Director
GRANT SELECT, DELETE, UPDATE, DELETE ON Student TO Director WITH GRANT OPTION - allows the director to grant permission to other users.

Issue REVOKE statements to withdraw privileges.

For example, the following statement withdraws the SELECT privilege from user BAKER on the table SMITH.TABLEA:
REVOKE SELECT ON TABLE SMITH.TABLEA FROM BAKER */
grant select on nielsen_emp to joshua with grant option; /* we can use ALL insted of single previlage like select*/
revoke select on nielsen_emp from joshua; /* cannot use ALL*/

/*used after a DML query
begin transaction;
delete from nielsen_emp
where emp_no = 10002;
commit;

select * from nielsen_emp; 


update nielsen_emp 
set hire_date = '2022-10-18', firstname = 'Joshua'
where emp_no = 895;
rollback;

savepoint upd;
rollback to upd;  */



create table cps_emp (
emp_id int not null,
age int check (age>=18),
birth_date varchar(50),
foreign key (gender) references nielsen_emp (gender) on delete cascade,
primary key (emp_no)
);
/* • CHECK - Ensures that the values in a column satisfies a specific condition
• DEFAULT - Sets a default value for a column if no value is specified
CREATE TABLE Persons (
    ID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int,
    City varchar(255) DEFAULT 'Sandnes'
);
Constraints in DDL - primary key, foreign key, unique key, not null, auto increament, check, default, on delete cacade)
*/

select first_name as full_name, gender, hire_date from employees
where hire_date between '2021-01-22' and '2021-05-19';

select*from employees
where dept_no = 'd002' or 'd003'; /* why and not showing result... dif between and , or */

select*from employees
where dept_no in ('d002','d004');

select first_name, last_name from employees
where emp_no = ANY
(select emp_no from salaries
where salary > 50000);
      
   
         
        
         
         
         
      
      
     
     
   

  
  
  
  
  
  
  
  
  
    
     

    
    
 

		








