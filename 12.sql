-- 1. Разработать хранимую процедуру без параметров с именем PSUBJECT. 
-- Процедура формирует ре-зультирующий набор на основе таблицы SUBJECT
-- К точке вызова процедура должна возвращать ко-личество строк, выведенных в результирующий набор.

create procedure PSUBJECT as
begin 
declare @n int = (select count(*) from SUBJECT);
select * from SUBJECT;
return @n;
end

declare @n int;
exec @n = PSUBJECT;
print 'col-vo ' + cast(@n as varchar(3));


--2. Найти процедуру PSUBJECT с помощью обозревателя объектов (Object Explorer) SSMS и через контекстное
--меню создать сценарий на изменение процедуры оператором ALTER.
--Изменить процедуру PSUBJECT, созданную в задании 1, таким образом, чтобы она принимала два параметра
--с именами @p и @c. Параметр @p является входным, имеет тип VARCHAR(20) и значение по умолчанию NULL.
--Параметр @с является выходным, имеет тип INT.
--Процедура PSUBJECT должна формировать результирующий набор, аналогичный набору, представленному на рисунке выше,
--но при этом содержать строки, соответствующие коду кафедры, заданному параметром @p.
--Кроме того, процедура должна формировать значение выходного параметра @с, равное количеству строк в результирующем наборе,
--а также возвращать значение к точке вызова, равное общему количеству дисциплин (количеству строк в таблице SUBJECT). 

alter procedure PSUBJECT @p varchar(20) = NULL, @c int output
as begin
select * from SUBJECT where SUBJECT.SUBJECT = @p;
set @c = @@ROWCOUNT;
declare @k int = (select count(*) from SUBJECT);
return @k;
end

declare @n int, @a int;
exec @n = PSUBJECT 'ООП', @a output ;
print cast(@a as varchar(4))

--3. Создать временную локальную таблицу с именем #SUBJECT. Наименование и тип столбцов таблицы должны соответствовать
--столбцам результирующего набора процедуры PSUBJECT, разработанной в задании 2. 
--Изменить процедуру PSUBJECT таким образом, чтобы она не содержала выходного параметра.
--Применив конструкцию INSERT… EXECUTE с модифицированной процедурой PSUBJECT, добавить строки в таблицу #SUBJECT. 

ALTER procedure PSUBJECT @p varchar(20)
as begin
	SELECT * from SUBJECT where SUBJECT = @p;
end;


CREATE table #SUBJECTs
(
	SUBJECT varchar(20),
	SUBJECT_NAME varchar(100),
	PULPIT varchar(20)
);
INSERT #SUBJECTs EXEC PSUBJECT @p = 'ООП';
INSERT #SUBJECTs EXEC PSUBJECT @p = 'ОАиП';
SELECT * from #SUBJECTs;
go

drop table #SUBJECTs
drop procedure PSUBJECT

--4. Разработать процедуру с именем PAUDITORIUM_INSERT. Процедура принимает четыре входных параметра: @a, @n, @c и @t. 
--Параметр @a имеет тип CHAR(20), параметр @n имеет тип VARCHAR(50), параметр @c имеет тип INT и значение по умолчанию 0,
--параметр @t имеет тип CHAR(10).
--Процедура добавляет строку в таблицу AUDITORIUM. Значения столбцов AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY и AUDITORIUM_TYPE
--добавляемой строки задаются соответственно параметрами @a, @n, @c и @t.
--Процедура PAUDITORIUM_INSERT должна применять механизм TRY/CATCH для обработки ошибок. В случае возникновения ошибки, процедура должна
--формировать сообщение, содержащее код ошибки, уровень серьезности и текст сообщения в стандартный выходной поток. 
--Процедура должна возвращать к точке вызова значение -1 в том случае, если произошла ошибка и 1, если выполнение успешно. 
--Опробовать работу процедуры с различными значениями исходных данных, которые вставляются в таблицу.

CREATE procedure PAUDITORIUM_INSERT
		@a char(20),
		@n varchar(50),
		@c int = 0,
		@t char(10)
as begin 
begin try
	INSERT into AUDITORIUM(AUDITORIUM, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY, AUDITORIUM_NAME)
		values(@a, @n, @c, @t);
	return 1;
end try
begin catch
	print 'num: ' + cast(error_number() as varchar(6));
	print 'message: ' + error_message();
	print 'severity: ' + cast(error_severity() as varchar(6));
	print 'state: ' + cast(error_state() as varchar(8));
	print 'error line: ' + cast(error_line() as varchar(8));
	if error_procedure() is not null   
	print 'in what proc: ' + error_procedure();
	return -1;
end catch;
end;


DECLARE @rc int;  
EXEC @rc = PAUDITORIUM_INSERT @a = '144-1', @n = 'ЛК', @c = 30, @t = '144-1'; 
print 'STATUS: ' + cast(@rc as varchar(3));

select * from AUDITORIUM where AUDITORIUM.AUDITORIUM = '144-1'

delete AUDITORIUM where AUDITORIUM='144-1';


--5. Разработать процедуру с именем SUBJECT_REPORT, формирующую в стандартный выходной поток отчет со списком дисциплин на конкретной
--кафедре. В отчет должны быть выведены краткие названия (поле SUBJECT) из таблицы SUBJECT в одну строку через запятую (использовать
--встроенную функцию RTRIM). Процедура имеет входной параметр с именем @p типа CHAR(10), который предназначен для указания кода кафедры.
--В том случае, если по заданному значению @p невозможно определить код кафедры, процедура должна генерировать ошибку с сообщением ошибка в параметрах. 

CREATE procedure SUBJECT_REPORT @p char(10) 
as begin
DECLARE @rc int = 0;
begin try
	DECLARE @sb char(10), @r varchar(100) = '';
	DECLARE sbj CURSOR local for 
		SELECT SUBJECT.SUBJECT from SUBJECT where SUBJECT.PULPIT = @p;
	if not exists(SELECT SUBJECT from SUBJECT where PULPIT = @p)
		raiserror('ОШИБКА', 11, 1);
	else 
	OPEN sbj;
	fetch sbj into @sb;
	print 'Subjects: ';
	while @@fetch_status = 0
	begin
		set @r = rtrim(@sb) + ', ' + @r;  
		set @rc = @rc + 1;
		fetch sbj into @sb;
	end
	print @r;
	CLOSE sbj;
	return @rc;
end try
begin catch
	print 'Список' 
	if error_procedure() is not null   
	print 'Ошибка в процедуре: ' + error_procedure();
	print 'line: ' + cast(error_line() as varchar(8)); 
	return @rc;
end catch;
end;


DECLARE @k2 int;  
EXEC @k2 = SUBJECT_REPORT @p ='ИСиТ';  
print 'Количество: ' + cast(@k2 as varchar(3));


drop procedure SUBJECT_REPORT;

--6. Разработать процедуру с именем PAUDITORIUM_INSERTX. Процедура принимает пять входных параметров: @a, @n, @c, @t и @tn. 
--Параметры @a, @n, @c, @t аналогичны параметрам процедуры PAUDITORIUM_INSERT. Дополнительный параметр @tn является входным,
--имеет тип VARCHAR(50), предназначен для ввода значения в столбец AUDITORIUM_TYPE.AUDITORIUM_TYPENAME.
--Процедура добавляет две строки. Первая строка добавляется в таблицу AUDITORIUM_TYPE. Значения столбцов AUDITORIUM_TYPE
--и AUDITORIUM_ TYPENAME добавляемой строки задаются соответственно параметрами @t и @tn. Вторая строка добавляется путем вызова
--процедуры PAUDITORIUM_INSERT.

--Добавление строки в таблицу AUDITORIUM_TYPE и вызов процедуры PAUDITORIUM_INSERT должны выполняться в рамках одной явной
--транзакции с уровнем изолированности SERIALIZABLE. 
--В процедуре должна быть предусмотрена обработка ошибок с помощью механизма TRY/CATCH. Все ошибки должны быть
--обработаны с выдачей соответствующего сообщения в стандартный выходной поток. 
--Процедура PAUDITORIUM_INSERTX должна возвращать к точке вызова значение -1 в том случае, если произошла ошибка и
--1, если выполнения процедуры завершилось успешно. 

CREATE procedure PAUDITORIUM_INSERTX
		@a char(20),
		@n varchar(50),
		@c int = 0,
		@t char(10),
		@tn varchar(50)	
as begin
DECLARE @rc int = 1;
begin try
	set transaction isolation level serializable;          
	begin tran
	INSERT into AUDITORIUM_TYPE(AUDITORIUM_TYPE, AUDITORIUM_TYPENAME)
				values(@n, @tn);
	EXEC @rc = PAUDITORIUM_INSERT @a, @n, @c, @t;
	commit tran;
	return @rc;
end try
begin catch
	print 'num: ' + cast(error_number() as varchar(6));
	print 'message: ' + error_message();
	print 'severity: ' + cast(error_severity() as varchar(6));
	print 'state: ' + cast(error_state() as varchar(8));
	print 'error line: ' + cast(error_line() as varchar(8));
	if error_procedure() is not null   
	print 'in what proc: ' + error_procedure();
	if @@trancount > 0 rollback tran ; 
	return -1;
end catch;
end;


DECLARE @k3 int;  
EXEC @k3 = PAUDITORIUM_INSERTX '122-4', @n = 'ЛКиК', @c = 50, @t = '122-4', @tn = 'Что.то'; 
print 'Код процедуры: ' + cast(@k3 as varchar(3));

select * from AUDITORIUM where AUDITORIUM = '122-4';
select * from AUDITORIUM_TYPE where AUDITORIUM_TYPE='ЛКиК';

delete AUDITORIUM where AUDITORIUM='122-4';  
delete AUDITORIUM_TYPE where AUDITORIUM_TYPE='ЛКиК';


drop procedure PAUDITORIUM_INSERTX;



--все пары в опред аудит 

use UNIVER
create table TIMETABLE(
DAY_OF_WEEK char(2) check (DAY_OF_WEEK in('пн', 'вт', 'ср', 'чт', 'пт', 'сб')),
LESSON int check(LESSON between 1 and 4),
TEACHER char(10) constraint TIMETABLE_TEACHER_FK  foreign key references TEACHER(TEACHER),
AUDITORIUM char(20) constraint TIMETABLE_AUDITORIUM_FK foreign key references AUDITORIUM(AUDITORIUM),
SUBJECT char(10) constraint TIMETABLE_SUBJECT_FK  foreign key references SUBJECT(SUBJECT),
IDGROUP int constraint TIMETABLE_GROUP_FK  foreign key references GROUPS(IDGROUP)
)
insert into TIMETABLE values
('пн', 1, 'СМЛВ', '313-1', 'СУБД', 15),
('пн', 2, 'СМЛВ', '313-1', 'ОАиП', 4),
('вт', 3, 'СМЛВ', '313-1', 'ОАиП', 11),
('вт', 1, 'МРЗ', '324-1', 'СУБД', 6),
('ср', 3, 'УРБ', '324-1', 'ПИС', 4),
('ср', 1, 'УРБ', '206-1', 'ПИС', 10),
('чт', 4, 'СМЛВ', '206-1', 'ОАиП', 3),
('чт', 1, 'БРКВЧ', '301-1', 'СУБД', 7),
('пт', 4, 'БРКВЧ', '301-1', 'ОАиП', 7),
('пт', 2, 'БРКВЧ', '413-1', 'СУБД', 8),
('сб', 2, 'ДТК', '423-1', 'СУБД', 7)


create function un (@p varchar(20)) returns table
as 
return select * from TIMETABLE where TIMETABLE.AUDITORIUM = @p;

select * from un('301-1')



create procedure unu @p varchar(20) as
select * from TIMETABLE where TIMETABLE.AUDITORIUM = @p;

exec unu @p ='301-1'