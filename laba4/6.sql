select PULPIT.PULPIT_NAME as [�������], isnull (TEACHER.TEACHER_NAME, '***') as [�������������]
from PULPIT left outer join TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT