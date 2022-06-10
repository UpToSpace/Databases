--1. ����������� ������������� � ������ �������������. ������������� ������ ���� ��������� �� ������ SELECT-������� � 
--������� TEACHER � ��������� ��������� �������: ��� (TEACHER), ��� ������������� (TEACHER_NAME), ��� (GENDER), ��� ������� (PULPIT). 

create view [�������������]
as select TEACHER.TEACHER, TEACHER.TEACHER_NAME, TEACHER.GENDER, TEACHER.PULPIT
from TEACHER
drop view [�������������]

--2. ����������� � ������� ������������� � ������ ���������� ������. ������������� ������ ���� ��������� �� ������
--SELECT-������� � �������� FACULTY � PULPIT.������������� ������ ��������� ��������� �������: ���������
--(FACULTY.FACULTY_ NAME), ���������� ������ (����������� �� ������ ����� ������� PULPIT). 
 
create view [���������� ������]
as select FACULTY.FACULTY_NAME, count(PULPIT.PULPIT) [pulpit count] from FACULTY inner join PULPIT on 
FACULTY.FACULTY = PULPIT.FACULTY group by FACULTY.FACULTY_NAME
drop view [���������� ������]

--3. ����������� � ������� ������������� � ������ ���������. ������������� ������ ���� ��������� �� ������
--������� AUDITORIUM � ��������� �������: ��� (AUDITORIUM), ������������ ��������� (AUDITORIUM_NAME). 
--������������� ������ ���������� ������ ���������� ��������� (� ������� AUDITORIUM_TYPE ������,
--������������ � ������� ��) � ��������� ���������� ��������� INSERT, UPDATE � DELETE.

create view [���������]
as select AUDITORIUM.AUDITORIUM, AUDITORIUM.AUDITORIUM_NAME from AUDITORIUM
where AUDITORIUM.AUDITORIUM_TYPE like '��%'
drop view [���������]

--4. ����������� � ������� ������������� � ������ ����������_���������. 
--������������� ������ ���� ��������� �� ������ SELECT-������� � ������� AUDITORIUM � ��������� ��������� �������:
--��� (AUDITORIUM), ������������ ��������� (AUDITORIUM_NAME). 
--������������� ������ ���������� ������ ���������� ��������� (� ������� AUDITORIUM_TYPE ������, ������������ � �������� ��). 
--���������� INSERT � UPDATE �����������, �� � ������ �����������, ����������� ������ WITH CHECK OPTION. 

create view [����������_���������]
as select AUDITORIUM, AUDITORIUM_NAME from AUDITORIUM
where AUDITORIUM.AUDITORIUM_TYPE like '��%'
with check option

drop view [����������_���������]


--5. ����������� ������������� � ������ ����������. ������������� ������ ���� ��������� �� ������ SELECT-�������
--� ������� SUBJECT, ���������� ��� ���������� � ���������� ������� � ��������� ��������� �������: ��� (SUBJECT), ������������ ���������� (SUBJECT_NAME) � ��� ������� (PULPIT). ������������ TOP � ORDER BY.

create view [����������]
as select top 100 SUBJECT, SUBJECT_NAME, PULPIT from SUBJECT
order by SUBJECT_NAME 

drop view [����������]

--6. �������� ������������� ����������_������, ��������� � ������� 2 ���, ����� ��� ���� ��������� � �������
--��������. ������������������ �������� ������������� ������������� � ������� ��������. ����������: ������������ ����� SCHEMABINDING. 

alter view [���������� ������] with schemabinding
as select FACULTY.FACULTY_NAME [faculty], count(PULPIT.PULPIT) [pulpit count] from dbo.FACULTY inner join dbo.PULPIT on 
FACULTY.FACULTY = PULPIT.FACULTY group by FACULTY.FACULTY_NAME
drop view [���������� ������]
