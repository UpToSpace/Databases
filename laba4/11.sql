--������� ������� TIMETABLE (������, ���������, �������, �������������, ���� ������, ����),
--���������� ����� � ������� ���������, ��������� �������.
--�������� ������� �� ������� ��������� ��������� �� ������������ ����, 
--�� ������������ ���� ������, ������� ����� � �������������� � � �������.

use UNIVER
create table TIMETABLE(
DAY_OF_WEEK char(2) check (DAY_OF_WEEK in('��', '��', '��', '��', '��', '��')),
LESSON int check(LESSON between 1 and 4),
TEACHER char(10) constraint TIMETABLE_TEACHER_FK  foreign key references TEACHER(TEACHER),
AUDITORIUM char(20) constraint TIMETABLE_AUDITORIUM_FK foreign key references AUDITORIUM(AUDITORIUM),
SUBJECT char(10) constraint TIMETABLE_SUBJECT_FK  foreign key references SUBJECT(SUBJECT),
IDGROUP int constraint TIMETABLE_GROUP_FK  foreign key references GROUPS(IDGROUP)
)
insert into TIMETABLE values
('��', 1, '����', '313-1', '����', 15),
('��', 2, '����', '313-1', '����', 4),
('��', 3, '����', '313-1', '����', 11),
('��', 1, '���', '324-1', '����', 6),
('��', 3, '���', '324-1', '���', 4),
('��', 1, '���', '206-1', '���', 10),
('��', 4, '����', '206-1', '����', 3),
('��', 1, '�����', '301-1', '����', 7),
('��', 4, '�����', '301-1', '����', 7),
('��', 2, '�����', '413-1', '����', 8),
('��', 2, '���', '423-1', '����', 7)

select AUDITORIUM.AUDITORIUM from AUDITORIUM except
(
select AUDITORIUM.AUDITORIUM
from TIMETABLE , AUDITORIUM 
where TIMETABLE.LESSON = 4 and AUDITORIUM.AUDITORIUM = TIMETABLE.AUDITORIUM
);

select AUDITORIUM.AUDITORIUM from AUDITORIUM except
(
select AUDITORIUM.AUDITORIUM
from TIMETABLE, AUDITORIUM
where TIMETABLE.DAY_OF_WEEK = '��' and AUDITORIUM.AUDITORIUM = TIMETABLE.AUDITORIUM);

select TEACHER.TEACHER, TIMETABLE.DAY_OF_WEEK, TIMETABLE.LESSON from TEACHER, TIMETABLE except 
(
select distinct TEACHER .TEACHER_NAME, t.DAY_OF_WEEK, t.LESSON
from TEACHER, TIMETABLE t, TIMETABLE TT
where TEACHER.TEACHER = t.TEACHER and t.DAY_OF_WEEK = TT.DAY_OF_WEEK and t.LESSON != TT.LESSON
);

select distinct GROUPS.IDGROUP, t.DAY_OF_WEEK, TT.LESSON
from GROUPS, TIMETABLE t, TIMETABLE TT
except(
select distinct GROUPS.IDGROUP, t.DAY_OF_WEEK, t.LESSON
from GROUPS, TIMETABLE t, TIMETABLE TT
where GROUPS.IDGROUP = t.IDGROUP and t.DAY_OF_WEEK = TT.DAY_OF_WEEK and t.LESSON != TT.LESSON)