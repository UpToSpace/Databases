--1. Разработать представление с именем Преподаватель. Представление должно быть построено на основе SELECT-запроса к 
--таблице TEACHER и содержать следующие столбцы: код (TEACHER), имя преподавателя (TEACHER_NAME), пол (GENDER), код кафедры (PULPIT). 

create view [Преподаватель]
as select TEACHER.TEACHER, TEACHER.TEACHER_NAME, TEACHER.GENDER, TEACHER.PULPIT
from TEACHER
drop view [Преподаватель]

--2. Разработать и создать представление с именем Количество кафедр. Представление должно быть построено на основе
--SELECT-запроса к таблицам FACULTY и PULPIT.Представление должно содержать следующие столбцы: факультет
--(FACULTY.FACULTY_ NAME), количество кафедр (вычисляется на основе строк таблицы PULPIT). 
 
create view [Количество кафедр]
as select FACULTY.FACULTY_NAME, count(PULPIT.PULPIT) [pulpit count] from FACULTY inner join PULPIT on 
FACULTY.FACULTY = PULPIT.FACULTY group by FACULTY.FACULTY_NAME
drop view [Количество кафедр]

--3. Разработать и создать представление с именем Аудитории. Представление должно быть построено на основе
--таблицы AUDITORIUM и содержать столбцы: код (AUDITORIUM), наименование аудитории (AUDITORIUM_NAME). 
--Представление должно отображать только лекционные аудитории (в столбце AUDITORIUM_TYPE строка,
--начинающаяся с символа ЛК) и допускать выполнение оператора INSERT, UPDATE и DELETE.

create view [Аудитории]
as select AUDITORIUM.AUDITORIUM, AUDITORIUM.AUDITORIUM_NAME from AUDITORIUM
where AUDITORIUM.AUDITORIUM_TYPE like 'ЛК%'
drop view [Аудитории]

--4. Разработать и создать представление с именем Лекционные_аудитории. 
--Представление должно быть построено на основе SELECT-запроса к таблице AUDITORIUM и содержать следующие столбцы:
--код (AUDITORIUM), наименование аудитории (AUDITORIUM_NAME). 
--Представление должно отображать только лекционные аудитории (в столбце AUDITORIUM_TYPE строка, начинающаяся с символов ЛК). 
--Выполнение INSERT и UPDATE допускается, но с учетом ограничения, задаваемого опцией WITH CHECK OPTION. 

create view [Лекционные_аудитории]
as select AUDITORIUM, AUDITORIUM_NAME from AUDITORIUM
where AUDITORIUM.AUDITORIUM_TYPE like 'ЛК%'
with check option

drop view [Лекционные_аудитории]


--5. Разработать представление с именем Дисциплины. Представление должно быть построено на основе SELECT-запроса
--к таблице SUBJECT, отображать все дисциплины в алфавитном порядке и содержать следующие столбцы: код (SUBJECT), наименование дисциплины (SUBJECT_NAME) и код кафедры (PULPIT). Использовать TOP и ORDER BY.

create view [Дисциплины]
as select top 100 SUBJECT, SUBJECT_NAME, PULPIT from SUBJECT
order by SUBJECT_NAME 

drop view [Дисциплины]

--6. Изменить представление Количество_кафедр, созданное в задании 2 так, чтобы оно было привязано к базовым
--таблицам. Продемонстрировать свойство привязанности представления к базовым таблицам. Примечание: использовать опцию SCHEMABINDING. 

alter view [Количество кафедр] with schemabinding
as select FACULTY.FACULTY_NAME [faculty], count(PULPIT.PULPIT) [pulpit count] from dbo.FACULTY inner join dbo.PULPIT on 
FACULTY.FACULTY = PULPIT.FACULTY group by FACULTY.FACULTY_NAME
drop view [Количество кафедр]
