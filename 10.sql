--1. Разработать сценарий, формиру-ющий список дисциплин на кафедре ИСиТ. В отчет должны быть выведены краткие названия
--(поле SUBJECT) из таблицы SUBJECT в одну строку через запятую. 
--Использовать встроенную функцию RTRIM.

DECLARE cur CURSOR
	for SELECT SUBJECT from SUBJECT
	where SUBJECT.PULPIT='ИСиТ'; 

DECLARE @sub char(4),
		@str char(100)=' '; 
OPEN cur;  
	fetch  cur into @sub;    
	print   'ИСиТ:';   
	while @@fetch_status = 0                                   
	begin 
		set @str = rtrim(@sub)+', '+@str;      
		fetch  cur into @sub; 
	end;   
    print @str;        
CLOSE  cur;

deallocate cur;

--2. Разработать сценарий, демон-стрирующий отличие глобального
--курсора от локального на примере ба-зы данных X_UNIVER.

DECLARE cur CURSOR LOCAL                            
	             for SELECT SUBJECT, PULPIT from SUBJECT;
DECLARE @sub char(20), @pul char(20);      
	OPEN cur;	  
	fetch  cur into @sub, @pul; 	
      print '1. '+@sub+@pul;   
      go

 DECLARE @sub char(20), @pul char(20);     	
	fetch  cur into @sub, @pul; 	
      print '2. '+@sub+@pul;  
  go   



  DECLARE cur CURSOR GLOBAL                            
	             for SELECT SUBJECT, PULPIT from SUBJECT;
DECLARE @sub char(20), @pul char(20);      
	OPEN cur;	  
	fetch  cur into @sub, @pul; 	
      print '1. '+@sub+@pul;   
      go

 DECLARE @sub char(20), @pul char(20);     	
	fetch  cur into @sub, @pul; 	
      print '2. '+@sub+@pul;  
  go   


  deallocate cur;

--3. Разработать сценарий, демон-стрирующий отличие статических 
--курсоров от динамических на примере базы данных X_UNIVER.

DECLARE @tid char(10), @tnm char(40), @tgn char(1);  
	DECLARE Zakaz CURSOR LOCAL STATIC                              
		 for SELECT *
		       FROM dbo.SUBJECT where PULPIT = 'ИСиТ';				   
	open Zakaz;
	print   'Количество строк : '+cast(@@CURSOR_ROWS as varchar(5)); 
    	UPDATE SUBJECT set SUBJECT_NAME = 'мое название' where SUBJECT = 'ОАиП';
	FETCH  Zakaz into @tid, @tnm, @tgn;     
	while @@fetch_status = 0                                    
      begin 
          print @tid + ' '+ @tnm + ' '+ @tgn;      
          fetch Zakaz into @tid, @tnm, @tgn; 
       end;          
   CLOSE  Zakaz;


   DECLARE @tid char(10), @tnm char(40), @tgn char(1);  
	DECLARE Zakaz CURSOR LOCAL DYNAMIC                              
		 for SELECT *
		       FROM dbo.SUBJECT where PULPIT = 'ИСиТ';				   
	open Zakaz;
	print   'Количество строк : '+cast(@@CURSOR_ROWS as varchar(5)); 
    	UPDATE SUBJECT set SUBJECT_NAME = 'мое название' where SUBJECT = 'ОАиП';
	FETCH  Zakaz into @tid, @tnm, @tgn;     
	while @@fetch_status = 0                                    
      begin 
          print @tid + ' '+ @tnm + ' '+ @tgn;      
          fetch Zakaz into @tid, @tnm, @tgn; 
       end;          
   CLOSE  Zakaz;

   --Основы алгоритмизации и программирования

--4. Разработать сценарий, демон-стрирующий свойства навигации в ре-зультирующем
--наборе курсора с атри-бутом SCROLL на примере базы дан-ных X_UNIVER.
--Использовать все известные ключе-вые слова в операторе FETCH.

DECLARE  @t int, @rn char(50);  

DECLARE cur CURSOR LOCAL DYNAMIC SCROLL for 
		SELECT row_number() over (order by NAME), NAME from STUDENT where IDGROUP = 6 
OPEN cur;
	fetch FIRST from cur into  @t, @rn;                 
		print 'first: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn);
	fetch NEXT from cur into  @t, @rn;                 
		print 'next: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn);      
	fetch LAST from  cur into @t, @rn;       
		print 'last: ' +  cast(@t as varchar(3))+ ' '+rtrim(@rn);   
	fetch PRIOR from cur into  @t, @rn;         
		print 'prior: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn); 
	fetch ABSOLUTE 1 from cur into  @t, @rn;               
		print 'absolute: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn); 
	fetch RELATIVE 2 from cur into  @t, @rn;            
		print 'relative: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn);         
CLOSE cur;

--5. Создать курсор, демонстрирую-щий применение конструкции CUR-RENT OF в секции WHERE
--с исполь-зованием операторов UPDATE и DE-LETE.

INSERT FACULTY(FACULTY,FACULTY_NAME) VALUES ('FIT','Faculty of IT'); 

DECLARE cur CURSOR LOCAL SCROLL DYNAMIC
	for select f.FACULTY from FACULTY f 
	FOR UPDATE; 

DECLARE @s nvarchar(5); 
OPEN cur 
	fetch FIRST from cur into @s; 
	update FACULTY set FACULTY = 'theFIT' where current of cur; 
	fetch FIRST from cur into @s; 
	--delete FACULTY where current of cur; 
GO 

select * from FACULTY

--6. Разработать SELECT-запрос, с помощью которого из таблицы PRO-GRESS удаляются строки, содержащие
--информацию о студентах, получивших оценки ниже 4 (использовать объеди-нение таблиц PROGRESS, STUDENT, GROUPS). 

DECLARE @name3 nvarchar(20), @n int;  

DECLARE cur CURSOR LOCAL for 
SELECT NAME, NOTE from PROGRESS join STUDENT 
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		where NOTE<5

OPEN cur;  
    fetch  cur into @name3, @n;  
	while @@fetch_status = 0
	begin 		
		delete PROGRESS where CURRENT OF cur;	
		fetch  cur into @name3, @n;  
	end
CLOSE cur;

--Разработать SELECT-запрос, с по-мощью которого в таблице PROGRESS для студента с конкретным номером 
--IDSTUDENT корректируется оценка (увеличивается на единицу).

DECLARE @name4 char(20), @n3 int;  

DECLARE cur CURSOR LOCAL for 
SELECT NAME, NOTE from PROGRESS join STUDENT
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		where PROGRESS.IDSTUDENT=1022
OPEN cur;  
    fetch  cur into @name4, @n3; 
    UPDATE PROGRESS set NOTE=NOTE+1 where CURRENT OF cur;
CLOSE cur;

SELECT NAME, NOTE from PROGRESS join STUDENT
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT 
		where PROGRESS.IDSTUDENT=1022