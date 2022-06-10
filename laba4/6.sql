select PULPIT.PULPIT_NAME as [Кафедра], isnull (TEACHER.TEACHER_NAME, '***') as [Преподаватель]
from PULPIT left outer join TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT