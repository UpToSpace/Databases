--1. �� ������ ������� AUDITORIUM ����������� SELECT-������, ����������� ������������, ����������� � ������� ����������� ���������,
--��������� ����������� ���� ��������� � ����� ���������� ���������. 

select max(AUDITORIUM.AUDITORIUM_CAPACITY) [max capacity],
min(AUDITORIUM.AUDITORIUM_CAPACITY) [min capacity],
avg(AUDITORIUM.AUDITORIUM_CAPACITY) [average],
sum(AUDITORIUM.AUDITORIUM_CAPACITY) [sum],
count(AUDITORIUM.AUDITORIUM) [count]
from AUDITORIUM

--2. �� ������ ������ AUDITORIUM � AUDITORIUM_TYPE ����������� ������, ����������� ��� ������� ���� ��������� ������������, �����������,
--������� ����������� ���������, ��������� ����������� ���� ��������� � ����� ���������� ��������� ������� ����. 
--�������������� ����� ������ ��������� ������� � ������������� ���� ��������� (������� AUDITORIUM_TYPE.AU-DITORIUM_TYPENAME)
--� ������� � ������������ ����������. ������������ ���������� ���������� ������, ������ GROUP BY � ���������� �������. 

select
AUDITORIUM_TYPE.AUDITORIUM_TYPENAME,
max(AUDITORIUM.AUDITORIUM_CAPACITY) [max capacity],
min(AUDITORIUM.AUDITORIUM_CAPACITY) [min capacity],
avg(AUDITORIUM.AUDITORIUM_CAPACITY) [average],
sum(AUDITORIUM.AUDITORIUM_CAPACITY) [sum],
count(AUDITORIUM.AUDITORIUM) [count]
from AUDITORIUM inner join AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
group by AUDITORIUM_TYPE.AUDITORIUM_TYPENAME

--3. ����������� ������ �� ������ ������� PROGRESS, ������� �������� ���������� ��������������� ������ � �������� ���������.
--��� ���� ������, ��� ���������� ����� ������ �������������� � �������, �������� �������� ������;
--����� �������� � ������� ���������� ������ ���� ����� ���������� ����� � ������� PROGRESS. 
--������������ ��������� � ������ FROM, � ���������� ��������� GROUP BY, ���������� ����������� �� ������� �������.
--� ������ GROUP BY, � SELECT-������ ���������� � � ORDER BY �������� ������� ��������� CASE. 

SELECT * FROM(
SELECT CASE 
		WHEN NOTE = 10 then '10'
		WHEN NOTE between 8 and 9 then '8-9'
		WHEN NOTE between 6 and 7 then '6-7'
		WHEN NOTE between 4 and 5 then '4-5'
	END [������],
	COUNT(*) as [����������]
	FROM PROGRESS GROUP BY CASE
		WHEN NOTE = 10 then '10'
		WHEN NOTE between 8 and 9 then '8-9'
		WHEN NOTE between 6 and 7 then '6-7'
		WHEN NOTE between 4 and 5 then '4-5'
	END) AS T
ORDER BY Case [������]
	WHEN '10' then 4
	WHEN '8-9' then 3
	WHEN '6-7' then 2
	WHEN '4-5' then 1
	END;

--4. ����������� SELECT-������� �� ������ ������ FACULTY, GROUPS, STUDENT � PROGRESS, ������� �������� ������� ��������������� ������ ��� �������
--����� ������ �������������. ������ ������������� � ������� �������� ������� ������.
--��� ���� ������� ������, ��� ������� ������ ������ �������������� � ��������� �� ���� ������ ����� �������. 
--������������ ���������� ���������� ������, ���������� ������� AVG � ���������� ������� CAST � ROUND.

select FACULTY.FACULTY_NAME, GROUPS.PROFESSION, STUDENT.IDGROUP, round(avg(cast (PROGRESS.NOTE as float(4))), 2) as [������� ������]
from FACULTY inner join GROUPS on FACULTY.FACULTY = GROUPS.FACULTY inner join STUDENT on 
STUDENT.IDGROUP = GROUPS.IDGROUP inner join PROGRESS on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
group by FACULTY.FACULTY_NAME, GROUPS.PROFESSION, STUDENT.IDGROUP

--���������� SELECT-������, ������������� � ������� 4 ���, ����� � ������� �������� �������� ������ �������������� 
--������ ������ �� ����������� � ������ �� � ����. ������������ WHERE.

select FACULTY.FACULTY_NAME, GROUPS.PROFESSION, STUDENT.IDGROUP, round(avg(cast (PROGRESS.NOTE as float(4))), 2) as [������� ������]
from FACULTY inner join GROUPS on FACULTY.FACULTY = GROUPS.FACULTY inner join STUDENT on 
STUDENT.IDGROUP = GROUPS.IDGROUP inner join PROGRESS on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
where (progress.subject = '��' or progress.subject = '����')
group by FACULTY.FACULTY_NAME, GROUPS.PROFESSION, STUDENT.IDGROUP

--5. �� ������ ������ FACULTY, GROUPS, STUDENT � PROGRESS ����������� SELECT-������,
--� ������� ��������� �������������, ���������� � ������� ������ ��� ����� ��������� �� ���������� ���. ������������ ����������� �� ����� FACULTY, PROFESSION, SUBJECT.
-- �������� � ������ ����������� ROLLUP � ���������������� ���������. 

select FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT, round(avg(cast (PROGRESS.NOTE as float(4))), 2) as [������� ������]
from GROUPS, STUDENT, FACULTY, PROGRESS
where (FACULTY.FACULTY like '���')
group by rollup(FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT)

--6. ��������� �������� SELECT-������ �.5 � �������������� CUBE-�����������. ���������������� ���������.

select FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT, round(avg(cast (PROGRESS.NOTE as float(4))), 2) as [������� ������]
from GROUPS, STUDENT, FACULTY, PROGRESS
where (FACULTY.FACULTY like '���')
group by cube(FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT)

--7. �� ������ ������ GROUPS, STUDENT � PROGRESS ����������� SELECT-������, � ������� ������������ ���������� ����� ���������.
--� ������� ������ ���������� �������������, ����������, ������� ������ ��������� �� ���������� ���.
--�������� ����������� ������, � ������� ������������ ���������� ����� ��������� �� ���������� ����.
--���������� ���������� ���� �������� � �������������� ���������� UNION � UNION ALL. ��������� ����������. 

SELECT 
	FACULTY.FACULTY,
	GROUPS.PROFESSION,
	round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [������� ������]
FROM GROUPS 
	inner join FACULTY 
ON FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT
ON STUDENT.IDGROUP = GROUPS.IDGROUP
	inner join PROGRESS
ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY in ('���')
GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION
	UNION
SELECT 
	FACULTY.FACULTY,
	GROUPS.PROFESSION,
	round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [������� ������]
FROM GROUPS 
	inner join FACULTY 
ON FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT
ON STUDENT.IDGROUP = GROUPS.IDGROUP
	inner join PROGRESS
ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY in ('����')
GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION


SELECT 
	FACULTY.FACULTY,
	GROUPS.PROFESSION,
	round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [������� ������]
FROM GROUPS 
	inner join FACULTY 
ON FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT
ON STUDENT.IDGROUP = GROUPS.IDGROUP
	inner join PROGRESS
ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY in ('���')
GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION
	UNION ALL
SELECT 
	FACULTY.FACULTY,
	GROUPS.PROFESSION,
	round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [������� ������]
FROM GROUPS 
	inner join FACULTY 
ON FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT
ON STUDENT.IDGROUP = GROUPS.IDGROUP
	inner join PROGRESS
ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY in ('����')
GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION

--8. �������� ����������� ���� �������� �����, ��������� � ���������� ���������� �������� ������ 8. ��������� ���������.
--������������ �������� INTERSECT.

SELECT 
	FACULTY.FACULTY,
	GROUPS.PROFESSION,
	round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [������� ������]
FROM GROUPS 
	inner join FACULTY 
ON FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT
ON STUDENT.IDGROUP = GROUPS.IDGROUP
	inner join PROGRESS
ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY in ('���')
GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION
	INTERSECT
SELECT 
	FACULTY.FACULTY,
	GROUPS.PROFESSION,
	round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [������� ������]
FROM GROUPS 
	inner join FACULTY 
ON FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT
ON STUDENT.IDGROUP = GROUPS.IDGROUP
	inner join PROGRESS
ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY in ('����')
GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION

--9. �������� ������� ����� ���������� �����, ��������� � ���������� �������� ������ 8.
-- ��������� ���������. 
--������������ �������� EXCEPT.

SELECT 
	FACULTY.FACULTY,
	GROUPS.PROFESSION,
	round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [������� ������]
FROM GROUPS 
	inner join FACULTY 
ON FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT
ON STUDENT.IDGROUP = GROUPS.IDGROUP
	inner join PROGRESS
ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY in ('���')
GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION
	EXCEPT
SELECT 
	FACULTY.FACULTY,
	GROUPS.PROFESSION,
	round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [������� ������]
FROM GROUPS 
	inner join FACULTY 
ON FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT
ON STUDENT.IDGROUP = GROUPS.IDGROUP
	inner join PROGRESS
ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY in ('����')
GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION

--10. �� ������ ������� PROGRESS ���������� ��� ������ ���������� ���������� ���������, ���������� ������ 8 � 9. 
--������������ �����������, ������ HAVING, ����������. 

SELECT PROGRESS.SUBJECT,PROGRESS.NOTE, (
SELECT COUNT(P.IDSTUDENT) FROM PROGRESS P
WHERE P.SUBJECT = PROGRESS.SUBJECT AND P.NOTE = PROGRESS.NOTE
)
FROM PROGRESS
GROUP BY PROGRESS.SUBJECT, PROGRESS.NOTE HAVING PROGRESS.NOTE IN (8, 9)
