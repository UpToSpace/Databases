select PULPIT.PULPIT_NAME as [Кафедра], isnull (TEACHER.TEACHER_NAME, '***') as [Преподаватель]
from TEACHER right outer join PULPIT
on PULPIT.PULPIT = TEACHER.PULPIT