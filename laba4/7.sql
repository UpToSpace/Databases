select PULPIT.PULPIT_NAME as [�������], isnull (TEACHER.TEACHER_NAME, '***') as [�������������]
from TEACHER right outer join PULPIT
on PULPIT.PULPIT = TEACHER.PULPIT