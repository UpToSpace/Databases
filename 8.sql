--1. ����������� T-SQL-������, � �������: 
--? �������� ���������� ���� char, varchar, datetime, time, int, smallint, tinint, numeric(12, 5); 
--? ������ ��� ���������� ������������������� � ��������� ����������;
--? ��������� ������������ �������� ��������� ���� ���������� � ������� ��������� SET, ����� �� ���� ���������� ��������� ��������, ���������� � ���������� ������� SELECT; 
--? ���� �� ���������� �������� ��� ������������� � �� ����������� �� ��������, ���������� ���������� ��������� ��������� �������� � ������� ��������� SELECT; 
--? �������� ����� �������� ���������� ������� � ������� ��������� SELECT, �������� ������ �������� ���������� ����������� � ������� ��������� PRINT. 
--���������������� ����������.

declare 
@ch char(1) = 'h',
@varch varchar(2) = 'k',
@dt datetime,
@t time,
@i int,
@smalli smallint,
@tini tinyint,
@num numeric(12, 5);

set @dt = GETDATE();
set @t = '15:48:47.24';
select @i = 25, @smalli = 13, @num = 10;
select @i i, @smalli smalli, @num num;
print '@dt=' + cast(@dt as varchar(30));
print '@t=' + cast(@t as varchar(30));


--2. ����������� ������, � ������� ������������ ����� ����������� ���������. ����� ����� ����������� ��������� 200, 
--�� ������� ���������� ���������, ������� ����������� ���������, ���������� ���������, ����������� ������� ������ �������, � ������� ����� ���������.
--����� ����� ����������� ��������� ������ 200, �� ������� ��������� � ������� ����� �����������.

declare @capacity int = (select sum(AUDITORIUM.AUDITORIUM_CAPACITY) from AUDITORIUM), @v1 int, @v2 int, @v3 int;
if @capacity > 200
begin
	select 
	@v1 = (select count(AUDITORIUM) from AUDITORIUM), 
	@v2 = (select avg(AUDITORIUM_CAPACITY) from AUDITORIUM)
	set @v3 = (select count(AUDITORIUM) from AUDITORIUM where AUDITORIUM_CAPACITY < @v2)
	select @capacity [capacity], @v1 [count], @v2 [avg cap], @v3 [count cond], (cast (@v3 as float)/cast (@v1 as float)) * 100 [procent];
end
else select @capacity

--3.	����������� T-SQL-������, ������� ������� �� ������ ���������� ����������: 
--? @@ROWCOUNT (����� ������������ �����); 
--? @@VERSION (������ SQL Server);
--? @@SPID (���������� ��������� ������������� ��������, ����������� �������� �������� �����������); 
--? @@ERROR (��� ��������� ������); 
--? @@SERVERNAME (��� �������); 
--? @@TRANCOUNT (���������� ������� ����������� ����������); 
--? @@FETCH_STATUS (�������� ���������� ���������� ����� ��������������� ������); 
--? @@NESTLEVEL (������� ����������� ������� ���������).
--���������������� ���������.

print 'Rows count: ' + CAST(@@ROWCOUNT as char)
print 'Server version: ' + CAST(@@VERSION as char)
print 'Process ID: ' + cast(@@SPID as char)
print 'Last error ID: ' + cast(@@ERROR as char)
print 'Server Name: ' + cast(@@SERVERNAME as char)
print 'Transaction Level: ' + cast(@@TRANCOUNT as char)
print 'Fetch status: ' + cast(@@FETCH_STATUS as char)
print 'Current operation Level: ' + cast(@@NESTLEVEL as char)

--4. ����������� T-SQL-�������, �����������: 
--? ���������� �������� ���������� z 
 
declare @z numeric(5, 3), @t float, @x float, @sin numeric(5, 3), @4tx numeric(5, 3), @1ex numeric(5, 3)
set @t = 5
set @x = 5	

if (@t > @x) 
	set @z = sin(@t) * sin(@t)
else if (@t < @x)
	set @z = 4 * (@t + @x)
else 
	set @z = 1 - exp(@x - 2)

print 'z = ' + cast(@z as char)

--��� ��������� �������� �������� ������;
--? �������������� ������� ��� �������� � ����������� (��������, �������� ������� ���������� � �������� �. �.);
--? ����� ���������, � ������� ���� �������� � ��������� ������, � ����������� �� ��������;
--? ����� ��� ������, � ������� �������� ��������� ������ ������� ������� �� ����.

declare 
@str varchar(50) = '������� ��� ��������';
select SUBSTRING(@str, 1, CHARINDEX(' ', @str)) + 
SUBSTRING(@str, CHARINDEX(' ', @str) + 1, 1) + '.' + 
SUBSTRING(@str, CHARINDEX(' ', @str, charindex(' ', @str) + 1) + 1, 1) + '.';

declare
@nextmonth int = month(getdate()) + 1;
select NAME, BDAY, YEAR(getdate()) - YEAR(BDAY) - 1 [AGE] from STUDENT 
where month(BDAY) = @nextmonth;

declare @group integer = 6
declare @dow date
set @dow = 
(select top 1 PDATE from PROGRESS
join STUDENT on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
where IDGROUP = @group and SUBJECT = '����')
select datename(WEEKDAY, @dow) [day of week]

--5. ������������������ ����������� IF� ELSE �� ������� ������� ������ ������ ���� ������ �_UNIVER.

declare @pulpitsubject int = (select count(distinct PULPIT) from SUBJECT),
@pulpitpulpit int = (select count(distinct PULPIT) from PULPIT);
if @pulpitpulpit = @pulpitsubject
	print 'number of pulpit in pulpit is equal the number of pulpit in subjects'
else
	print 'number of pulpit in pulpit is NOT equal the number of pulpit in subjects'

--6. ����������� ��������, � ������� � ������� CASE ������������� ������, ���������� ���������� ���������� ���������� ��� ����� ���������.

select PROGRESS.IDSTUDENT [�������],
	case
		when NOTE between 9 and 10 then '��������'
		when NOTE between 6 and 8 then '��������'
		when NOTE between 4 and 5 then '�� �����'
		else '������ ���������'
	end '������'
from PROGRESS
 
--7. ������� ��������� ��������� ������� �� ���� �������� � 10 �����, ��������� �� � ������� ����������. ������������ �������� WHILE.

create table #tabl (tint int, tchar char, tsmallint smallint)
declare @i int = 0;
while @i < 10
begin
insert #tabl values(rand()*20, 'a', rand()*10)
set @i = @i + 1;
end
select * from #tabl

drop table #tabl

--8. ����������� ������, ��������������� ������������� ��������� RETURN. 

declare @i int = 1;
while @i < 20
begin
select @i
return
end

--9. ����������� �������� � ��������, � ������� ������������ ��� ��������� ������ ����� TRY � CATCH. 
--��������� ������� ERROR_NUMBER (��� ��������� ������), ERROR_ES-SAGE (��������� �� ������), ERROR_LINE (��� ��������� ������), 
--ERROR_PROCEDURE (��� ��������� ��� NULL), ERROR_SEVERITY (������� ����������� ������), ERROR_ STATE (����� ������). ���������������� ���������.

begin try
declare @i int
set @i = 'g'
end try

begin catch
print 'ERROR!'
print 'Error number:    ' + cast(ERROR_NUMBER() as varchar)
print 'Error severity:  ' + cast(ERROR_SEVERITY() as varchar)
print 'Error line:      ' + cast(ERROR_LINE() as varchar)
print 'Error state:     ' + cast(ERROR_STATE() as varchar)
print 'Error message:   ' + cast(ERROR_MESSAGE() as varchar)
end catch