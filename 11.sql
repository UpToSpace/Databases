-- 1. Разработать сценарий, демонстрирующий работу в режиме неявной транзакции.
--Проанализировать пример, приведенный справа, в котором создается таблица Х, и создать сценарий для другой таблицы.

set nocount on
	if  exists (select * from  SYS.OBJECTS        -- таблица X есть?
	            where OBJECT_ID= object_id(N'DBO.M') )	            
	drop table M;    
	
	declare @c int, @flag char = 'c';           -- commit или rollback?
	SET IMPLICIT_TRANSACTIONS  ON   -- включ. режим неявной транзакции
	CREATE table M(K int );                         -- начало транзакции 
		INSERT M values (1),(2),(3);
		set @c = (select count(*) from M);
		print 'количество строк в таблице M: ' + cast( @c as varchar(2));
		if @flag = 'c'  commit;                   -- завершение транзакции: фиксация 
	          else   rollback;                                 -- завершение транзакции: откат  
      SET IMPLICIT_TRANSACTIONS  OFF   -- выключ. режим неявной транзакции
	
	if  exists (select * from  SYS.OBJECTS       -- таблица X есть?
	            where OBJECT_ID= object_id(N'DBO.M') )
	print 'таблица M есть';  
      else print 'таблицы M нет'


--2. Разработать сценарий, демонстрирующий свойство атомарности явной транзакции на примере базы данных X_UNIVER. 
--В блоке CATCH предусмотреть выдачу соответствующих сообщений об ошибках. 
--Опробовать работу сценария при использовании различных операторов модификации таблиц.

begin try        
	begin tran                 
		insert AUDITORIUM values ('2', 'ЛБ-К', '15', '206-1');
	    insert AUDITORIUM values ('206-1', 'ЛК', '30', '206-1');
	commit tran;               
end try

begin catch
	print 'error: '+ case 
		when error_number() = 2627 and patindex('%AUDITORIUM_PK%', error_message()) > 0 then 'this pk exists'	
		else 'other error: '+ cast(error_number() as  varchar(5))+ error_message()  
	end;
	if @@trancount > 0 rollback tran; 	  
end catch;

select * from AUDITORIUM;

--3. Разработать сценарий, демонстрирующий применение оператора SAVE TRAN на примере базы данных X_UNIVER. 
--В блоке CATCH предусмотреть выдачу соответствующих сообщений об ошибках. 
--Опробовать работу сценария при использовании различных контрольных точек и различных операторов модификации таблиц.

declare @point varchar(32);

begin try
	begin tran                           
		set @point = 'p1'; 
		save tran @point; 
		insert PULPIT values
		       ('Дизайн', 'Дизайнеры', 'ИТ'),
			   ('Права', 'Права', 'ИЭФ'),
			   ('ДТ', 'Детали Машин', 'ТОВ')
  
		set @point = 'p2'; 
		save tran @point; 
		insert PULPIT values
		       ('Дизайн', 'Дизайнеры', 'ИТ'); 
	commit tran;                                              
end try

begin catch
	print 'error: '+ case 
		when error_number() = 2627 and patindex('%PULPIT_PK%', error_message()) > 0 then 'this pk exists' 
		else 'other error:: '+ cast(error_number() as  varchar(5)) + error_message()  
	end; 
    if @@trancount > 0
	begin
	   print 'контрольная точка: '+ @point;
	   rollback tran @point; 
	   commit tran; 
	end;     
end catch;

select * from PULPIT; 

--4. Разработать два сценария A и B на примере базы данных X_UNIVER. 
--Сценарий A представляет собой явную транзакцию с уровнем изолированности READ UNCOMMITED, сценарий B – явную транзакцию
--с уровнем изолированности READ COMMITED (по умолчанию). 

------A------
set transaction isolation level READ UNCOMMITTED
begin transaction
-----t1---------
select @@SPID, 'insert FACULTY' 'result', *
from FACULTY WHERE FACULTY = 'ФИТ';

select @@SPID, 'update PULPIT' 'result', *
from PULPIT WHERE FACULTY = 'ИЭФ';
commit;

rollback;

SELECT * FROM FACULTY;
SELECT * FROM PULPIT;

--Сценарий A должен демонстрировать, что уровень READ UNCOMMITED допускает неподтвержденное, неповторяющееся и фантомное чтение. 

--5. Разработать два сценария A и B на примере базы данных X_UNIVER. 
--Сценарии A и В  представляют собой явные транзакции с уровнем изолированности READ COMMITED. 
--Сценарий A должен демонстрировать, что уровень READ COMMITED не допускает неподтвержденного чтения, но при этом возможно 
--неповторяющееся и фантомное чтение. 

SELECT * from PULPIT;
-----A--------
set transaction isolation level READ COMMITTED
begin transaction
select count(*) from PULPIT where FACULTY = 'ИТ';
-----t1-------
-----t2-------
select 'update PULPIT' 'result', count(*) 
from PULPIT where FACULTY = 'ИТ'; 
commit;




--6. Разработать два сценария A и B на примере базы данных X_UNIVER. 
--Сценарий A представляет собой явную транзакцию с уровнем изолированности REPEATABLE READ. Сценарий B – явную транзакцию с уровнем 
--изолированности READ COMMITED. 
--Сценарий A должен демонстрировать, что уровень REAPETABLE READ не допускает неподтвержденного чтения и неповторяющегося чтения, 
--но при этом возможно фантомное чтение. 

--------A---------
set transaction isolation level REPEATABLE READ
begin transaction
select PULPIT FROM PULPIT WHERE FACULTY = 'ТЛ';
--------t1---------
--------t2---------
select case
when PULPIT = 'ТЛ' then 'insert'  
else ' ' 
end,
PULPIT from PULPIT where FACULTY = 'ТЛ'
commit


--7. Разработать два сценария A и B на примере базы данных X_UNIVER. 
--Сценарий A представляет собой явную транзакцию с уровнем изолированности SERIALIZABLE. 
--Сценарий B – явную транзакцию с уровнем изолированности READ COMMITED.
--Сценарий A должен демонстрировать отсутствие фантомного, неподтвержденного и неповторяющегося чтения.

set transaction isolation level SERIALIZABLE 
begin transaction 
delete AUDITORIUM where AUDITORIUM = '123-4'
insert AUDITORIUM values ('123-4', 'ЛК', 10, '123-1')
update AUDITORIUM set AUDITORIUM_NAME = '123-4' where AUDITORIUM = '123-4'
select AUDITORIUM from AUDITORIUM where AUDITORIUM = '123-4'
--------t1---------
select AUDITORIUM from AUDITORIUM where AUDITORIUM = '123-4'
--------t2---------
commit 	


select * from AUDITORIUM 

--8. Разработать сценарий, демонстрирующий свойства вложенных транзакций, на примере базы данных X_UNIVER. 

begin tran
insert AUDITORIUM_TYPE values ('ЛК-МОЙ', 'êàêîé òî òèï')
begin tran
update AUDITORIUM set AUDITORIUM_CAPACITY = '100' where AUDITORIUM_TYPE = 'ËÊ-Ê'
commit
if @@TRANCOUNT > 0
rollback

select (select count(*) from AUDITORIUM where AUDITORIUM_TYPE = 'ЛК-МОЙ') Àóäèòîðèè,
(select count(*) from AUDITORIUM_TYPE where AUDITORIUM_TYPE = 'ЛК-МОЙ') Òèï

select * from AUDITORIUM
select * from AUDITORIUM_TYPE
delete  AUDITORIUM_TYPE where  AUDITORIUM_TYPE = 'ЛК-МОЙ'; 