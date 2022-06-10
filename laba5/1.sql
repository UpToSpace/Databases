--1 На основе таблиц FACULTY, PULPIT и PROFESSION сформировать список наименований кафедр 
--(столбец PULPIT_NAME), которые находятся на факультете (таблица FACULTY), обеспечивающем
--подготовку по специальности, в наименовании (столбец PROFESSION_ NAME) которого содержится слово 
--технология или технологии. 

select PULPIT.PULPIT_NAME from PULPIT, FACULTY
where PULPIT.FACULTY = FACULTY.FACULTY
and PULPIT.FACULTY in 
(select PROFESSION.FACULTY from PROFESSION 
where PROFESSION.PROFESSION_NAME like '%технология%' or PROFESSION.PROFESSION_NAME like '%технологии%')

--2 Переписать запрос пункта 1 таким образом, чтобы тот же подзапрос был записан в конструкции INNER JOIN
--секции FROM внешнего запроса. При этом результат выполнения запроса должен быть аналогичным результату
--исходного запроса. 

select PULPIT.PULPIT_NAME from PULPIT inner join FACULTY
on PULPIT.FACULTY = FACULTY.FACULTY
where PULPIT.FACULTY in 
(select PROFESSION.FACULTY from PROFESSION 
where PROFESSION.PROFESSION_NAME like '%технология%' or PROFESSION.PROFESSION_NAME like '%технологии%')

--3 Переписать запрос, реализующий 1 пункт без использования подзапроса. 
--Примечание: использовать соединение INNER JOIN трех таблиц. 

select distinct PULPIT.PULPIT_NAME from PULPIT 
inner join FACULTY
on PULPIT.FACULTY = FACULTY.FACULTY
inner join PROFESSION
on PROFESSION.FACULTY = PULPIT.FACULTY
where PROFESSION.PROFESSION_NAME like '%технология%' or PROFESSION.PROFESSION_NAME like '%технологии%'

--4 На основе таблицы AUDITORIUM сформировать список аудиторий самых больших вместимостей (столбец AUDITORIUM_CAPACITY)
--для каждого типа аудитории (AUDITORIUM_TYPE). При этом результат следует отсортировать в порядке убывания вместимости. 
--Примечание: использовать коррелируемый подзапрос c секциями TOP и ORDER BY. 

select AUDITORIUM from AUDITORIUM a
where AUDITORIUM_CAPACITY = 
(select top(1) AUDITORIUM_CAPACITY from AUDITORIUM aa
where a.AUDITORIUM_TYPE = aa.AUDITORIUM_TYPE order by AUDITORIUM_CAPACITY desc)

--5 На основе таблиц FACULTY и PULPIT сформировать список наименований факультетов
--(столбец FACULTY_NAME) на котором нет ни одной кафедры (таблица PULPIT). 
--Примечание: использовать предикат EXISTS и коррелированный подзапрос. 

Select FACULTY.FACULTY_NAME
from FACULTY, PULPIT
where not exists(select PULPIT.PULPIT from PULPIT where FACULTY.FACULTY = PULPIT.FACULTY)

--6 На основе таблицы PROGRESS сформировать строку, содержащую средние значения оценок (столбец NOTE)
--по дисциплинам, имеющим следующие коды: ОАиП, БД и СУБД.
--Примечание: использовать три некоррелированных подзапроса в списке SELECT; 
--в подзапросах применить агрегатные функции AVG. 

select
(select AVG(PROGRESS.NOTE) from PROGRESS where PROGRESS.SUBJECT = 'ОАиП')[Средняя по ОАиП],
(select AVG(PROGRESS.NOTE) from PROGRESS where PROGRESS.SUBJECT = 'БД') [Средняя по БД],
(select AVG(PROGRESS.NOTE) from PROGRESS where PROGRESS.SUBJECT = 'СУБД') [Средняя по СУБД]

--7 Разработать SELECT-запрос, демонстрирующий принцип применения ALL совместно с подзапросом.

SELECT * FROM AUDITORIUM
	WHERE AUDITORIUM_CAPACITY >= ALL(SELECT AUDITORIUM_CAPACITY FROM AUDITORIUM
											WHERE AUDITORIUM_TYPE LIKE '%ЛК%');

--8 Разработать SELECT-запрос, демонстрирующий принцип применения ANY совместно с подзапросом.

SELECT * FROM AUDITORIUM
	WHERE AUDITORIUM_CAPACITY >= ANY(SELECT AUDITORIUM_CAPACITY FROM AUDITORIUM
											WHERE AUDITORIUM_TYPE LIKE '%ЛК%');

--10 Найти в таблице STUDENT студентов, у которых день рождения в один день. Объяснить решение.
select  a.Name, a.BDAY from STUDENT a
where BDAY in ( select BDAY from STUDENT where a.NAME != STUDENT.NAME)
order by BDAY
