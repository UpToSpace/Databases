--1. На основе таблицы AUDITORIUM разработать SELECT-запрос, вычисляющий максимальную, минимальную и среднюю вместимость аудиторий,
--суммарную вместимость всех аудиторий и общее количество аудиторий. 

select max(AUDITORIUM.AUDITORIUM_CAPACITY) [max capacity],
min(AUDITORIUM.AUDITORIUM_CAPACITY) [min capacity],
avg(AUDITORIUM.AUDITORIUM_CAPACITY) [average],
sum(AUDITORIUM.AUDITORIUM_CAPACITY) [sum],
count(AUDITORIUM.AUDITORIUM) [count]
from AUDITORIUM

--2. На основе таблиц AUDITORIUM и AUDITORIUM_TYPE разработать запрос, вычисляющий для каждого типа аудиторий максимальную, минимальную,
--среднюю вместимость аудиторий, суммарную вместимость всех аудиторий и общее количество аудиторий данного типа. 
--Результирующий набор должен содержать столбец с наименованием типа аудиторий (столбец AUDITORIUM_TYPE.AU-DITORIUM_TYPENAME)
--и столбцы с вычисленными величинами. Использовать внутреннее соединение таблиц, секцию GROUP BY и агрегатные функции. 

select
AUDITORIUM_TYPE.AUDITORIUM_TYPENAME,
max(AUDITORIUM.AUDITORIUM_CAPACITY) [max capacity],
min(AUDITORIUM.AUDITORIUM_CAPACITY) [min capacity],
avg(AUDITORIUM.AUDITORIUM_CAPACITY) [average],
sum(AUDITORIUM.AUDITORIUM_CAPACITY) [sum],
count(AUDITORIUM.AUDITORIUM) [count]
from AUDITORIUM inner join AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
group by AUDITORIUM_TYPE.AUDITORIUM_TYPENAME

--3. Разработать запрос на основе таблицы PROGRESS, который содержит количество экзаменационных оценок в заданном интервале.
--При этом учесть, что сортировка строк должна осуществляться в порядке, обратном величине оценки;
--сумма значений в столбце количество должна быть равна количеству строк в таблице PROGRESS. 
--Использовать подзапрос в секции FROM, в подзапросе применить GROUP BY, сортировку осуществить во внешнем запросе.
--В секции GROUP BY, в SELECT-списке подзапроса и в ORDER BY внешнего запроса применить CASE. 

SELECT * FROM(
SELECT CASE 
		WHEN NOTE = 10 then '10'
		WHEN NOTE between 8 and 9 then '8-9'
		WHEN NOTE between 6 and 7 then '6-7'
		WHEN NOTE between 4 and 5 then '4-5'
	END [Оценка],
	COUNT(*) as [Количество]
	FROM PROGRESS GROUP BY CASE
		WHEN NOTE = 10 then '10'
		WHEN NOTE between 8 and 9 then '8-9'
		WHEN NOTE between 6 and 7 then '6-7'
		WHEN NOTE between 4 and 5 then '4-5'
	END) AS T
ORDER BY Case [Оценка]
	WHEN '10' then 4
	WHEN '8-9' then 3
	WHEN '6-7' then 2
	WHEN '4-5' then 1
	END;

--4. Разработать SELECT-запроса на основе таблиц FACULTY, GROUPS, STUDENT и PROGRESS, который содержит среднюю экзаменационную оценку для каждого
--курса каждой специальности. Строки отсортировать в порядке убывания средней оценки.
--При этом следует учесть, что средняя оценка должна рассчитываться с точностью до двух знаков после запятой. 
--Использовать внутреннее соединение таблиц, агрегатную функцию AVG и встроенные функции CAST и ROUND.

select FACULTY.FACULTY_NAME, GROUPS.PROFESSION, STUDENT.IDGROUP, round(avg(cast (PROGRESS.NOTE as float(4))), 2) as [Средняя оценка]
from FACULTY inner join GROUPS on FACULTY.FACULTY = GROUPS.FACULTY inner join STUDENT on 
STUDENT.IDGROUP = GROUPS.IDGROUP inner join PROGRESS on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
group by FACULTY.FACULTY_NAME, GROUPS.PROFESSION, STUDENT.IDGROUP

--Переписать SELECT-запрос, разработанный в задании 4 так, чтобы в расчете среднего значения оценок использовались 
--оценки только по дисциплинам с кодами БД и ОАиП. Использовать WHERE.

select FACULTY.FACULTY_NAME, GROUPS.PROFESSION, STUDENT.IDGROUP, round(avg(cast (PROGRESS.NOTE as float(4))), 2) as [Средняя оценка]
from FACULTY inner join GROUPS on FACULTY.FACULTY = GROUPS.FACULTY inner join STUDENT on 
STUDENT.IDGROUP = GROUPS.IDGROUP inner join PROGRESS on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
where (progress.subject = 'БД' or progress.subject = 'ОАиП')
group by FACULTY.FACULTY_NAME, GROUPS.PROFESSION, STUDENT.IDGROUP

--5. На основе таблиц FACULTY, GROUPS, STUDENT и PROGRESS разработать SELECT-запрос,
--в котором выводятся специальность, дисциплины и средние оценки при сдаче экзаменов на факультете ТОВ. Использовать группировку по полям FACULTY, PROFESSION, SUBJECT.
-- Добавить в запрос конструкцию ROLLUP и проанализировать результат. 

select FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT, round(avg(cast (PROGRESS.NOTE as float(4))), 2) as [Средняя оценка]
from GROUPS, STUDENT, FACULTY, PROGRESS
where (FACULTY.FACULTY like 'ТОВ')
group by rollup(FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT)

--6. Выполнить исходный SELECT-запрос п.5 с использованием CUBE-группировки. Проанализировать результат.

select FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT, round(avg(cast (PROGRESS.NOTE as float(4))), 2) as [Средняя оценка]
from GROUPS, STUDENT, FACULTY, PROGRESS
where (FACULTY.FACULTY like 'ТОВ')
group by cube(FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT)

--7. На основе таблиц GROUPS, STUDENT и PROGRESS разработать SELECT-запрос, в котором определяются результаты сдачи экзаменов.
--В запросе должны отражаться специальности, дисциплины, средние оценки студентов на факультете ТОВ.
--Отдельно разработать запрос, в котором определяются результаты сдачи экзаменов на факультете ХТиТ.
--Объединить результаты двух запросов с использованием операторов UNION и UNION ALL. Объяснить результаты. 

SELECT 
	FACULTY.FACULTY,
	GROUPS.PROFESSION,
	round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [Средняя оценка]
FROM GROUPS 
	inner join FACULTY 
ON FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT
ON STUDENT.IDGROUP = GROUPS.IDGROUP
	inner join PROGRESS
ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY in ('ТОВ')
GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION
	UNION
SELECT 
	FACULTY.FACULTY,
	GROUPS.PROFESSION,
	round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [Средняя оценка]
FROM GROUPS 
	inner join FACULTY 
ON FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT
ON STUDENT.IDGROUP = GROUPS.IDGROUP
	inner join PROGRESS
ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY in ('ХТиТ')
GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION


SELECT 
	FACULTY.FACULTY,
	GROUPS.PROFESSION,
	round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [Средняя оценка]
FROM GROUPS 
	inner join FACULTY 
ON FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT
ON STUDENT.IDGROUP = GROUPS.IDGROUP
	inner join PROGRESS
ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY in ('ТОВ')
GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION
	UNION ALL
SELECT 
	FACULTY.FACULTY,
	GROUPS.PROFESSION,
	round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [Средняя оценка]
FROM GROUPS 
	inner join FACULTY 
ON FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT
ON STUDENT.IDGROUP = GROUPS.IDGROUP
	inner join PROGRESS
ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY in ('ХТиТ')
GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION

--8. Получить пересечение двух множеств строк, созданных в результате выполнения запросов пункта 8. Объяснить результат.
--Использовать оператор INTERSECT.

SELECT 
	FACULTY.FACULTY,
	GROUPS.PROFESSION,
	round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [Средняя оценка]
FROM GROUPS 
	inner join FACULTY 
ON FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT
ON STUDENT.IDGROUP = GROUPS.IDGROUP
	inner join PROGRESS
ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY in ('ТОВ')
GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION
	INTERSECT
SELECT 
	FACULTY.FACULTY,
	GROUPS.PROFESSION,
	round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [Средняя оценка]
FROM GROUPS 
	inner join FACULTY 
ON FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT
ON STUDENT.IDGROUP = GROUPS.IDGROUP
	inner join PROGRESS
ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY in ('ХТиТ')
GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION

--9. Получить разницу между множеством строк, созданных в результате запросов пункта 8.
-- Объяснить результат. 
--Использовать оператор EXCEPT.

SELECT 
	FACULTY.FACULTY,
	GROUPS.PROFESSION,
	round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [Средняя оценка]
FROM GROUPS 
	inner join FACULTY 
ON FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT
ON STUDENT.IDGROUP = GROUPS.IDGROUP
	inner join PROGRESS
ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY in ('ТОВ')
GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION
	EXCEPT
SELECT 
	FACULTY.FACULTY,
	GROUPS.PROFESSION,
	round(avg(cast(PROGRESS.NOTE AS float(4))), 2) [Средняя оценка]
FROM GROUPS 
	inner join FACULTY 
ON FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT
ON STUDENT.IDGROUP = GROUPS.IDGROUP
	inner join PROGRESS
ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
WHERE FACULTY.FACULTY in ('ХТиТ')
GROUP BY FACULTY.FACULTY, GROUPS.PROFESSION

--10. На основе таблицы PROGRESS определить для каждой дисциплины количество студентов, получивших оценки 8 и 9. 
--Использовать группировку, секцию HAVING, сортировку. 

SELECT PROGRESS.SUBJECT,PROGRESS.NOTE, (
SELECT COUNT(P.IDSTUDENT) FROM PROGRESS P
WHERE P.SUBJECT = PROGRESS.SUBJECT AND P.NOTE = PROGRESS.NOTE
)
FROM PROGRESS
GROUP BY PROGRESS.SUBJECT, PROGRESS.NOTE HAVING PROGRESS.NOTE IN (8, 9)
