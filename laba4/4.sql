select
FACULTY.FACULTY_NAME as [���������],
PULPIT.PULPIT_NAME as [�������],
SUBJECT.SUBJECT_NAME as [����������],
STUDENT.NAME as [��� ��������],
case 
when (PROGRESS.NOTE = 6) then '�����'
when (PROGRESS.NOTE = 7) then '����'
when (PROGRESS.NOTE = 8) then '������'
end '������'
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
