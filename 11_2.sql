--4--

-----B–-------

begin transaction
select @@SPID
insert FACULTY values('ФИТ','Факультет ИТ');

update PULPIT set FACULTY = 'ИЭФ' WHERE PULPIT = 'ИСиТ'
-----t1----------
-----t2----------
ROLLBACK;

dELETE FACULTY WHERE FACULTY = 'ФИТ';




--5--
-----B----
begin transaction
------t1-----
update PULPIT set FACULTY = 'ИТ' where PULPIT = 'ТЛ';
------t2------
rollback




--6--
--- B ---	
begin transaction 	  
--------t1---------
update PULPIT set FACULTY = 'ИТ' where PULPIT = 'ТЛ';
commit
--------t2---------

delete PULPIT where PULPIT='ПОИТ' 

--7--
--- B ---	
begin transaction 	  
delete AUDITORIUM where AUDITORIUM = '123-4' 
insert AUDITORIUM values ('123-4', 'ЛК', 10, '123-1')
update AUDITORIUM set AUDITORIUM_NAME = '123-4' where AUDITORIUM = '123-4'
select AUDITORIUM from AUDITORIUM  where AUDITORIUM = '123-4'
--------t1---------
commit
select AUDITORIUM from AUDITORIUM  where AUDITORIUM = '123-4'
--------t2---------