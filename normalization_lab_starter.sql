/* ================================================================
   CIS 4720  Normalization Lab
   Starter file: normalization_lab_starter.sql

   Name: ______________________________
   Date: ______________________________

   Work in this file and keep its name. It lives in your OneDrive
   folder CIS4720_Normalization, and it is the one file you publish
   to GitHub at the end.

   Write a comment in your own words above every statement.
   Total: 10 points.

   For EVERY problem below, complete all five steps:

     Step 1  DIAGNOSE  Which normal form (1NF, 2NF, or 3NF) does the
                       table break? Why? Name the columns involved.
     Step 2  DESIGN    List your new tables. Mark the primary key (PK)
                       and every foreign key (FK).
     Step 3  CREATE    Write a CREATE TABLE statement for each table,
                       with PRIMARY KEY and FOREIGN KEY constraints.
                       Create parent tables before child tables.
     Step 4  INSERT    Insert at least TWO rows into EVERY table.
                       Insert parent rows before child rows.
     Step 5  JOIN      Write one SELECT with JOINs that shows the data
                       from all of the problem's tables together.

   Use ONLY the table names given in each problem.
   The whole file must run from top to bottom without errors.
   ================================================================ */

CREATE DATABASE IF NOT EXISTS misc_db;
USE misc_db;

show databases;

show tables;

/* ================================================================
   PROBLEM 1  Pet owners and their pets                 (2 points)
   ================================================================

   A pet grooming shop keeps one table named owner_pets:

     owner_id, owner_name, owner_city, pet1_name, pet2_name, pet3_name

   Sample rows:

   owner_id | owner_name   | owner_city | pet1_name | pet2_name | pet3_name
   =========+==============+============+===========+===========+==========
   1        | Maria Lopez  | Turlock    | Bella     | Max       | NULL
   2        | James Chen   | Modesto    | Luna      | NULL      | NULL
   3        | Priya Singh  | Ceres      | Rocky     | Daisy     | Coco

   The shop just signed up a customer with four pets.

   Use these table names:  owner, pet

   Step 1  DIAGNOSE:
/*
The table breaks 1NF because pet1_name, pet2_name, and pet3_name are repeating columns.
Each pet should have its own row instead.
*/

   Step 2  DESIGN:
/*
owner (owner_id PK, owner_name, owner_city)
pet (pet_id PK, pet_name, owner_id FK)
*/

/* Step 3  CREATE */
-- create the owner table
create table owner(
   owner_id int primary key,
   owner_name varchar(50),
   owner_city varchar(50)
);

-- create the pet table and connect it to owner
create table pet(
   pet_id int primary key,
   pet_name varchar(50),
   owner_id int,
   foreign key(owner_id) references owner(owner_id)
);

/* Step 4  INSERT */
-- insert the owners into the owner table
insert into owner values
(1, "Maria Lopez", "Turlock"),
(2, "James Chen", "Modesto"),
(3, "Priya Singh", "Ceres");

-- insert the pets and connect them to their owners
insert into pet values
(1, "Bella", 1),
(2, "Max", 1),
(3, "Luna", 2),
(4, "Rocky", 3),
(5, "Daisy", 3),
(6, "Coco", 3);

/* Step 5  JOIN */
-- show each pet with their owner and city
select o.owner_id, o.owner_name, o.owner_city, p.pet_name
from owner o
join pet p on o.owner_id = p.owner_id;

/* ================================================================
   PROBLEM 2  Apartment buildings and units             (2 points)
   ================================================================

   A property manager keeps one table named building_unit.
   Unit numbers repeat across buildings (every building has a 101),
   so the primary key is (building_id, unit_number).

     building_id, unit_number, building_name, building_address,
     bedrooms, monthly_rent

   Sample rows:

   building_id | unit_number | building_name | building_address  | bedrooms | monthly_rent
   ============+=============+===============+===================+==========+=============
   B1          | 101         | Oak Terrace   | 100 Oak St        | 1        | 1250.00
   B1          | 102         | Oak Terrace   | 100 Oak St        | 2        | 1600.00
   B2          | 101         | Canal Court   | 45 Canal Dr       | 2        | 1550.00
   B2          | 201         | Canal Court   | 45 Canal Dr       | 3        | 1900.00

   Hint: look at which columns need BOTH key columns and which
   need only one of them.

   Use these table names:  building, apartment_unit

   Step 1  DIAGNOSE:
/* 
The table breaks 2NF because building_name and building_address only depend on
building_id instead of the whole primary key (building_id, unit_number).
*/

   Step 2  DESIGN:
/*
building (building_id PK, building_name, building_address)
apartment_unit (building_id PK/FK, unit_number PK, bedrooms, monthly_rent)
*/

/* Step 3  CREATE */
-- create the building table
create table building(
   building_id varchar(5) primary key,
   building_name varchar(50),
   building_address varchar(50)
);

-- create the apartment unit table and connect it to building
create table apartment_unit(
   building_id varchar(5),
   unit_number int,
   bedrooms int,
   monthly_rent decimal(8,2),
   primary key(building_id, unit_number),
   foreign key(building_id) references building(building_id)
);

/* Step 4  INSERT */
-- insert the buildings into the building table
insert into building values
("B1", "Oak Terrace", "100 Oak St"),
("B2", "Canal Court", "45 Canal Dr");

-- insert the apartment units and connect them to their buildings
insert into apartment_unit values
("B1", 101, 1, 1250.00),
("B1", 102, 2, 1600.00),
("B2", 101, 2, 1550.00),
("B2", 201, 3, 1900.00);

/* Step 5  JOIN */
-- show each apartment unit with its building information
select b.building_id, a.unit_number, b.building_name,
b.building_address, a.bedrooms, a.monthly_rent
from building b
join apartment_unit a on b.building_id = a.building_id;

/* ================================================================
   PROBLEM 3  Employees and departments                 (2 points)
   ================================================================

   A company keeps one table named employee_info.
   The primary key is emp_id.

     emp_id, emp_name, hire_year, dept_id, dept_name, dept_phone

   Sample rows:

   emp_id | emp_name      | hire_year | dept_id | dept_name  | dept_phone
   =======+===============+===========+=========+============+=============
   E01    | Linda Park    | 2019      | D10     | Accounting | 209.555.0300
   E02    | Raj Mehta     | 2021      | D20     | Marketing  | 209.555.0400
   E03    | Carlos Vega   | 2022      | D10     | Accounting | 209.555.0300
   E04    | Emma Wilson   | 2024      | D20     | Marketing  | 209.555.0400

   Accounting gets a new phone number. How many rows must change?
   What happens to the Marketing department if Raj and Emma both quit?

   Use these table names:  department, employee

   Step 1  DIAGNOSE:
/*
The table breaks 3NF because dept_name and dept_phone depend on dept_id instead of directly on emp_id.
This creates a transitive dependency because department information is repeated for employees.
*/

   Step 2  DESIGN:
/*
department(dept_id PK, dept_name, dept_phone)
employee(emp_id PK, emp_name, hire_year, dept_id FK)
*/

/* Step 3  CREATE */
-- create the department table
create table department(
   dept_id varchar(5) primary key,
   dept_name varchar(50),
   dept_phone varchar(20)
);

-- create the employee table and connect it to department
create table employee(
   emp_id varchar(5) primary key,
   emp_name varchar(50),
   hire_year int,
   dept_id varchar(5),
   foreign key(dept_id) references department(dept_id)
);

/* Step 4  INSERT */
-- insert the departments into the department table
insert into department values
("D10", "Accounting", "209.555.0300"),
("D20", "Marketing", "209.555.0400");

-- insert the employees and connect them to their departments
insert into employee values
("E01", "Linda Park", 2019, "D10"),
("E02", "Raj Mehta", 2021, "D20"),
("E03", "Carlos Vega", 2022, "D10"),
("E04", "Emma Wilson", 2024, "D20");

/* Step 5  JOIN */
-- show each employee with their department information
select e.emp_id, e.emp_name, e.hire_year,
e.dept_id, d.dept_name, d.dept_phone
from employee e
join department d on e.dept_id = d.dept_id;

/* ================================================================
   PROBLEM 4  Students and courses                     (2.5 points)
              This problem REQUIRES a bridge table with a
              composite primary key.
   ================================================================

   A college keeps one table named student_course.
   One student takes many courses, and one course has many students.

     student_id, student_name, student_major, course_id,
     course_name, course_description, units, grade

   Sample rows:

   student_id | student_name | student_major | course_id | course_name        | course_description                 | units | grade
   ===========+==============+===============+===========+====================+====================================+=======+======
   S100       | Ana Torres   | CIS           | CIS4720   | Database Mgmt      | Relational design and SQL          | 3     | A
   S100       | Ana Torres   | CIS           | CIS2000   | Intro to Python    | Programming fundamentals in Python | 3     | B
   S200       | Ben Shah     | Business      | CIS4720   | Database Mgmt      | Relational design and SQL          | 3     | B
   S300       | Chloe Nguyen | CIS           | CIS2000   | Intro to Python    | Programming fundamentals in Python | 3     | A

   Questions to think about:
     Which columns describe only the STUDENT?
     Which columns describe only the COURSE?
     Which column describes "this student in this course"?

   Use these table names:  student, course, enrollment
   enrollment is the bridge table. Its primary key must be the
   composite key (student_id, course_id), and each of those columns
   must also be a foreign key.

   Step 1  DIAGNOSE:
/*
The table breaks 2NF because student_name and student_major only depend on student_id,
while course_name, course_description, and units only depend on course_id instead of the 
whole composite key (student_id, course_id). Grade depends on both columns.
*/

   Step 2  DESIGN:
/*
student(student_id PK, student_name, student_major)
course(course_id PK, course_name, course_description, units)
enrollment(student_id PK/FK, course_id PK/FK, grade)
*/

/* Step 3  CREATE */
-- create the student table
create table student(
   student_id varchar(5) primary key,
   student_name varchar(50),
   student_major varchar(50)
);

-- create the course table
create table course(
   course_id varchar(10) primary key,
   course_name varchar(50),
   course_description varchar(100),
   units int
);

-- create the enrollment table and connect students to courses
create table enrollment(
   student_id varchar(5),
   course_id varchar(10),
   grade varchar(2),
   primary key(student_id, course_id),
   foreign key(student_id) references student(student_id),
   foreign key(course_id) references course(course_id)
);

/* Step 4  INSERT
   Enroll at least one student in two courses, and put at least two
   students in the same course, so the many to many relationship shows. */
-- insert the students into the student table
insert into student values
("S100", "Ana Torres", "CIS"),
("S200", "Ben Shah", "Business"),
("S300", "Chloe Nguyen", "CIS");

-- insert the courses into the course table
insert into course values
("CIS4720", "Database Mgmt", "Relational design and SQL", 3),
("CIS2000", "Intro to Python", "Programming fundamentals in Python", 3);

-- insert the students and their courses with grades
insert into enrollment values
("S100", "CIS4720", "A"),
("S100", "CIS2000", "B"),
("S200", "CIS4720", "B"),
("S300", "CIS2000", "A");

/* Step 5  JOIN  (three tables: student, enrollment, course) */
-- show students with their courses and grades
select s.student_id, s.student_name, s.student_major,
c.course_id, c.course_name, c.course_description,
c.units, e.grade
from student s
join enrollment e on s.student_id = e.student_id
join course c on e.course_id = c.course_id;

-- show all tables
show tables;