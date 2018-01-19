-- [dbo].[Employee_21351]

-- Question 1
SELECT * FROM [dbo].[Employee_21351];


-- Question 2
SELECT * FROM [dbo].[Employee_21351] 
WHERE deptno = 10

--  3.Display first five records in employee table?
SELECT TOP 5 *
FROM [dbo].[Employee_21351];


--   4.	Display all the records in emp table order by ascending deptno, descending salary?

SELECT * FROM [dbo].[Employee_21351] 
ORDER BY deptno ASC , salary DESC;


-- 5.	Display all employees those who joined in year 1981?	--Try another method
SELECT name FROM [dbo].[Employee_21351]
WHERE hiredate 
BETWEEN '1981-01-01' AND '1981-12-31';


--6.	Display the records in emp table whose MGR/Boss is 7698 or 7566 with salary more than 1500.
SELECT * FROM [dbo].[Employee_21351]
WHERE (boss IN (7698, 7566))
AND salary > 1500;

--7.	Display all employees with how many years they have been serving in the company?
SELECT name, DATEDIFF(year, hiredate,  GETDATE()) AS Experience 
FROM (SELECT * From [dbo].[Employee_21351])M ;

SELECT name, DATEDIFF(year, hiredate,  GETDATE()) AS Experience 
FROM [dbo].[Employee_21351] ;


--8.	Display all employees whose salary is less than the Ford’s salary?

SELECT name FROM [dbo].[Employee_21351] 
WHERE salary > (SELECT salary FROM [dbo].[Employee_21351]  WHERE name = 'FORD');


--9.	Display all records in EMP table those who have joined before SCOTT?
SELECT * FROM  [dbo].[Employee_21351] 
WHERE hiredate < (SELECT hiredate FROM [dbo].[Employee_21351]  WHERE name = 'SCOTT');


--10.	Add 3 months to hire date in EMP table and display the result?
SELECT *,
DATEADD(month,3,hiredate) AS modifiedDate FROM
(SELECT * FROM [dbo].[Employee_21351]) A;

--11.	Display the date for next TUESDAY from today's date?
DECLARE @NextDayID INT  = 1 ;-- 0=Mon, 1=Tue, 2 = Wed, ..., 5=Sat, 6=Sun
SELECT DATEADD(DAY, (DATEDIFF(DAY, @NextDayID, GETDATE()) / 7) * 7 + 7, @NextDayID) AS NextTuesday;

--12.	Write a query display Today's date and 15 days after today’s date.
Select datepart(day, getdate()) as currentdate, datepart(day, getdate()+15) as afterdate;

--13.	Display the list of all jobs from emp table?
SELECT DISTINCT job FROM [dbo].[Employee_21351];

--14.	Display all the records in emp table where employee hired after 28-SEP-81 and before 03-DEC-81?	--Recheck                 done
SELECT * FROM [dbo].[Employee_21351]
WHERE hiredate 
BETWEEN '1981-09-29' AND '1981-12-02';

--15.	Display all jobs that are in department 10. Include the Dept. Name and location of department in the output.
SELECT DISTINCT job FROM  [dbo].[Employee_21351] 
WHERE deptno = 10;

--16.	Write a query to display the employee name, department name of all employees who earn a commission	--Recheck
--SELECT DISTINCT emp.name, dep.dname
--FROM [dbo].[Employee_21351] AS emp, [dbo].[DEPARTMENT] AS dep
--WHERE emp.comm IS NOT NULL;

SELECT emp.name, dep.dname
FROM [dbo].[Employee_21351] AS emp
INNER JOIN [dbo].[DEPARTMENT] AS dep
ON emp.deptno = dep.deptno
WHERE emp.comm IS NOT NULL;

--17.	Display the list of all employees whose salary is greater the average salary of thier the department.

SELECT AVG(ISNULL(salary,0)) AS avgsalary ,deptno
INTO #TE
FROM [dbo].[Employee_21351] 
GROUP BY deptno;
SELECT * FROM #TE;

SELECT E.*,T.avgsalary FROM [dbo].[Employee_21351] E
INNER JOIN #TE AS T 
ON E.deptno = T.deptno
WHERE T.avgsalary < E.salary;



--18.	Display the list of all employees whose salary greater than their manager's salary.
SELECT * FROM [dbo].[Employee_21351] AS A
WHERE A.salary > (SELECT ISNULL(salary,0) FROM [dbo].[Employee_21351] T WHERE T.empno = A.boss);

--19.	Display all employees whose name starts with J and ends with S
SELECT * FROM [dbo].[Employee_21351] 
WHERE name LIKE 'J%S';


--20.	Display the what is maximum salary and who gets it.	
SELECT name, salary FROM [dbo].[Employee_21351]
WHERE salary = (SELECT MAX(salary) AS MaxSalary
FROM [dbo].[Employee_21351] A );

--21.	Display average salary for job SALESMAN
SELECT AVG (salary) AS AverageSalary FROM [dbo].[Employee_21351]
WHERE job= 'SALESMAN';

--22.	Display all names of the employees whose first character could be anything, but second character should be L?
SELECT name FROM [dbo].[Employee_21351]
WHERE name LIKE '_L%';


--23.	Display nth highest and nth lowest salary in emp table? (Use Row_number function) 
--(Display 3rd highest and 3rd lowest)

DECLARE @HIGH INT =  (SELECT salary FROM (SELECT ROW_NUMBER() OVER (ORDER BY salary DESC) AS GeneratedRank, salary 
FROM [dbo].[Employee_21351] WHERE salary IS NOT NULL) A  WHERE GeneratedRank=3);
DECLARE @LOWEST INT = (SELECT salary FROM (SELECT ROW_NUMBER() OVER (ORDER BY salary ASC) AS GeneratedRank, salary 
FROM [dbo].[Employee_21351] WHERE salary IS NOT NULL) A  WHERE GeneratedRank=3);
SELECT @HIGH AS HIGH, @LOWEST AS LOW;

--24.	Display all department with Minimum salary and maximum salary?                                      (Doubt)
--DECLARE @MIN INT = (SELECT MIN( ISNULL (salary,0)) FROM [dbo].[Employee_21351]);
--DECLARE @MAX INT = (SELECT MAX( ISNULL (salary,0)) FROM [dbo].[Employee_21351]);
--DECLARE @dname1 VARCHAR(50) = (SELECT dname FROM [dbo].[DEPARTMENT] WHERE deptno = (SELECT deptno FROM [dbo].[Employee_21351] 
--WHERE  ISNULL(salary,0) = @MIN));
--DECLARE @dname2 VARCHAR(50) = (SELECT dname FROM [dbo].[DEPARTMENT] WHERE deptno = (SELECT deptno FROM [dbo].[Employee_21351] 
--WHERE  ISNULL(salary,0) = @MAX));
--SELECT @dname1 AS minDepartmentName, @dname2 AS maxDepartmentName;

SELECT MIN(ISNULL(salary,0)) AS SalMin, MAX(ISNULL(salary,0)) AS SalMax , deptno FROM [dbo].[Employee_21351] 
GROUP BY deptno ;

--25.	Display all Deptno, Dept Name and all the employees details in that department. 	--Recheck                  DONE
--Departments without any employees should be included in the output. 
SELECT D.deptno, D.dname, E.* 
FROM [dbo].[Employee_21351] AS E
RIGHT JOIN [dbo].[DEPARTMENT] AS D
ON E.deptno = D.deptno
ORDER BY D.deptno;

--26.	Display all employees whose designation is not "Manager"?
SELECT * FROM  [dbo].[Employee_21351] WHERE job <> 'MANAGER';

--27.	Display ename, deptno from emp table with format of {ename} belongs to department {deptno}
--Eg: Allen belongs to department 10.
SELECT concat (name , ' belongs to department ', deptno ) FROM [dbo].[Employee_21351];

--28.	Display ename, deptno from employee table. 
--Also add another column in the same query and it should display ten for dept 10, twenty for dept 20, thirty for dept 30, forty for dept 40 (Use CASE statements)
SELECT name, deptno, (CASE deptno
    WHEN 10 THEN 'ten'
    WHEN  20 THEN 'twenty'
	WHEN  30 THEN 'thirty'
	WHEN  40 THEN 'forty'
    ELSE 'zero'
  END ) AS WordFormat 
FROM [dbo].[Employee_21351];

--29.	Display all the records in emp table. The ename should be lower case. The first letter of the JOB should be in upper case and rest of the letters should be lower case.
SELECT UPPER(LEFT(name,1))+LOWER(SUBSTRING(name,2,LEN(name))) FROM [dbo].[Employee_21351];


--30.	Display the list employees along with their joining date, those who have joined in first week of any month?
SELECT name,hiredate,datepart(week,hiredate)%month(hiredate) as weekno
FROM [SQL Exercise].[dbo].[Employee_21348]
where datepart(week,hiredate)%month(hiredate)=1; 

--31.	Display empno, deptno, salary, salary difference between current record and previous record in emp table. Empid and Deptno should be in descending order. (Use Lead & Lag Functions or Self Join the table)
--SELECT empno, deptno, salary, DIFFERENCE(
select empno,deptno,salary,(abs(salary-lag(salary,1) over (order by empno DESC))) as updatedsal
from [SQL Exercise].[dbo].[Employee_21348]; 


--32.	Create table emp_21XXX (your employee ID) and copy the emp table for deptno 10 while creating the table    (DOUBT)
select * into  [dbo].[emp_21351] from 
  (SELECT * FROM [dbo].[Employee_21351]
   WHERE deptno=10) A ;

--CREATE TABLE [dbo].[emp_21351] AS
 -- (SELECT * FROM [dbo].[Employee_21351]
 --  WHERE deptno=10) ;


--33.	Insert a new record in emp_21XXX table (assign random values).
INSERT INTO  [dbo].[Employee_21351]
VALUES (1010, 'SYAM', 'MANAGER', 7698, 2017-12-26, 1000.00, 200, 10); 

--34.	Display all employee details of the employees whose salary is less than or equal to ADAMS’s salary?
DECLARE @ADAM_SAL INT = (SELECT ISNULL(salary,0) From [dbo].[Employee_21351] WHERE name = 'ADAMS');
SELECT * FROM [dbo].[Employee_21351] WHERE ISNULL(salary,0) < = @ADAM_SAL;

--35.	Display all subordinate those who are working under BLAKE?
SELECT * FROM [dbo].[Employee_21351] AS A
WHERE A.boss = (SELECT empno FROM [dbo].[Employee_21351] WHERE name = 'BLAKE');

--36.	Display employees who have joined in Year 81 as MANAGER?
SELECT * FROM [dbo].[Employee_21351] 
WHERE job = 'MANAGER' AND (hiredate BETWEEN '1981-01-01' AND '1981-12-31');

--37.	Display who is most experienced and least experienced employee? Since how many years they have been working?	--Get names of the employees
--DECLARE @MAXm INT = (SELECT MAX (Experience) FROM (SELECT DATEDIFF(year, hiredate,  GETDATE()) AS Experience 
--FROM [dbo].[Employee_21351])M );
--DECLARE @MINm INT = (SELECT MIN (Experience) FROM (SELECT DATEDIFF(year, hiredate,  GETDATE()) AS Experience 
--FROM [dbo].[Employee_21351])M );
--SELECT @MAXm AS MaxExperience, @MINm AS MinExperience;

SELECT DATEDIFF(year, hiredate,  GETDATE()) AS Experience, * INTO #EXPTAB FROM [dbo].[Employee_21351] ;
SELECT * FROM #EXPTAB ORDER BY Experience DESC;
SELECT name, Experience FROM #EXPTAB WHERE Experience = (SELECT MAX(Experience) FROM #EXPTAB ) 
UNION
SELECT name, Experience FROM #EXPTAB WHERE Experience = (SELECT MIN(Experience) FROM #EXPTAB ) ;

--38.	Display ename, job, dname, deptno of each employee by using view?
CREATE VIEW  E_VI AS
SELECT E.name,D.dname,D.deptno
 FROM [dbo].[Employee_21351] AS E
LEFT JOIN [dbo].[DEPARTMENT] AS D
ON E.deptno = D.deptno;

SELECT * FROM E_VI;

--39.	Display the employee details and his department details and assign a grade based on their salary . (Use SALARYGRADE Table).
SELECT A.empno,A.name,A.job,A.hiredate,A.salary,A.comm,A.boss FROM [dbo].[Employee_21351] AS A
INNER JOIN  [dbo].[SALARYGRADE] AS B
ON A.salary BETWEEN  B.losal AND B.hisal;


--40.	List details of all the employees whose salary doesn’t fall under any salary grade?
-- SELECT * FROM [dbo].[SALARYGRADE]
DECLARE @HIGHEST_SAL INT = (SELECT MAX(hisal) FROM [dbo].[SALARYGRADE]);
DECLARE @LOWEST_SAL INT = (SELECT MIN(losal) FROM [dbo].[SALARYGRADE]);
SELECT * FROM [dbo].[Employee_21351] 
WHERE ISNULL (salary,0) < @LOWEST_SAL OR   ISNULL (salary,0) > @HIGHEST_SAL; 


--41.	Add/Increase commission by 250$ for employees in BLAKE's team (including BLAKE)
DECLARE @BLAKE_EMPNO INT = (SELECT empno FROM [dbo].[Employee_21351] WHERE name ='BLAKE');
UPDATE [dbo].[Employee_21351] 
SET comm = (ISNULL (comm,0) + 250)
WHERE boss = @BLAKE_EMPNO OR name='BLAKE';

--42.	Increase salary by 100$ for employee who is making more than average salary of his department? (Use question17)
SELECT AVG(ISNULL(salary,0)) AS avgsalary, deptno 
INTO #T
FROM [dbo].[Employee_21351] 
GROUP BY deptno;
SELECT * FROM #T;
 
SELECT K.salary,K.name  From 
(SELECT E.*,T.avgsalary FROM [dbo].[Employee_21351] E
INNER JOIN #T AS T 
ON E.deptno = T.deptno
WHERE T.avgsalary < E.salary)K;

Select K.salary+100 AS UpdatedSalary, K.name FROM (SELECT E.*,T.avgsalary FROM [dbo].[Employee_21351] E
INNER JOIN #T AS T 
ON E.deptno = T.deptno
WHERE T.avgsalary < E.salary)K;



--43.	Increase salary by 1% for employee who is drawing lowest salary in dept 10.
SELECT MIN(ISNULL(salary,0))*1.1 AS MINIMUM,deptno FROM [dbo].[Employee_21351] GROUP BY deptno HAVING deptno=10 ;

--44.	Reduce the commission amount from salary for all the employees who have joined after ALLEN.
DECLARE @ALLENDATE VARCHAR = (SELECT hiredate FROM [dbo].[Employee_21351] WHERE name= 'ALLEN');
UPDATE [dbo].[Employee_21351] 
SET salary= (salary-comm)
WHERE hiredate > @ALLENDATE AND (salary IS NOT NULL);
 
--45.	Increase commission by 10$ for employees who are in NEW YORK.
UPDATE [dbo].[Employee_21351]
SET comm = (comm + 10) WHERE deptno = (SELECT deptno FROM [dbo].[DEPARTMENT] WHERE location = 'NEW YORK') ;

--46.	Update MARTIN salary same as SMITH's salary.
DECLARE @sal INT = (SELECT salary FROM [dbo].[Employee_21351] WHERE name = 'SMITH')
UPDATE  [dbo].[Employee_21351]
SET salary=  @sal 
WHERE name = 'MARTIN';

--47.	Display all employees who have joined in the 49th week of the year?
SELECT *
FROM [dbo].[Employee_21348]
where datepart(week,hiredate)=49; 

--48.	Display sum of salary for each department.
SELECT SUM(ISNULL(salary,0)) AS sumDeparmentSal, deptno FROM [dbo].[Employee_21351] 
GROUP BY deptno;

--49.	Display all the departments which have at least 3 employees.
SELECT deptno FROM [dbo].[Employee_21351] 
GROUP BY deptno
HAVING COUNT(deptno)>3;

--50.	Display all the records in EMP table along with the Row No. (Serial No.)
SELECT ROW_NUMBER() OVER (ORDER BY salary DESC) AS [Serial No.], *
FROM [dbo].[Employee_21351] ;

--SELECT * FROM  [dbo].[DEPARTMENT]
--SELECT * FROM [dbo].[Employee_21351];
-- SELECT * FROM [dbo].[SALARYGRADE]


CREATE TABLE visitsTable (
	VID  INT,
	CLIENTID INT,
	CLASSDATE DATE
);

INSERT INTO visitsTable
VALUES (1,1,'20161205'); 
INSERT INTO visitsTable
VALUES (2,1,'20170905'); 
INSERT INTO visitsTable
VALUES (3,1,'20171105'); 
INSERT INTO visitsTable
VALUES (4,1,'20171205');

INSERT INTO visitsTable
VALUES (5,2,'20161205'); 
INSERT INTO visitsTable
VALUES (6,2,'20170906'); 
INSERT INTO visitsTable
VALUES (7,2,'20171107'); 
INSERT INTO visitsTable
VALUES (8,2,'20171208'); 

INSERT INTO visitsTable
VALUES (9,3,'20160905'); 
INSERT INTO visitsTable
VALUES (10,3,'20170205'); 
INSERT INTO visitsTable
VALUES (11,3,'20170305');  	
INSERT INTO visitsTable
VALUES (12,3,'20170610'); 


INSERT INTO visitsTable
VALUES (13,4,'20161205'); 
INSERT INTO visitsTable
VALUES (14,4,'20161205'); 
INSERT INTO visitsTable
VALUES (15,4,'20161205'); 
INSERT INTO visitsTable
VALUES (16,4,'20161205'); 

INSERT INTO visitsTable
VALUES (17,5,'20170505'); 
INSERT INTO visitsTable
VALUES (18,5,'20170613'); 
INSERT INTO visitsTable
VALUES (19,5,'20170615'); 
INSERT INTO visitsTable
VALUES (20,5,'20170625'); 

SELECT * FROM visitsTable;

SELECT CLIENTID, DATEPART(MONTH,CLASSDATE) AS VISITEDMONTH , DATEPART(YEAR , CLASSDATE) AS VISITEDYEAR FROM visitsTable 
ORDER BY VISITEDMONTH;

--SELECT EVERYMONTH, COUNT(CLIENTID) AS NOOFGUESTS FROM (SELECT  (CASE DATEPART(MONTH, CLASSDATE)
--    WHEN 1 THEN 'JAN'
--    WHEN  2 THEN 'FEB'
--	WHEN  3 THEN 'MAR'
--	WHEN  4 THEN 'APR'
--	WHEN  5 THEN 'MAY'
--	WHEN 6 THEN 'JUNE'
--	WHEN 7 THEN 'JULY'
--	WHEN 8 THEN 'AUG'
--	WHEN 9 THEN 'SEP'
--	WHEN 10 THEN 'OCT'
--	WHEN 11 THEN 'NOV'
--	WHEN 12 THEN 'DEC'
--		END ) AS EVERYMONTH, CLIENTID
--FROM visitsTable ) M GROUP BY EVERYMONTH;


--SELECT CLIENTID, DATEPART(MONTH,MIN(CLASSDATE)) AS FIRSTVISITMONTH FROM visitsTable GROUP BY CLIENTID;

--SELECT FIRSTVISTMONTH, NEWGUESTS, NOOFGUESTS-NEWGUESTS AS EXISTINGGUESTS FROM 

SELECT FIRSTVISITMONTH, COUNT(CLIENTID) AS NEWGUESTS 
FROM (SELECT CLIENTID, DATEPART(MONTH,MIN(CLASSDATE)) AS FIRSTVISITMONTH FROM visitsTable GROUP BY CLIENTID) M
GROUP BY FIRSTVISITMONTH ;

CREATE TABLE SALES (
	SLID  INT,
	UNITS INT,
	SLDATE DATE
);

INSERT INTO SALES
VALUES (1,10,'20161205'); 
INSERT INTO SALES
VALUES (2,100,'20170905'); 
INSERT INTO SALES
VALUES (3,30,'20171105'); 
INSERT INTO SALES
VALUES (4,60,'20171205');

INSERT INTO SALES
VALUES (5,2,'20161205'); 
INSERT INTO SALES
VALUES (6,12,'20170906'); 
INSERT INTO SALES
VALUES (7,42,'20171107'); 
INSERT INTO SALES
VALUES (8,92,'20171208'); 

INSERT INTO SALES
VALUES (9,37,'20160905'); 
INSERT INTO SALES
VALUES (10,63,'20170205'); 

--SELECT * FROM SALES;

--SELECT DATEPART(MONTH,SLDATE) AS MTD, UNITS FROM SALES; 

--SELECT  MTD, SUM(UNITS) AS TLUNITS 
--FROM (SELECT DATEPART(MONTH,SLDATE) AS MTD, UNITS FROM SALES) M 
--GROUP BY MTD;

--SELECT MTD, SUM(UNITS) AS RLTEN FROM 
--(SELECT DATEPART(MONTH,SLDATE) AS MTD, UNITS, SLDATE FROM SALES) M 
--WHERE SLDATE BETWEEN DATEADD(DAY,-10,SLDATE)  AND SLDATE 
--GROUP BY MTD;



--SELECT A.MTD, TLUNITS, RLTEN FROM 
--(SELECT  MTD, SUM(UNITS) AS TLUNITS 
--FROM (SELECT DATEPART(MONTH,SLDATE) AS MTD, UNITS FROM SALES) M 
--GROUP BY MTD)A
--INNER JOIN 
--(SELECT MTD, SUM(UNITS) AS RLTEN FROM 
--(SELECT DATEPART(MONTH,SLDATE) AS MTD, UNITS, SLDATE FROM SALES) M 
--WHERE SLDATE BETWEEN DATEADD(DAY,-10,SLDATE)  AND SLDATE 
--GROUP BY MTD) B
--ON A.MTD = B.MTD;

Declare @vardate DATE ='20160905';

SELECT A.MTD, TLUNITS, RLTEN FROM 
(SELECT  MTD, SUM(UNITS) AS TLUNITS 
FROM (SELECT DATEPART(MONTH,@vardate) AS MTD, UNITS FROM SALES WHERE SLDATE 
BETWEEN DATEADD(month, DATEDIFF(month, 0, @vardate), 0)  AND @vardate) M 
GROUP BY MTD)A
INNER JOIN 
(SELECT MTD, SUM(UNITS) AS RLTEN FROM 
(SELECT DATEPART(MONTH,@vardate) AS MTD, UNITS, SLDATE FROM SALES) M 
WHERE SLDATE BETWEEN DATEADD(DAY,-10,@vardate)  AND @vardate 
GROUP BY MTD) B
ON A.MTD = B.MTD;


--Declare @vardate DATE ='20160905';
--SELECT DATEADD(month, DATEDIFF(month, 0, @vardate), 0) AS StartOfMonth;

--CREATE TABLE SALES (
--	SLID  INT,
--	UNITS INT,
--	SLDATE DATE
--);

CREATE TABLE visitsTable (
	VID  INT,
	CLIENTID INT,
	CLASSDATE DATE
);

INSERT INTO visitsTable
VALUES (1,1,'20161205'); 
INSERT INTO visitsTable
VALUES (2,1,'20170905'); 
INSERT INTO visitsTable
VALUES (3,1,'20171105'); 
INSERT INTO visitsTable
VALUES (4,1,'20171205');

INSERT INTO visitsTable
VALUES (5,2,'20161205'); 
INSERT INTO visitsTable
VALUES (6,2,'20170906'); 
INSERT INTO visitsTable
VALUES (7,2,'20171107'); 
INSERT INTO visitsTable
VALUES (8,2,'20171208'); 

INSERT INTO visitsTable
VALUES (9,3,'20160905'); 
INSERT INTO visitsTable
VALUES (10,3,'20170205'); 
INSERT INTO visitsTable
VALUES (11,3,'20170305');  	
INSERT INTO visitsTable
VALUES (12,3,'20170610'); 


INSERT INTO visitsTable
VALUES (13,4,'20161205'); 
INSERT INTO visitsTable
VALUES (14,4,'20161205'); 
INSERT INTO visitsTable
VALUES (15,4,'20161205'); 
INSERT INTO visitsTable
VALUES (16,4,'20161205'); 

INSERT INTO visitsTable
VALUES (17,5,'20170505'); 
INSERT INTO visitsTable
VALUES (18,5,'20170613'); 
INSERT INTO visitsTable
VALUES (19,5,'20170615'); 
INSERT INTO visitsTable
VALUES (20,5,'20170625'); 

CREATE TABLE SALE (
	SLID  INT,
	CLIENTID INT,
	AMOUNT INT,
	SLDATE DATE
);

INSERT INTO SALE
VALUES (1,1,10,'20161205'); 
INSERT INTO SALE
VALUES (2,2,100,'20170905'); 
INSERT INTO SALE
VALUES (3,2,30,'20171105'); 
INSERT INTO SALE
VALUES (4,1,60,'20171205');

INSERT INTO SALE
VALUES (5,4,2,'20161205'); 
INSERT INTO SALE
VALUES (6,3,12,'20170906'); 
INSERT INTO SALE
VALUES (7,1,42,'20171107'); 
INSERT INTO SALE
VALUES (8,2,92,'20171208'); 

INSERT INTO SALE
VALUES (9,3,37,'20160905'); 
INSERT INTO SALE
VALUES (10,4,63,'20170205'); 
INSERT INTO SALE
VALUES (11,5,63,'20170205'); 



SELECT * FROM SALE;
SELECT * FROM visitsTable;


SELECT CLIENTID, DATEPART(MONTH,MIN(CLASSDATE)) AS FIRSTVISITMONTH FROM visitsTable GROUP BY CLIENTID;

SELECT FIRSTVISITMONTH, SUM(AMOUNT) FROM (SELECT DATEPART(MONTH,MIN(SLDATE)) AS FIRSTVISITMONTH FROM SALE  GROUP BY CLIENTID) M;
SELECT CLIENTID,DATEPART(MONTH,MIN(SLDATE)) AS FIRSTVISITMONTH FROM SALE  GROUP BY CLIENTID;

SELECT SUM(AMOUNT) AS NGREV FROM SALE AS S
INNER JOIN (SELECT CLIENTID,DATEPART(MONTH,MIN(SLDATE)) AS FIRSTVISITMONTH FROM SALE  GROUP BY CLIENTID) M
ON M.FIRSTVISITMONTH = DATEPART(MONTH,S.SLDATE);

SELECT CLIENTID, AMOUNT, DATEPART(MONTH,SLDATE) AS MONTHPART FROM SALE;

--ANSWER

SELECT SALEMONTH, SUM(AMOUNT) AS TLAMOUNT INTO #TABLEB FROM (SELECT DATEPART(MONTH,SLDATE) AS SALEMONTH, AMOUNT FROM SALE) S GROUP BY SALEMONTH;

SELECT * FROM #TABLEB;

-- ANSWER
SELECT MONTHPART, SUM(SUMAMOUNT) AS NGREV INTO #TABLEA FROM (

SELECT R.CLIENTID, MONTHPART, SUMAMOUNT FROM (

SELECT CLIENTID,MONTHPART, SUM(AMOUNT) AS SUMAMOUNT 
FROM (SELECT CLIENTID, AMOUNT, DATEPART(MONTH,SLDATE) AS MONTHPART FROM SALE) M GROUP BY MONTHPART,CLIENTID
) Q
INNER JOIN (

SELECT CLIENTID, MIN(MONTHPART) AS MINMONTH FROM (
SELECT CLIENTID,MONTHPART, SUM(AMOUNT) AS SUMAMOUNT 
FROM (SELECT CLIENTID, AMOUNT, DATEPART(MONTH,SLDATE) AS MONTHPART FROM SALE) M GROUP BY MONTHPART,CLIENTID
)X
GROUP BY CLIENTID
) R
ON (R.CLIENTID= Q.CLIENTID AND R.MINMONTH=Q.MONTHPART)

)K GROUP BY MONTHPART;

SELECT * FROM #TABLEA;

--SELECT CLIENTID,MONTHPART, SUM(AMOUNT) AS SUMAMOUNT 
--FROM (SELECT CLIENTID, AMOUNT, DATEPART(MONTH,SLDATE) AS MONTHPART FROM SALE) M GROUP BY MONTHPART,CLIENTID

--SELECT CLIENTID, MIN(MONTHPART) AS MINMONTH FROM (
--SELECT CLIENTID,MONTHPART, SUM(AMOUNT) AS SUMAMOUNT 
--FROM (SELECT CLIENTID, AMOUNT, DATEPART(MONTH,SLDATE) AS MONTHPART FROM SALE) M GROUP BY MONTHPART,CLIENTID
--)X
--GROUP BY CLIENTID

--Answer
SELECT MONTHPART,TLAMOUNT, NGREV,(NGREV*100.0/TLAMOUNT) AS PERCENTNG  FROM (
#TABLEA AS A
INNER JOIN 
#TABLEB AS B
ON A.MONTHPART= B.SALEMONTH
);









CREATE TABLE APPONTMENTS (
APPID INT,
CLIENTID INT,
APPSTATUS VARCHAR(20),
APPDATE DATE
);

INSERT INTO APPONTMENTS
VALUES (1,1,'ARR','20161205'); 
INSERT INTO APPONTMENTS
VALUES (2,2,'ARR','20170905'); 
INSERT INTO APPONTMENTS
VALUES (3,2,'RES','20171105'); 
INSERT INTO APPONTMENTS
VALUES (4,1,'ARR','20171205');

INSERT INTO APPONTMENTS
VALUES (5,4,'ARR','20161205'); 
INSERT INTO APPONTMENTS
VALUES (6,3,'RES','20170906'); 
INSERT INTO APPONTMENTS
VALUES (7,1,'ARR','20171107'); 
INSERT INTO APPONTMENTS
VALUES (8,2,'RES','20171208'); 

INSERT INTO APPONTMENTS
VALUES (9,3,'ARR','20160905'); 
INSERT INTO APPONTMENTS
VALUES (10,4,'RES','20170205'); 
INSERT INTO APPONTMENTS
VALUES (11,5,'ARR','20170205'); 



SELECT * FROM APPONTMENTS;
SELECT * FROM visitsTable;

--Answer
SELECT  APPMONTH, COUNT(CLIENTID) AS NOOFAPP FROM (
SELECT DATEPART(MONTH,APPDATE) AS APPMONTH, CLIENTID FROM  APPONTMENTS
) A
GROUP BY APPMONTH;

-- Answer
SELECT FIRSTVISITMONTH, COUNT(CLIENTID) AS NEWGUESTS INTO #TABLEC
FROM (SELECT CLIENTID, DATEPART(MONTH,MIN(CLASSDATE)) AS FIRSTVISITMONTH FROM visitsTable GROUP BY CLIENTID) M
GROUP BY FIRSTVISITMONTH ;

SELECT * FROM #TABLEC;

SELECT  MONTHVIS,COUNT(CLIENTID) AS TLGUESTS INTO #TABELD FROM (
SELECT CLIENTID,DATEPART(MONTH,CLASSDATE) AS MONTHVIS FROM visitsTable) K
 GROUP BY MONTHVIS;

 SELECT * FROM #TABELD;

-- Answer 
 SELECT MONTHVIS, NEWGUESTS, (TLGUESTS-NEWGUESTS) AS EXISTINGUEST FROM #TABLEC
 INNER JOIN #TABELD
 ON #TABLEC.FIRSTVISITMONTH= #TABELD.MONTHVIS;

 --Answer
 SELECT MONTHPART, COUNT(APPSTATUS) AS ARRCOUNT FROM (
 SELECT APPSTATUS,DATEPART(MONTH,APPDATE) AS MONTHPART  FROM APPONTMENTS WHERE APPSTATUS='ARR') K
 GROUP BY MONTHPART;

 SELECT CLIENTID,MIN(APPDATE) AS MINDATE FROM APPONTMENTS GROUP BY CLIENTID;

 SELECT CLIENTID,MAX(APPDATE) AS MAXDATE FROM APPONTMENTS GROUP BY CLIENTID;

 --Answer
 SELECT CLIENTID, DATEDIFF(y,MINDATE,MAXDATE) AS MAXDIF FROM (

SELECT P.CLIENTID,MAXDATE, MINDATE FROM (
 (SELECT CLIENTID,MAX(APPDATE) AS MAXDATE FROM APPONTMENTS GROUP BY CLIENTID) P
 INNER JOIN 
 (SELECT CLIENTID,MIN(APPDATE) AS MINDATE FROM APPONTMENTS GROUP BY CLIENTID) Q
 ON P.CLIENTID= Q.CLIENTID
  )
)R;

--Answer
SELECT CLIENTID,MAX(ISNULL(APPDIFF,0)) AS MAXAPPDIFF FROM 
(
	SELECT CLIENTID,DATEDIFF(DAYOFYEAR,APPDATE,lag(APPDATE,1) OVER (PARTITION BY CLIENTID ORDER BY APPDATE DESC)) AS APPDIFF FROM (
	SELECT ROW_NUMBER() OVER (PARTITION BY CLIENTID ORDER BY APPDATE) AS RNO, CLIENTID,APPDATE FROM APPONTMENTS 
	)L 
)K
GROUP BY CLIENTID;
 
--Answer
SELECT AVG(ISNULL(APPDIFF,0)) AS AVGDIFF FROM 
(
	SELECT CLIENTID,DATEDIFF(DAYOFYEAR,APPDATE,lag(APPDATE,1) OVER (PARTITION BY CLIENTID ORDER BY APPDATE DESC)) AS APPDIFF FROM (
	SELECT ROW_NUMBER() OVER (PARTITION BY CLIENTID ORDER BY APPDATE) AS RNO, CLIENTID,APPDATE FROM APPONTMENTS 
	)L 
)K;



