select PULPIT.PULPIT_NAME from PULPIT inner join FACULTY
on PULPIT.FACULTY = FACULTY.FACULTY
where PULPIT.FACULTY in 
(select PROFESSION.FACULTY from PROFESSION 
where PROFESSION.PROFESSION_NAME like '%технология%' or PROFESSION.PROFESSION_NAME like '%технологии%')
