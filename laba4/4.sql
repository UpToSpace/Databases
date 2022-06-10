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
