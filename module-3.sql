--1. How many Programmers Don’t know PASCAL and C
select count(*) from programmer where PROF1 not in ('Pascal') and PROF2 not in ('C')


--2. Display the details of those who don’t know Clipper, COBOL or PASCAL.
select * from programmer where PROF1 not in ('Clipper','Cobol','Pascal') and PROF2 not in ('Clipper','Cobol','Pascal')

--3. Display each language name with AVG Development Cost, AVG Selling Cost and AVG Price per Copy.

select DEVELOPIN as LANG_NAME ,avg(DCOST) as AVG_DEVCOST,avg(SCOST) as SELLING_COST,avg(SCOST)  as AVG_PRICE from software  group by DEVELOPIN

-- 4. List the programmer names (from the programmer table) and No. Of Packages each has developed.
select prg.pname ,count(title) as Num_Of_Package from programmer as prg inner join software as st on st.PNAME=prg.PNAME group by prg.PNAME
-- 5. List each PROFIT with the number of Programmers having that PROF and the number of the packages in that PROF.

select count(*) as Num_Pro,SUM((SCOST*SOLD)/DCOST) as Profit  from software where DEVELOPIN IN (select PROF1 from programmer union select prof2 from programmer) group by PNAME

-- 6. How many packages are developed by the most experienced programmer form BDPS.

select PNAME,count(*) from software where pname in ((select max(datediff(year,doj,getdate())) as exp_programmer from studies inner join programmer on programmer.pname=studies.pname where institute='BDPS')) group by PNAME

-- 7. How many packages were developed by the female programmers earning more than the highest paid male programmer?

select count(developin) as packages from programmer p inner join software as s on p.pname=s.pname where p.SALARY > (select max(SALARY) as max_salary from programmer where gender='M') and p.GENDER='F'
 
-- 8. How much does the person who developed the highest selling package earn and what course did HE/SHE undergo.

select study.COURSE,p.SALARY from software as s inner join studies as study on study.PNAME=s.PNAME inner join programmer as p on p.PNAME=study.PNAME where (s.SCOST)=(select Max(SCOST) as total_selling_price from software)

-- 9. In which institute did the person who developed the costliest package study?

select study.INSTITUTE from studies as study inner join software as soft on soft.PNAME=study.PNAME where DCOST=(select max(DCOST) from software)

-- 10. Display the names of the programmers who have not developed any packages.
select programmer.PNAME from programmer LEFT join software on software.PNAME=programmer.PNAME where software.PNAME is null;


-- 11. Display the details of the software that has developed in the language which is neither the first nor the second proficiency
select s.* from programmer p inner join software s on s.pname=p.pname where (developin <> prof1 and developin <> prof2);

-- 12. Display the details of the software Developed by the male programmers Born before 1965 and female programmers born after 1975
select * from software as s inner join programmer p on p.PNAME=s.PNAME where (year(dob)<1965 and gender='M') or (year(dob)>1975 and gender='F')

-- 13. Display the number of packages, No. of Copies Sold and sales value of each programmer institute wise.

SELECT s.PNAME as Na_me,s.INSTITUTE ,COUNT(developin) as num_of_pack,sold as no_of_copies_sold,SCOST as sales_value from software soft  inner join studies s on  s.PNAME=soft.PNAME group by DEVELOPIN,SOLD,SCOST ,s.PNAME,s.INSTITUTE

-- 14. Display the details of the Software Developed by the Male Programmers Earning More than 3000/

select p.PNAME as nam,  soft.DEVELOPIN as software_devloped  from software soft inner join programmer p on p.pname=soft.PNAME where p.GENDER='M' and p.SALARY>3000

-- 15. Who are the Female Programmers earning more than the Highest Paid male?

select * from programmer where SALARY>(select max(salary)  from programmer where gender='M' ) and GENDER='F'

-- 16. Who are the male programmers earning below the AVG salary of Female Programmers?

select * from programmer where SALARY<(select avg(salary) from programmer where gender='F' ) and GENDER ='M'

-- 17. Display the language used by each programmer to develop the Highest Selling and Lowest-selling package.

SELECT
    s.DEVELOPIN,
    p.PNAME,
    (
        SELECT TOP 1 TITLE
        FROM software s2
        WHERE s2.DEVELOPIN = s.DEVELOPIN
        ORDER BY s2.SCOST DESC
    ) AS high_sell_pack,
    (
        SELECT TOP 1 TITLE
        FROM software s3
        WHERE s3.DEVELOPIN = s.DEVELOPIN
        ORDER BY s3.SCOST ASC
    ) AS low_sell_pack
FROM
    software s
JOIN
    programmer p ON s.PNAME = p.PNAME
GROUP BY
    s.DEVELOPIN, p.PNAME;


-- 18. Display the names of the packages, which have sold less than the AVG number of copies.

SELECT TITLE FROM SOFTWARE WHERE SOLD < (SELECT AVG(SOLD) FROM SOFTWARE);

-- 19. Which is the costliest package developed in PASCAL.
SELECT TITLE FROM SOFTWARE WHERE DCOST=(SELECT MAX(DCOST) AS COSTLIEST_PACKAGE FROM SOFTWARE WHERE DEVELOPIN='PASCAL')

-- 20. How many copies of the package that has the least difference between development and selling cost were sold.
SELECT PNAME,MIN(DCOST-SCOST) FROM software GROUP BY PNAME
-- 21. Which language has been used to develop the package, which has the highest sales amount?

SELECT DEVELOPIN FROM SOFTWARE WHERE SCOST=(SELECT MAX(SCOST) AS HIGH_SALE_AMT FROM software)

 
-- 22. Who Developed the Package that has sold the least number of copies?

SELECT PNAME FROM software WHERE SOLD=(select MIN(SOLD) FROM software)
-- 23. Display the names of the courses whose fees are within 1000 (+ or -) of the Average Fee

SELECT COURSE
FROM studies
WHERE ABS(COURSE_FEE - (SELECT AVG(course_FEE) FROM studies)) <= 1000;


-- 24. Display the name of the Institute and Course, which has below AVG course fee.

SELECT INSTITUTE ,COURSE FROM studies WHERE COURSE_FEE<(SELECT AVG(COURSE_FEE)  FROM studies)

-- 25. Which Institute conducts costliest course.

SELECT INSTITUTE FROM studies WHERE COURSE_FEE=(SELECT MAX(COURSE_FEE) AS COSTLIEST_COURSE FROM studies)
  

-- 26. What is the Costliest course?

SELECT COURSE FROM studies WHERE COURSE_FEE=(SELECT MAX(COURSE_FEE) AS COSTLIEST_COURSE FROM studies)
  