--На основе таблиц AUDITORIUM_ TYPE и AUDITORIUM сформировать перечень кодов аудиторий
--(столбец AUDITORUM.AUDITORIUM) и соответствующих им наименований типов аудиторий 
--(столбец AUDITORIUM_ TYPE.AUDITORIUM_ TYPENAME). 
--Примечание: использовать соединение таблиц INNER JOIN. 

select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
from AUDITORIUM inner join AUDITORIUM_TYPE 
on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE

--На основе таблиц AUDITORIUM_TYPE и AUDITORIUM сформировать перечень кодов аудиторий (столбец AUDITORIUM.AUDITORIUM)
--и соответ-ствующих им наименований типов аудиторий (столбец AUDITORIUM_ TYPE.AUDITO-RIUM_TYPENAME). 
--При этом следует выбрать только те аудитории, в наименовании которых присутствует подстрока компьютер. 
--Примечание: использовать соединение таблиц INNER JOIN и предикат LIKE. 

select AUDITORIUM_TYPE.AUDITORIUM_TYPENAME, AUDITORIUM.AUDITORIUM
from AUDITORIUM_TYPE inner join AUDITORIUM
on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE 
and AUDITORIUM_TYPE.AUDITORIUM_TYPENAME like '%компьютер%';

--Написать два SELECT-запроса, формирующих результирующие наборы аналогичные запросам из заданий 1 и 2,
--но без применения INNER JOIN. 

select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
from AUDITORIUM, AUDITORIUM_TYPE 
where AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE;

select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
from AUDITORIUM, AUDITORIUM_TYPE 
where AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
and AUDITORIUM_TYPE.AUDITORIUM_TYPENAME like '%компьютер%';

--На основе таблиц PRORGESS, STUDENT, GROUPS, SUBJECT, PULPIT и FACULTY сформировать перечень студентов,
--по-лучивших экзаменационные оценки (столбец PROGRESS.NOTE) от 6 до 8. 

select
FACULTY.FACULTY_NAME as [Факультет],
PULPIT.PULPIT_NAME as [Кафедра],
SUBJECT.SUBJECT_NAME as [Дисциплина],
STUDENT.NAME as [Имя Студента],
case 
when (PROGRESS.NOTE = 6) then 'шесть'
when (PROGRESS.NOTE = 7) then 'семь'
when (PROGRESS.NOTE = 8) then 'восемь'
end 'Оценка'
from PROGRESS
inner join STUDENT
on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT 
and PROGRESS.NOTE between 6 and 8
inner join GROUPS
on GROUPS.IDGROUP = STUDENT.IDGROUP
inner join FACULTY 
on GROUPS.FACULTY = FACULTY.FACULTY
inner join SUBJECT
on SUBJECT.SUBJECT = PROGRESS.SUBJECT
inner join PULPIT
on SUBJECT.PULPIT= PULPIT.PULPIT
order by FACULTY.FACULTY, PULPIT.PULPIT, STUDENT.NAME asc, PROGRESS.NOTE desc

--Переписать запрос, реализующий задание 4 таким образом, чтобы в результирующем наборе сортировка по 
--экзаменационным оценкам была следующей: сначала вы-водились строки с оценкой 7, затем строки с оценкой 8 и далее строки с оценкой 6. 
--Примечание: использовать выражение CASE в секции ORDER BY.

select
FACULTY.FACULTY_NAME as [Факультет],
PULPIT.PULPIT_NAME as [Кафедра],
SUBJECT.SUBJECT_NAME as [Дисциплина],
STUDENT.NAME as [Имя Студента],
case 
when (PROGRESS.NOTE = 6) then 'шесть'
when (PROGRESS.NOTE = 7) then 'семь'
when (PROGRESS.NOTE = 8) then 'восемь'
end 'Оценка'
from PROGRESS
inner join STUDENT
on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT 
and PROGRESS.NOTE between 6 and 8
inner join GROUPS
on GROUPS.IDGROUP = STUDENT.IDGROUP
inner join FACULTY 
on GROUPS.FACULTY = FACULTY.FACULTY
inner join SUBJECT
on SUBJECT.SUBJECT = PROGRESS.SUBJECT
inner join PULPIT
on SUBJECT.PULPIT= PULPIT.PULPIT
order by PROGRESS.NOTE desc, FACULTY.FACULTY, PULPIT.PULPIT, STUDENT.NAME asc

--На основе таблиц PULPIT и TEACHER получить полный перечень кафедр (столбец PULPIT.PULPIT_ NAME) и пре-
--подавателей (столбец TEACHER.TEA-CHER_NAME) на этих кафедрах. Результирующий набор должен содержать два столбца:
--Кафедра и Преподаватель. Если на кафедре нет преподавателей, то в столбце Преподаватель должна быть выведена строка ***. 
--Примечание: использовать соединение таблиц LEFT OUTER JOIN и функцию isnull.

select PULPIT.PULPIT_NAME as [Кафедра], isnull (TEACHER.TEACHER_NAME, '***') as [Преподаватель]
from PULPIT left outer join TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT

--В запросе, реализующем пункт 6, поменять порядок таблиц в выражении LEFT OUTER JOIN. 
--Переписать запрос таким образом, чтобы получился аналогичный результат, но применялось соединение таблиц RIGHT OUTER JOIN.

select PULPIT.PULPIT_NAME as [Кафедра], isnull (TEACHER.TEACHER_NAME, '***') as [Преподаватель]
from TEACHER left outer join PULPIT
on PULPIT.PULPIT = TEACHER.PULPIT

select PULPIT.PULPIT_NAME as [Кафедра], isnull (TEACHER.TEACHER_NAME, '***') as [Преподаватель]
from TEACHER right outer join PULPIT
on PULPIT.PULPIT = TEACHER.PULPIT

--− запрос, результат которого содержит данные левой (в операции FULL OUTER JOIN) таблицы и не содержит данные правой; 
--− запрос, результат которого содержит данные правой таблицы и не содержащие данные левой; 
--− запрос, результат которого содержит данные правой таблицы и левой таблиц;
--Примечание: использовать в запросах выражение IS NULL и IS NOT NULL.

--содержит данные левой таблицы и не содержит данные правой
select PULPIT.FACULTY, PULPIT.PULPIT, PULPIT.PULPIT_NAME
from PULPIT full outer join TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT
where TEACHER.TEACHER is null

--содержит данные правой таблицы и не со-держащие данные левой
select TEACHER.TEACHER_NAME, TEACHER.TEACHER, TEACHER.PULPIT,TEACHER.GENDER
from PULPIT full outer join TEACHER
on PULPIT.PULPIT=TEACHER.PULPIT
where TEACHER.TEACHER is not null

--содержит данные правой таблицы и левой таблиц
select * from PULPIT full outer join TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT

--Разработать SELECT-запрос на основе CROSS JOIN-соединения таблиц AUDITORIUM_TYPE и AUDITORIUM, 
--формирующего результат, аналогичный результату, полученному при выполнении запроса в задании 1.

SELECT * from AUDITORIUM_TYPE cross join AUDITORIUM
where AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE





--8. Показать на примере, что соединение FULL OUTER JOIN двух таблиц:
--− является коммутативной операцией;
select SUBJECT.SUBJECT from SUBJECT full outer join PULPIT
on PULPIT.PULPIT = SUBJECT.PULPIT

select SUBJECT.SUBJECT from PULPIT full outer join SUBJECT
on PULPIT.PULPIT = SUBJECT.PULPIT
--− является объединением LEFT OUTER JOIN и RIGHT OUTER JOIN соединений этих таблиц;
select SUBJECT.SUBJECT from SUBJECT left outer join PULPIT
on PULPIT.PULPIT = SUBJECT.PULPIT
union ALL
select SUBJECT.SUBJECT from SUBJECT right outer join PULPIT
on PULPIT.PULPIT = SUBJECT.PULPIT
except
(select SUBJECT.SUBJECT from SUBJECT full outer join PULPIT
on PULPIT.PULPIT = SUBJECT.PULPIT)

--− включает соединение INNER JOIN этих таблиц.
select SUBJECT.SUBJECT from PULPIT inner join SUBJECT
on PULPIT.PULPIT = SUBJECT.PULPIT
except
(select SUBJECT.SUBJECT from SUBJECT full outer join PULPIT
on PULPIT.PULPIT = SUBJECT.PULPIT)

--5. Переписать запрос, реализующий задание 4 таким образом, чтобы в результирующем наборе сортировка по экзаменационным оценкам была следующей:
--сначала выводились строки с оценкой 7, затем строки с оценкой 8 и далее строки с оценкой 6. 
--Примечание: использовать выражение CASE в секции ORDER BY.
select
FACULTY.FACULTY_NAME as [Факультет],
PULPIT.PULPIT_NAME as [Кафедра],
SUBJECT.SUBJECT_NAME as [Дисциплина],
STUDENT.NAME as [Имя Студента],
case 
when (PROGRESS.NOTE = 6) then 'шесть'
when (PROGRESS.NOTE = 7) then 'семь'
when (PROGRESS.NOTE = 8) then 'восемь'
end 'Оценка'
from PROGRESS
inner join STUDENT
on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT 
inner join GROUPS
on GROUPS.IDGROUP = STUDENT.IDGROUP
inner join FACULTY 
on GROUPS.FACULTY = FACULTY.FACULTY
inner join SUBJECT
on SUBJECT.SUBJECT = PROGRESS.SUBJECT
inner join PULPIT
on SUBJECT.PULPIT= PULPIT.PULPIT
where PROGRESS.NOTE between 6 and 8
order by (case
when (PROGRESS.NOTE = 6) then -1
when (PROGRESS.NOTE = 7) then 0
when (PROGRESS.NOTE = 8) then 1
end
);