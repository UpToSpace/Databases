--1. ����������� ��������� ������� � ������ COUNT_STUDENTS, ������� ��������� ����������
--��������� �� ����������, ��� �������� �������� ���������� ���� VARCHAR(20) � ������ @faculty.
--������������ ���������� ���������� ������ FACULTY, GROUPS, STUDENT. ���������� ������ �������.

create function COUNT_STUDENTS(@faculty nvarchar(20)) returns int
as begin
declare @rc int = 0;
set @rc = (
SELECT count(IDSTUDENT) from STUDENT join GROUPS
    on STUDENT.IDGROUP = GROUPS.IDGROUP
	join FACULTY
	    on GROUPS.FACULTY = FACULTY.FACULTY
		    where FACULTY.FACULTY = @faculty);
return @rc;
end;

declare @n int = dbo.COUNT_STUDENTS('���');
print '����� ���������: ' + cast(@n as varchar(4));

--������ ��������� � ����� ������� � ������� ��������� ALTER � ���, ����� ������� ��������� ������
--�������� @prof ���� VARCHAR(20), ������������ ������������� ���������. ��� ���������� ����������
--�������� �� ��������� NULL. ���������� ������ ������� � ������� SELECT-��������.

alter function COUNT_STUDENTS(@faculty varchar(20) = null, @prof varchar(20) = null) returns int
as begin
declare @rc int = 0;
set @rc = (
SELECT count(IDSTUDENT) from FACULTY inner join GROUPS
	on FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT
		on GROUPS.IDGROUP = STUDENT.IDGROUP
			where FACULTY.FACULTY = @faculty and GROUPS.PROFESSION = @prof);
return @rc;
end;

declare @n int = dbo.COUNT_STUDENTS('���', '1-48 01 02');
print '����� ���������: ' + cast(@n as varchar(4));


--2. ����������� ��������� ������� � ������ FSUBJECTS, ����������� �������� @p ���� VARCHAR(20),
--�������� �������� ������ ��� ������� (������� SUBJECT.PULPIT). 
--������� ������ ���������� ������ ���� VARCHAR(300) � �������� ��������� � ������. 
--������� � ��������� ��������, ������� ������� �����, ����������� ��������������� ����. 
--����������: ������������ ��������� ����������� ������ �� ������ SELECT-������� � ������� SUBJECT.
 
create function FSUBJECTS(@p varchar(20)) returns varchar(300)
as begin
declare @sb varchar(10), @s varchar(100) = '';
declare sbj cursor local static
    for select distinct SUBJECT from SUBJECT 
	    where PULPIT like @p;
open sbj;
fetch sbj into @sb;
while @@FETCH_STATUS = 0
begin
	set @s = @s + RTRIM(@sb) + ', ';
	fetch sbj into @sb;
end;
return @s
end;


select distinct PULPIT, dbo.FSUBJECTS(PULPIT)[��������] from SUBJECT;


drop function FSUBJECTS

--3. ����������� ��������� ������� FFACPUL, ���������� ������ ������� ������������������ �� ������� ����. 
--������� ��������� ��� ���������, �������� ��� ���������� (������� FACULTY.FACULTY) � ��� ������� (������� PULPIT.PULPIT).
--���������� SELECT-������ c ����� ������� ����������� ����� ��������� FACULTY � PULPIT. 
--���� ��� ��������� ������� ����� NULL, �� ��� ���������� ������ ���� ������ �� ���� �����������. 
--���� ����� ������ �������� (������ ����� NULL), ������� ���������� ������ ���� ������ ��������� ����������. 
--���� ����� ������ �������� (������ ����� NULL), ������� ���������� �������������� �����, ���������� ������,
--��������������� �������� �������.
--���� ������ ��� ���������, ������� ���������� �������������� �����, ���������� ������, ��������������� ��������
--������� �� �������� ����������. 
--���� �� �������� ��������� ���������� ���������� ������������ ������, ������� ���������� ������ �������������� �����. 

 create function FFACPUL(@f varchar(20), @p varchar(20)) returns table
as return
select FACULTY.FACULTY, PULPIT.PULPIT from FACULTY left outer join PULPIT
  on FACULTY.FACULTY = PULPIT.FACULTY
   where FACULTY.FACULTY = ISNULL(@f, FACULTY.FACULTY) and 
    PULPIT.PULPIT = ISNULL(@p, PULPIT.PULPIT);
go

select * from dbo.FFACPUL(null, null);
select * from dbo.FFACPUL('���', null);
select * from dbo.FFACPUL(null, '����');
select * from dbo.FFACPUL('���', '����');
select * from dbo.FFACPUL('vvv', 'bbb');

 drop function FFACPUL

--4. �� ������� ���� ������� ��������, ��������������� ������ ��������� ������� FCTEACHER. ������� ���������
--���� ��������, �������� ��� �������. ������� ���������� ���������� �������������� �� �������� ���������� �������.
--���� �������� ����� NULL, �� ������������ ����� ���������� ��������������. 

create function FCTEACHER(@p varchar(20)) returns int
as begin
declare @rc int = (select count(TEACHER) from TEACHER where PULPIT = ISNULL(@p, PULPIT));
return @rc;
end;

go 
select distinct PULPIT, dbo.FCTEACHER(PULPIT)[����� �������� �� ������ �������] from TEACHER;
select dbo.FCTEACHER(null)[����� ����� ��������];

drop function FCTEACHER

--���������������� ���������������� ��������� ������� FACULTY_REPORT, �������������� ����:
-- �������� ��� ������� ���, ����� ���������� ������, ���������� �����, ���������� ���������
-- � ���������� ����������-���� ����������� ���������� ���������� ���������.

create function COUNT_PULPIT(@faculty nvarchar(10)) returns int
as begin
declare @rc int=0;
set @rc=(select count(*) from PULPIT where PULPIT.FACULTY=@faculty)
return @rc;
end;
go

create function COUNT_GROUPS(@faculty nvarchar(10)) returns int
as begin
declare @rc int=0;
set @rc=(select count(*) from GROUPS where GROUPS.FACULTY=@faculty)
return @rc;
end;
go

create function COUNT_PROFESSION(@faculty varchar(20)) returns int
as begin
declare @rc int = 0;
set @rc = (select count(*) from PROFESSION where PROFESSION.FACULTY = @faculty)
return @rc;
end;
go

create function FACULTY_REPORT(@c int) returns @fr table
([���������] varchar(50),
[���������� ������] int,
[���������� �����]  int, 
[���������� ���������] int,
[���������� ��������������] int) 
as begin
declare cc cursor local static for
select FACULTY from FACULTY where dbo.COUNT_STUDENTS(FACULTY.FACULTY) > @c;
declare @f varchar(30);
open cc;
fetch cc into @f;
while @@fetch_status = 0
begin
insert @fr values(@f,
dbo.COUNT_PULPIT(@f),
dbo.COUNT_GROUPS(@f),
dbo.COUNT_STUDENTS(@f),
dbo.COUNT_PROFESSION(@f));
fetch cc into @f;
end;
close cc;
deallocate cc;
return;
end;
go

select * from dbo.FACULTY_REPORT(0);
go

drop function COUNT_GROUPS;
drop function COUNT_PROFESSION;
drop function COUNT_PULPIT;
drop function COUNT_STUDENTS
drop function FACULTY_REPORT