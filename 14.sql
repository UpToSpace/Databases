-- 1. С помощью сценария, представленного на рисунке, создать таблицу TR_AUDIT.
--Таблица предназначена для добавления в нее строк триггерами. 
--В столбец STMT триггер должен поместить событие, на которое он среагировал, а в столбец TRNAME собственное имя. 
--Разработать AFTER-триггер с именем TR_TEACHER_INS для таблицы TEACHER, реагирующий на событие INSERT. 
--Триггер должен записывать строки вводимых данных в таблицу TR_AUDIT. В столбец СС помещаются значения столбцов вводимой строки. 

create table TR_AUDIT(
ID int identity(1,1), 
STMT varchar(20) 
     check (STMT in('INS','DEL','UPD')),
TRNAME varchar(50),
CC varchar(300))
go

create trigger TR_TEACHER_INS on TEACHER after INSERT  
as declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
print 'Insert';
set @a1 = (select TEACHER from INSERTED);
set @a2= (select TEACHER_NAME from INSERTED);
set @a3= (select GENDER from INSERTED);
set @a4 = (select PULPIT from INSERTED);
set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
insert into TR_AUDIT(STMT, TRNAME, CC) values('INS', 'TR_TEACHER_INS', @in);	         
return; 
go

insert into TEACHER values('РРР', 'ЗЗЗ', 'м', 'ТЛ');
select * from TR_AUDIT

drop trigger TR_TEACHER_INS

--2. Создать AFTER-триггер с именем TR_TEACHER_DEL для таблицы TEA-CHER, реагирующий на событие DELETE. 
--Триггер должен записывать строку данных в таблицу TR_AUDIT для каждой удаляемой строки. В столбец СС помещаются значения столбца TEACHER удаляемой строки. 

create  trigger TR_TEACHER_DEL on TEACHER after DELETE  
as declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
print 'deleted';
set @a1 = (select TEACHER from DELETED);
set @a2= (select TEACHER_NAME from DELETED);
set @a3= (select GENDER from DELETED);
set @a4 = (select PULPIT from DELETED);
set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
insert into TR_AUDIT(STMT, TRNAME, CC) values('DEL', 'TR_TEACHER_DEL', @in);	         
return;  
go 

delete TEACHER where TEACHER.TEACHER = 'РРР';
select * from TR_AUDIT

drop trigger TR_TEACHER_DEL

--3. Создать AFTER-триггер с именем TR_TEACHER_UPD для таблицы TEA-CHER, реагирующий на событие UPDATE. 
--Триггер должен записывать строку данных в таблицу TR_AUDIT для каждой изменяемой строки. В столбец СС помещаются 
--значения столбцов изменяемой строки до и после изменения.

create trigger TR_TEACHER_UPD on TEACHER after UPDATE  
as declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
print 'update';
set @a1 = (select TEACHER from INSERTED);
set @a2= (select TEACHER_NAME from INSERTED);
set @a3= (select GENDER from INSERTED);
set @a4 = (select PULPIT from INSERTED);
set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;

set @a1 = (select TEACHER from deleted);
set @a2= (select TEACHER_NAME from DELETED);
set @a3= (select GENDER from DELETED);
set @a4 = (select PULPIT from DELETED);
set @in =@in + '' + @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
insert into TR_AUDIT(STMT, TRNAME, CC) values('UPD', 'TR_TEACHER_UPD', @in);       
return;  
go

insert into TEACHER values('РРР', 'ЗЗЗ', 'м', 'ТЛ');
update TEACHER set TEACHER_NAME = 'ШШШШ' where TEACHER = 'РРР'
select * from TR_AUDIT

drop trigger TR_TEACHER_UPD

--4. Создать AFTER-триггер с именем TR_TEACHER для таблицы TEACHER, реагирующий на события INSERT, DELETE, UPDATE. 
--Триггер должен записывать строку данных в таблицу TR_AUDIT для каждой изменяемой строки. В коде триггера 
--определить событие, активизировавшее триггер и поместить в столбец СС соответствующую событию информацию. 
--Разработать сценарий, демонстрирующий работоспособность триггера. 

create trigger TR_TEACHER on TEACHER after INSERT, DELETE, UPDATE  
as declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
if ((select count(*) from deleted)=0)
begin
print 'INSERT';
set @a1 = (select TEACHER from INSERTED);
set @a2= (select TEACHER_NAME from INSERTED);
set @a3= (select GENDER from INSERTED);
set @a4 = (select PULPIT from INSERTED);
set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
insert into TR_AUDIT(STMT, TRNAME, CC) values('INS', 'TR_TEACHER', @in);	
end;

else if ((select count(*) from inserted)= 0)	  	 
begin
print 'DELETE';
set @a1 = (select TEACHER from DELETED);
set @a2= (select TEACHER_NAME from DELETED);
set @a3= (select GENDER from DELETED);
set @a4 = (select PULPIT from DELETED);
set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
insert into TR_AUDIT(STMT, TRNAME, CC) values('DEL', 'TR_TEACHER', @in);
end;

else if ((select count(*) from inserted)>0 and  (select count(*) from deleted)>0)
begin
print 'UPDATE'; 
set @a1 = (select TEACHER from INSERTED);
set @a2= (select TEACHER_NAME from INSERTED);
set @a3= (select GENDER from INSERTED);
set @a4 = (select PULPIT from INSERTED);
set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;

set @a1 = (select TEACHER from deleted);
set @a2= (select TEACHER_NAME from DELETED);
set @a3= (select GENDER from DELETED);
set @a4 = (select PULPIT from DELETED);
set @in =@in + '' + @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
insert into TR_AUDIT(STMT, TRNAME, CC) values('UPD', 'TR_TEACHER', @in); 
end;
return;  

insert into TEACHER values('РРР', 'ЗЗЗ', 'м', 'ТЛ');
update TEACHER set TEACHER_NAME = 'ШШШШ' where TEACHER = 'РРР'
delete TEACHER where TEACHER.TEACHER = 'РРР';
select * from TR_AUDIT


--5. Разработать сценарий, который демонстрирует на примере базы данных X_UNIVER, 
--что проверка ограничения целостности выполняется до срабатывания AFTER-триггера.

insert into TEACHER values('РРР', 'ЗЗЗ', 'м', 'ТЛ');
select * from TR_AUDIT
drop trigger TR_TEACHER

--6. Создать для таблицы TEACHER три AFTER-триггера с именами: TR_TEACHER_ DEL1, TR_TEACHER_DEL2 и 
--TR_TEA-CHER_ DEL3. Триггеры должны реагировать на событие DELETE и формировать соответствующие строки в таблицу 
--TR_AUDIT.  Получить список триггеров таблицы TEACHER. 
--Упорядочить выполнение триггеров для таблицы TEACHER, реагирующих на событие DELETE следующим образом: первым 
--должен выполняться триггер с именем TR_TEA-CHER_DEL3, последним – триггер TR_TEACHER_DEL2. 
--Примечание: использовать системные представления SYS.TRIGGERS и SYS.TRIG-GERS_ EVENTS, а также системную процедуру SP_SETTRIGGERORDERS. 

create trigger TR_TEACHER_DEL1 on TEACHER after delete
as print 'DELETE Trigger 1'
return;
go
create trigger TR_TEACHER_DEL2 on TEACHER after delete
as print 'DELETE Trigger 2'
return;  
go
create trigger TR_TEACHER_DEL3 on TEACHER after delete
as print 'DELETE Trigger 3'
return;  

select t.name, e.type_desc 
from sys.triggers t join  sys.trigger_events e  
on t.object_id = e.object_id  
where OBJECT_NAME(t.parent_id) = 'TEACHER' and e.type_desc = 'DELETE'

exec SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL3', @order = 'First', @stmttype = 'DELETE'
exec SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL2', @order = 'Last',  @stmttype = 'DELETE'

insert into TEACHER values('РРР', 'ЗЗЗ', 'м', 'ТЛ');
delete TEACHER where TEACHER.TEACHER = 'РРР';

drop trigger TR_TEACHER_DEL1
drop trigger TR_TEACHER_DEL2
drop trigger TR_TEACHER_DEL3

--7. Разработать сценарий, демонстрирующий на примере базы данных X_UNIVER утверждение: AFTER-триггер является частью
--транзакции, в рамках которого выполняется оператор, активизировавший триггер.

create trigger FAC on FACULTY after INSERT, DELETE, UPDATE  
as declare @c int = (select count (*) from FACULTY); 	 
if (@c > 5) 
begin
raiserror('Колво факультетов должно быть > 5', 10, 1);
rollback; 
end; 
return;          

insert into FACULTY values ('FAC', 'FAC_NAME')

delete FACULTY where FACULTY ='FAC'
drop trigger FAC

--8.  Для таблицы FACULTY создать INSTEAD OF-триггер, запрещающий удаление строк в таблице. 
--Разработать сценарий, который демонстрирует на примере базы данных X_UNIVER, что проверка ограничения
--целостности выполнена, если есть INSTEAD OF-триггер.
--С помощью оператора DROP удалить все DML-триггеры, созданные в этой лабораторной работе.

create trigger INSTEAD_OF on FACULTY instead of DELETE 
as print 'Вместо удаления факультета';
return;

insert into FACULTY values ('FAC', 'FAC_NAME')
delete FACULTY where FACULTY ='FAC'
select * from FACULTY;

drop trigger INSTEAD_OF

--9. Создать DDL-триггер, реагирующий на все DDL-события в БД UNIVER. Триггер должен запрещать
--создавать новые таблицы и удалять существующие. Свое выполнение триггер должен сопровождать сообщением, которое содержит:
--тип события, имя и тип объекта, а также пояснительный текст, в случае запрещения выполнения оператора. 
--Разработать сценарий, демонстрирующий работу триггера. 

create trigger TR_TEACHER_DDL on database for DDL_DATABASE_LEVEL_EVENTS  
as   
declare @EVENT_TYPE varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)')
declare @OBJ_NAME varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)')
declare @OBJ_TYPE varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)')
if @OBJ_NAME = 'TEACHER' 
begin
       print 'Тип события: '+@EVENT_TYPE;
       print 'Имя объекта: '+@OBJ_NAME;
       print 'Тип объекта: '+@OBJ_TYPE;
       raiserror( N'операции с таблицей запрещены', 16, 1);  
rollback  
end

alter table TEACHER drop column TEACHER_NAME

select * from TEACHER

drop trigger TR_TEACHER_DDL
drop table TR_AUDIT
