CREATE TABLE DEPARTMENT(
	deptid NUMBER(3,0),
	deptname VARCHAR2(20),
	location VARCHAR2(20));

ALTER TABLE DEPARTMENT
ADD CONSTRAINT dept_id_d_pk PRIMARY KEY (deptid);

CREATE TABLE EMPLOYEE(
	emp_id CHAR(9),
	empname VARCHAR2(20),
	gender CHAR(1),
	DOB Date,
	HireDate Date,
	Sal NUMBER(7,2),
	CNIC NUMBER(13) unique,
	AGE NUMBER(3,0),
	deptid NUMBER(3));

ALTER TABLE EMPLOYEE
ADD CONSTRAINT emp_id_e_pk PRIMARY KEY (emp_id);

ALTER TABLE EMPLOYEE
ADD CONSTRAINT dept_id_e_fk FOREIGN KEY (deptid) REFERENCES Department(deptid);

CREATE TABLE PROJECT(
	PNumber CHAR(3),
	Pname VARCHAR2(20),
	Ploc VARCHAR2(15),
	deptid NUMBER(3,0));

ALTER TABLE Project
ADD CONSTRAINT p_number_p_pk PRIMARY KEY (PNumber);

ALTER TABLE Project
ADD CONSTRAINT dept_id_p_fk FOREIGN KEY (deptid) REFERENCES Department(deptid);

CREATE TABLE WORKS_ON(
	empno CHAR(9),
	Pnumber CHAR(3),
	NumberOfHours NUMBER(3,0),
	RatePerHour NUMBER (3,0));

ALTER TABLE WORKS_ON
ADD COSNTRAINT emp_pnumber_wo_pk PRIMARY KEY (empno,Pnumber);

ALTER TABLE WORKS_ON
ADD COSNTRAINT emp_no_wo_fk FOREIGN KEY (empno) REFERENCES Employee(emp_id);

ALTER TABLE WORKS_ON
ADD COSNTRAINT P_number_wo_fk FOREIGN KEY (pnumber) REFERENCES Project(Pnumber);

CREATE TABLE Dependents(
	Empno NUMBER(9,0),
	DepName VARCHAR2(30),
	Gender CHAR(1),
	Relationship VARCHAR2(9),
	DOB Date,
	Age NUMBER(3,0));

ALTER TABLE Dependents
ADD CONSTRAINT empno_d_fk FOREIGN KEY (empno) REFERENCES Employee(emp_id);

ALTER TABLE Dependents
ADD CONSTRAINT empno_depname_d_pk PRIMARY KEY (empno,depname);
	

QUERY NO. 1:

SELECT e.empname, d.deptname, e.sal
FROM employee e,department d
WHERE d.deptid=e.deptid
AND e.GENDER='F'
AND d.location='US'
AND e.SAL > 20000
ORDER BY e.SAL DESC;


QUERY NO. 2:

SELECT e.empname, d.deptname
FROM employee e,department d
WHERE e.deptid=d.deptid
AND e.GENDER='F'
AND d.location='US'
AND e.Hiredate > ('31-DEC-2010')
;


QUERY NO. 3:

SELECT empname, sal, hiredate
FROM employee 
WHERE AGE < 30
AND SAL > 30000;


QUERY No. 4:

SELECT e.empname, d.deptname, p.pname
FROM employee e, department d, project p,works_on w
WHERE d.deptid=e.deptid
AND e.emp_id=w.empno
AND w.pnumber=p.pnumber
AND p.pnumber IN (SELECT pnumber FROM project WHERE ploc='GERMANY');

QUERY NO. 5:

SELECT e.empname, d.deptname, e.age
FROM employee e, department d
WHERE e.deptid=d.deptid
AND d.location IN ('US','UK')
AND e.age > 55;

QUERY NO. 6:

SELECT e.empname, d.deptname, e.sal
FROM employee e, department d
WHERE d.deptid=e.deptid
AND e.age > 30
AND e.Sal > 40000
ORDER BY e.sal DESC;

QUERY NO. 7:

SELECT e.empname, d.deptname, e.age
FROM employee e, department d
WHERE e.deptid=d.deptid
AND e.Gender='F'
AND d.deptid IN (SELECT deptid FROM department WHERE location IN ('India'));

QUERY NO. 8:

SELECT e.empname, d.deptname, e.age
FROM employee e, department d
WHERE e.deptid=d.deptid
AND e.Gender='F';

SELECT e.empname, e.sal, w.OVERTIMESAL
FROM employee e, works_on w
WHERE e.emp_id=w.empno
AND w.empno IN (SELECT empno FROM WORKS_ON WHERE NUMBEROFHOURS < 2);

QUERY NO. 9:

SELECT e.empname, e.sal, w.OVERTIMESAL
FROM employee e, works_on w
WHERE e.emp_id=w.empno
AND w.empno IN (SELECT empno FROM WORKS_ON WHERE RATEPERHOUR < 950);

QUERY NO. 10:

SELECT d.deptname,COUNT(*) AS NUMBER_OF_EMPLOYEES
FROM department d, employee e
WHERE e.deptid=d.deptid
GROUP BY d.deptname;

QUERY NO. 11:

SELECT w.pnumber,COUNT(*) as NUMBER_OF_EMPLOYEES
FROM works_on w, employee e
WHERE e.emp_id=w.empno
GROUP BY w.pnumber;

QUERY NO. 12:

SELECT w.deptid,COUNT(*) as NUMBER_OF_PROJECTS
FROM project w, department e
WHERE e.deptid=w.deptid
GROUP BY w.deptid
ORDER BY w.deptid ASC;


///////////////////////////////////////////////////
DELETE WHOLE DATASET 1:

DELETE FROM WORKS_ON WHERE NUMBEROFHOURS < 5;

commit;

DELETE FROM Project WHERE PLOC IN ('UK','US','INDIA');

commit;

DELETE FROM Project WHERE PLOC NOT IN ('UK','US','INDIA');

commit;

DELETE FROM EMPLOYEE WHERE AGE < 100;

COMMIT;
////////////////////////////////////////////////////
///////////// QUERY NO 1 //////////////////////////
//////////////////////////////////////////////////
select e.empname,d.depname,d.relationship,d.age
from dependents d, employee e
WHERE (d.empno,e.empname) IN (select emp_id,empname from employee where (AGE > 30 and sal >30000))
and d.age > 10;

select e.empname,d.depname,d.relationship
from dependents d FULL OUTER JOIN employee e 
ON d.empno=e.emp_id
WHERE d.age > 10
AND (e.age > 30 AND sal >30000);

select e.empname,d.depname,d.relationship
from dependents d FULL OUTER JOIN employee e 
ON d.empno=e.emp_id
WHERE d.relationship = 'SON'
AND (e.emp_id IN (select DISTINCT(empno) from works_on where NUMBEROFHOURS > 2));

select e.empname,d.depname,d.relationship
from dependents d FULL OUTER JOIN employee e 
ON d.empno=e.emp_id
WHERE (d.relationship = 'SON' OR d.age > 20)
AND ((e.emp_id IN (select DISTINCT(empno) from works_on where NUMBEROFHOURS > 2)) OR (e.age > 30 AND e.sal >30000))
ORDER BY e.empname;


(select e.empname,d.depname,d.relationship
from dependents d FULL OUTER JOIN employee e 
ON d.empno=e.emp_id
WHERE d.age > 20
AND (e.age > 30 AND sal >30000))
UNION
(select e.empname,d.depname,d.relationship
from dependents d FULL OUTER JOIN employee e 
ON d.empno=e.emp_id
WHERE d.relationship = 'SON'
AND (e.emp_id IN (select DISTINCT(empno) from works_on where NUMBEROFHOURS > 2)));
////////////////////////////////////////////////////
///////////// QUERY NO 2 //////////////////////////
//////////////////////////////////////////////////
SELECT e.emp_id,COUNT(empname) as NUMBER_OF_PROJECTS 
FROM employee e, works_on w 
WHERE w.empno=e.emp_id  
GROUP BY e.emp_id; 


SELECT em.empname,p.pname,wo.numberofhours
FROM employee em,project p, works_on wo,(SELECT e.emp_id,COUNT(*) as NUMBER_OF_PROJECTS FROM employee e, works_on w WHERE w.empno=e.emp_id GROUP BY e.emp_id HAVING COUNT(*)>2) Alpha
WHERE em.emp_id=wo.empno
AND p.pnumber =wo.pnumber
AND wo.empno=Alpha.emp_id
ORDER by em.empname; 

SELECT em.empname,p.pname,wo.numberofhours
FROM employee em,project p, works_on wo
WHERE em.emp_id=wo.empno
AND wo.pnumber=p.pnumber
AND p.pnumber IN (SELECT pnumber from project WHERE pname IN ('Holly Grail','Foundation'))
ORDER by em.empname;

SELECT e.empname,d.depname,d.relationship,p.pname,w.numberofhours
FROM employee e,dependents d, project p, works_on w, (SELECT e.emp_id,COUNT(*) as NUMBER_OF_PROJECTS FROM employee e, works_on w WHERE w.empno=e.emp_id GROUP BY e.emp_id HAVING COUNT(*)>2) Alpha
WHERE ((e.emp_id=w.empno) OR (e.emp_id IN(SELECT DISTINCT(em.emp_id) 
										FROM employee em,project p, works_on wo
										WHERE em.emp_id=wo.empno
										AND wo.pnumber=p.pnumber
										AND p.pnumber IN (SELECT pnumber from project WHERE pname IN ('Holly Grail','Foundation')))))
AND p.pnumber=w.pnumber
AND w.empno=Alpha.emp_id;

(SELECT e.empname,d.depname,d.relationship
FROM employee e,dependents d
WHERE d.empno=e.emp_id
AND e.emp_id IN(
SELECT DISTINCT(em.emp_id) 
FROM employee em,project p, works_on wo
WHERE em.emp_id=wo.empno
AND wo.pnumber=p.pnumber
AND p.pnumber IN (SELECT pnumber from project WHERE pname IN ('Holly Grail','Foundation'))))
UNION
(SELECT em.empname,p.pname,wo.numberofhours
FROM employee em,project p, works_on wo,(SELECT e.emp_id,COUNT(*) as NUMBER_OF_PROJECTS FROM employee e, works_on w WHERE w.empno=e.emp_id GROUP BY e.emp_id HAVING COUNT(*)>2) Alpha
WHERE em.emp_id=wo.empno
AND p.pnumber =wo.pnumber
AND wo.empno=Alpha.emp_id); 

