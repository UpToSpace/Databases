--Создать таблицу TIMETABLE (Группа, аудитория, предмет, преподаватель, день недели, пара),
--установить связи с другими таблицами, заполнить данными.
--Написать запросы на наличие свободных аудиторий на определенную пару, 
--на определенный день недели, наличие «окон» у преподавателей и в группах.

use UNIVER
create table TIMETABLE(
DAY_OF_WEEK char(2) check (DAY_OF_WEEK in('пн', 'вт', 'ср', 'чт', 'пт', 'сб')),
LESSON int check(LESSON between 1 and 4),
TEACHER char(10) constraint TIMETABLE_TEACHER_FK  foreign key references TEACHER(TEACHER),
AUDITORIUM char(20) constraint TIMETABLE_AUDITORIUM_FK foreign key references AUDITORIUM(AUDITORIUM),
SUBJECT char(10) constraint TIMETABLE_SUBJECT_FK  foreign key references SUBJECT(SUBJECT),
IDGROUP int constraint TIMETABLE_GROUP_FK  foreign key references GROUPS(IDGROUP)
)
insert into TIMETABLE values
('пн', 1, 'СМЛВ', '313-1', 'СУБД', 15),
('пн', 2, 'СМЛВ', '313-1', 'ОАиП', 4),
('вт', 3, 'СМЛВ', '313-1', 'ОАиП', 11),
('вт', 1, 'МРЗ', '324-1', 'СУБД', 6),
('ср', 3, 'УРБ', '324-1', 'ПИС', 4),
('ср', 1, 'УРБ', '206-1', 'ПИС', 10),
('чт', 4, 'СМЛВ', '206-1', 'ОАиП', 3),
('чт', 1, 'БРКВЧ', '301-1', 'СУБД', 7),
('пт', 4, 'БРКВЧ', '301-1', 'ОАиП', 7),
('пт', 2, 'БРКВЧ', '413-1', 'СУБД', 8),
('сб', 2, 'ДТК', '423-1', 'СУБД', 7)

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
where TIMETABLE.DAY_OF_WEEK = 'пт' and AUDITORIUM.AUDITORIUM = TIMETABLE.AUDITORIUM);

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