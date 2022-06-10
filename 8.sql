--1. Разработать T-SQL-скрипт, в котором: 
--? объявить переменные типа char, varchar, datetime, time, int, smallint, tinint, numeric(12, 5); 
--? первые две переменные проинициализировать в операторе объявления;
--? присвоить произвольные значения следующим двум переменным с помощью оператора SET, одной из этих переменных присвоить значение, полученное в результате запроса SELECT; 
--? одну из переменных оставить без инициализации и не присваивать ей значения, оставшимся переменным присвоить некоторые значения с помощью оператора SELECT; 
--? значения одной половины переменных вывести с помощью оператора SELECT, значения другой половины переменных распечатать с помощью оператора PRINT. 
--Проанализировать результаты.

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


--2. Разработать скрипт, в котором определяется общая вместимость аудиторий. Когда общая вместимость превышает 200, 
--то вывести количество аудиторий, среднюю вместимость аудиторий, количество аудиторий, вместимость которых меньше средней, и процент таких аудиторий.
--Когда общая вместимость аудиторий меньше 200, то вывести сообщение о размере общей вместимости.

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

--3.	Разработать T-SQL-скрипт, который выводит на печать глобальные переменные: 
--? @@ROWCOUNT (число обработанных строк); 
--? @@VERSION (версия SQL Server);
--? @@SPID (возвращает системный идентификатор процесса, назначенный сервером текущему подключению); 
--? @@ERROR (код последней ошибки); 
--? @@SERVERNAME (имя сервера); 
--? @@TRANCOUNT (возвращает уровень вложенности транзакции); 
--? @@FETCH_STATUS (проверка результата считывания строк результирующего набора); 
--? @@NESTLEVEL (уровень вложенности текущей процедуры).
--Проанализировать результат.

print 'Rows count: ' + CAST(@@ROWCOUNT as char)
print 'Server version: ' + CAST(@@VERSION as char)
print 'Process ID: ' + cast(@@SPID as char)
print 'Last error ID: ' + cast(@@ERROR as char)
print 'Server Name: ' + cast(@@SERVERNAME as char)
print 'Transaction Level: ' + cast(@@TRANCOUNT as char)
print 'Fetch status: ' + cast(@@FETCH_STATUS as char)
print 'Current operation Level: ' + cast(@@NESTLEVEL as char)

--4. Разработать T-SQL-скрипты, выполняющие: 
--? вычисление значений переменной z 
 
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

--для различных значений исходных данных;
--? преобразование полного ФИО студента в сокращенное (например, Макейчик Татьяна Леонидовна в Макейчик Т. Л.);
--? поиск студентов, у которых день рождения в следующем месяце, и определение их возраста;
--? поиск дня недели, в который студенты некоторой группы сдавали экзамен по СУБД.

declare 
@str varchar(50) = 'Фамилия Имя Отчество';
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
where IDGROUP = @group and SUBJECT = 'СУБД')
select datename(WEEKDAY, @dow) [day of week]

--5. Продемонстрировать конструкцию IF… ELSE на примере анализа данных таблиц базы данных Х_UNIVER.

declare @pulpitsubject int = (select count(distinct PULPIT) from SUBJECT),
@pulpitpulpit int = (select count(distinct PULPIT) from PULPIT);
if @pulpitpulpit = @pulpitsubject
	print 'number of pulpit in pulpit is equal the number of pulpit in subjects'
else
	print 'number of pulpit in pulpit is NOT equal the number of pulpit in subjects'

--6. Разработать сценарий, в котором с помощью CASE анализируются оценки, полученные студентами некоторого факультета при сдаче экзаменов.

select PROGRESS.IDSTUDENT [студент],
	case
		when NOTE between 9 and 10 then 'отличник'
		when NOTE between 6 and 8 then 'хорошист'
		when NOTE between 4 and 5 then 'не очень'
		else 'меньше проходной'
	end 'статус'
from PROGRESS
 
--7. Создать временную локальную таблицу из трех столбцов и 10 строк, заполнить ее и вывести содержимое. Использовать оператор WHILE.

create table #tabl (tint int, tchar char, tsmallint smallint)
declare @i int = 0;
while @i < 10
begin
insert #tabl values(rand()*20, 'a', rand()*10)
set @i = @i + 1;
end
select * from #tabl

drop table #tabl

--8. Разработать скрипт, демонстрирующий использование оператора RETURN. 

declare @i int = 1;
while @i < 20
begin
select @i
return
end

--9. Разработать сценарий с ошибками, в котором используются для обработки ошибок блоки TRY и CATCH. 
--Применить функции ERROR_NUMBER (код последней ошибки), ERROR_ES-SAGE (сообщение об ошибке), ERROR_LINE (код последней ошибки), 
--ERROR_PROCEDURE (имя процедуры или NULL), ERROR_SEVERITY (уровень серьезности ошибки), ERROR_ STATE (метка ошибки). Проанализировать результат.

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