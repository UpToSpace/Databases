--1 �� ������ ������ FACULTY, PULPIT � PROFESSION ������������ ������ ������������ ������ 
--(������� PULPIT_NAME), ������� ��������� �� ���������� (������� FACULTY), ��������������
--���������� �� �������������, � ������������ (������� PROFESSION_ NAME) �������� ���������� ����� 
--���������� ��� ����������. 

select PULPIT.PULPIT_NAME from PULPIT, FACULTY
where PULPIT.FACULTY = FACULTY.FACULTY
and PULPIT.FACULTY in 
(select PROFESSION.FACULTY from PROFESSION 
where PROFESSION.PROFESSION_NAME like '%����������%' or PROFESSION.PROFESSION_NAME like '%����������%')

--2 ���������� ������ ������ 1 ����� �������, ����� ��� �� ��������� ��� ������� � ����������� INNER JOIN
--������ FROM �������� �������. ��� ���� ��������� ���������� ������� ������ ���� ����������� ����������
--��������� �������. 

select PULPIT.PULPIT_NAME from PULPIT inner join FACULTY
on PULPIT.FACULTY = FACULTY.FACULTY
where PULPIT.FACULTY in 
(select PROFESSION.FACULTY from PROFESSION 
where PROFESSION.PROFESSION_NAME like '%����������%' or PROFESSION.PROFESSION_NAME like '%����������%')

--3 ���������� ������, ����������� 1 ����� ��� ������������� ����������. 
--����������: ������������ ���������� INNER JOIN ���� ������. 

select distinct PULPIT.PULPIT_NAME from PULPIT 
inner join FACULTY
on PULPIT.FACULTY = FACULTY.FACULTY
inner join PROFESSION
on PROFESSION.FACULTY = PULPIT.FACULTY
where PROFESSION.PROFESSION_NAME like '%����������%' or PROFESSION.PROFESSION_NAME like '%����������%'

--4 �� ������ ������� AUDITORIUM ������������ ������ ��������� ����� ������� ������������ (������� AUDITORIUM_CAPACITY)
--��� ������� ���� ��������� (AUDITORIUM_TYPE). ��� ���� ��������� ������� ������������� � ������� �������� �����������. 
--����������: ������������ ������������� ��������� c �������� TOP � ORDER BY. 

select AUDITORIUM from AUDITORIUM a
where AUDITORIUM_CAPACITY = 
(select top(1) AUDITORIUM_CAPACITY from AUDITORIUM aa
where a.AUDITORIUM_TYPE = aa.AUDITORIUM_TYPE order by AUDITORIUM_CAPACITY desc)

--5 �� ������ ������ FACULTY � PULPIT ������������ ������ ������������ �����������
--(������� FACULTY_NAME) �� ������� ��� �� ����� ������� (������� PULPIT). 
--����������: ������������ �������� EXISTS � ��������������� ���������. 

Select FACULTY.FACULTY_NAME
from FACULTY, PULPIT
where not exists(select PULPIT.PULPIT from PULPIT where FACULTY.FACULTY = PULPIT.FACULTY)

--6 �� ������ ������� PROGRESS ������������ ������, ���������� ������� �������� ������ (������� NOTE)
--�� �����������, ������� ��������� ����: ����, �� � ����.
--����������: ������������ ��� ����������������� ���������� � ������ SELECT; 
--� ����������� ��������� ���������� ������� AVG. 

select
(select AVG(PROGRESS.NOTE) from PROGRESS where PROGRESS.SUBJECT = '����')[������� �� ����],
(select AVG(PROGRESS.NOTE) from PROGRESS where PROGRESS.SUBJECT = '��') [������� �� ��],
(select AVG(PROGRESS.NOTE) from PROGRESS where PROGRESS.SUBJECT = '����') [������� �� ����]

--7 ����������� SELECT-������, ��������������� ������� ���������� ALL ��������� � �����������.

SELECT * FROM AUDITORIUM
	WHERE AUDITORIUM_CAPACITY >= ALL(SELECT AUDITORIUM_CAPACITY FROM AUDITORIUM
											WHERE AUDITORIUM_TYPE LIKE '%��%');

--8 ����������� SELECT-������, ��������������� ������� ���������� ANY ��������� � �����������.

SELECT * FROM AUDITORIUM
	WHERE AUDITORIUM_CAPACITY >= ANY(SELECT AUDITORIUM_CAPACITY FROM AUDITORIUM
											WHERE AUDITORIUM_TYPE LIKE '%��%');

--10 ����� � ������� STUDENT ���������, � ������� ���� �������� � ���� ����. ��������� �������.
select  a.Name, a.BDAY from STUDENT a
where BDAY in ( select BDAY from STUDENT where a.NAME != STUDENT.NAME)
order by BDAY
