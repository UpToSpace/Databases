--1. Разработать скалярную функцию с именем COUNT_STUDENTS, которая вычисляет количество
--студентов на факультете, код которого задается параметром типа VARCHAR(20) с именем @faculty.
--Использовать внутреннее соединение таблиц FACULTY, GROUPS, STUDENT. Опробовать работу функции.

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

declare @n int = dbo.COUNT_STUDENTS('ТОВ');
print 'Колво студентов: ' + cast(@n as varchar(4));

--Внести изменения в текст функции с помощью оператора ALTER с тем, чтобы функция принимала второй
--параметр @prof типа VARCHAR(20), обозначающий специальность студентов. Для параметров определить
--значения по умолчанию NULL. Опробовать работу функции с помощью SELECT-запросов.

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

declare @n int = dbo.COUNT_STUDENTS('ТОВ', '1-48 01 02');
print 'Колво студентов: ' + cast(@n as varchar(4));


--2. Разработать скалярную функцию с именем FSUBJECTS, принимающую параметр @p типа VARCHAR(20),
--значение которого задает код кафедры (столбец SUBJECT.PULPIT). 
--Функция должна возвращать строку типа VARCHAR(300) с перечнем дисциплин в отчете. 
--Создать и выполнить сценарий, который создает отчет, аналогичный представленному ниже. 
--Примечание: использовать локальный статический курсор на основе SELECT-запроса к таблице SUBJECT.
 
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


select distinct PULPIT, dbo.FSUBJECTS(PULPIT)[Предметы] from SUBJECT;


drop function FSUBJECTS

--3. Разработать табличную функцию FFACPUL, результаты работы которой продемонстрированы на рисунке ниже. 
--Функция принимает два параметра, задающих код факультета (столбец FACULTY.FACULTY) и код кафедры (столбец PULPIT.PULPIT).
--Использует SELECT-запрос c левым внешним соединением между таблицами FACULTY и PULPIT. 
--Если оба параметра функции равны NULL, то она возвращает список всех кафедр на всех факультетах. 
--Если задан первый параметр (второй равен NULL), функция возвращает список всех кафедр заданного факультета. 
--Если задан второй параметр (первый равен NULL), функция возвращает результирующий набор, содержащий строку,
--соответствующую заданной кафедре.
--Если заданы два параметра, функция возвращает результирующий набор, содержащий строку, соответствующую заданной
--кафедре на заданном факультете. 
--Если по заданным значениям параметров невозможно сформировать строки, функция возвращает пустой результирующий набор. 

 create function FFACPUL(@f varchar(20), @p varchar(20)) returns table
as return
select FACULTY.FACULTY, PULPIT.PULPIT from FACULTY left outer join PULPIT
  on FACULTY.FACULTY = PULPIT.FACULTY
   where FACULTY.FACULTY = ISNULL(@f, FACULTY.FACULTY) and 
    PULPIT.PULPIT = ISNULL(@p, PULPIT.PULPIT);
go

select * from dbo.FFACPUL(null, null);
select * from dbo.FFACPUL('ИЭФ', null);
select * from dbo.FFACPUL(null, 'МиЭП');
select * from dbo.FFACPUL('ИЭФ', 'МиЭП');
select * from dbo.FFACPUL('vvv', 'bbb');

 drop function FFACPUL

--4. На рисунке ниже показан сценарий, демонстрирующий работу скалярной функции FCTEACHER. Функция принимает
--один параметр, задающий код кафедры. Функция возвращает количество преподавателей на заданной параметром кафедре.
--Если параметр равен NULL, то возвращается общее количество преподавателей. 

create function FCTEACHER(@p varchar(20)) returns int
as begin
declare @rc int = (select count(TEACHER) from TEACHER where PULPIT = ISNULL(@p, PULPIT));
return @rc;
end;

go 
select distinct PULPIT, dbo.FCTEACHER(PULPIT)[Колво преподов на каждой кафедре] from TEACHER;
select dbo.FCTEACHER(null)[Общее колво преподов];

drop function FCTEACHER

--Проанализировать многооператорную табличную функцию FACULTY_REPORT, представленную ниже:
-- Изменить эту функцию так, чтобы количество кафедр, количество групп, количество студентов
-- и количество специально-стей вычислялось отдельными скалярными функциями.

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
([Факультет] varchar(50),
[Количество кафедр] int,
[Количество групп]  int, 
[Количество студентов] int,
[Количество специальностей] int) 
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