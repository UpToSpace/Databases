--1. С помощью SSMS определить все индексы, которые имеются в БД UNIVER. Определить, какие из них являются кластеризованными, 
--а какие некластеризованными. 
--Создать временную локальную таблицу. Заполнить ее данными. 
--Разработать SELECT-запрос. Получить план запроса и определить его стоимость. 
--Создать кластеризованный индекс, уменьшающий стоимость SELECT-запроса.

exec sp_helpindex 'PULPIT'
exec sp_helpindex 'SUBJECT'	
exec sp_helpindex 'FACULTY'
exec sp_helpindex 'TEACHER'

create table #temp_table
(	some_ind int, 
	some_field varchar(20)
)
SET nocount on;		--не вывод сообщения о вводе строк
DECLARE @i int = 0;
while @i < 100
	begin
		insert #temp_table(some_ind, some_field)
			values(FLOOR(RAND()*10000), REPLICATE('хехе ',3));
		SET @i = @i + 1; 
	end

select * from #temp_table where some_ind between 1500 and 5000 order by some_ind 
	checkpoint;				--фиксация БД
	DBCC DROPCLEANBUFFERS;	--очистить буферный кэш
CREATE clustered index #temp_table_cl on #temp_table(some_ind asc)
drop table #temp_table

--2. Создать временную локальную таблицу. Заполнить ее данными (10000 строк или больше). 
--Разработать SELECT-запрос. Получить план запроса и определить его стоимость. 
--Создать некластеризованный неуникальный составной индекс. 
--Оценить процедуры поиска информации.

CREATE table #EX
(    TKEY int, 
      CC int identity(1, 1),
      TF varchar(100)
);

  set nocount on;           
  declare @i int = 0;
  while   @i < 10000       -- добавление в таблицу 10000 строк
  begin
       INSERT #EX(TKEY, TF) values(floor(30000*RAND()), replicate('строка ', 10));
        set @i = @i + 1; 
  end;
  
  SELECT * from #EX

  CREATE index #EX_NONCLU on #EX(TKEY, CC)
  SELECT count(*)[количество строк] from #EX;

  drop table #EX

--3. Создать временную локальную таблицу. Заполнить ее данными (не менее 10000 строк). 
--Разработать SELECT-запрос. Получить план запроса и определить его стоимость. 
--Создать некластеризованный индекс покрытия, уменьшающий стоимость SELECT-запроса. 

CREATE table #EX
(    TKEY int, 
      CC int identity(1, 1),
      TF varchar(100)
);

  set nocount on;           
  declare @i int = 0;
  while   @i < 10000       -- добавление в таблицу 10000 строк
  begin
       INSERT #EX(TKEY, TF) values(floor(30000*RAND()), replicate('строка ', 10));
        set @i = @i + 1; 
  end;
  
  SELECT CC from #EX where TKEY>15000 

  CREATE  index #EX_TKEY_X on #EX(TKEY) INCLUDE (CC)

  drop table #EX

--4. Создать и заполнить временную локальную таблицу. 
--Разработать SELECT-запрос, получить план запроса и определить его стоимость. 
--Создать некластеризованный фильтруемый индекс, уменьшающий стоимость SELECT-запроса.

CREATE table #EX
(    TKEY int, 
      CC int identity(1, 1),
      TF varchar(100)
);

  set nocount on;           
  declare @i int = 0;
  while   @i < 10000       -- добавление в таблицу 10000 строк
  begin
       INSERT #EX(TKEY, TF) values(floor(30000*RAND()), replicate('строка ', 10));
        set @i = @i + 1; 
  end;

SELECT TKEY from  #EX where TKEY between 5000 and 19999; 
SELECT TKEY from  #EX where TKEY>15000 and  TKEY < 20000  
SELECT TKEY from  #EX where TKEY=17000

CREATE  index #EX_WHERE on #EX(TKEY) where (TKEY>=15000 and 
 TKEY < 20000);  

   drop table #EX

--5. Заполнить временную локальную таблицу. 
--Создать некластеризованный индекс. Оценить уровень фрагментации индекса. 
--Разработать сценарий на T-SQL, выполнение которого приводит к уровню фрагментации индекса выше 90%. 
--Оценить уровень фрагментации индекса. 
--Выполнить процедуру реорганизации индекса, оценить уровень фрагментации. 
--Выполнить процедуру перестройки индекса и оценить уровень фрагментации индекса.

use tempdb
CREATE table #EX
(    TKEY int, 
      CC int identity(1, 1),
      TF varchar(100)
);
set nocount on;
declare @i int = 0;
while @i < 20000 -- добавление в таблицу 20000 строк
begin
INSERT #EX(TKEY, TF) values(floor(30000*RAND()), replicate('строка ', 10));
set @i = @i + 1;
end;

CREATE index #EX_TKEY ON #EX(TKEY); 

INSERT top(10000) #EX(TKEY, TF) select TKEY, TF from #EX;

    SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
        FROM sys.dm_db_index_physical_stats(DB_ID('TEMPDB'), 
        OBJECT_ID('#EX_TKEY'), NULL, NULL, NULL) ss
        JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id WHERE name is not null

ALTER index #EX_TKEY on #EX reorganize;

ALTER index #EX_TKEY on #EX rebuild with (online = off);

  drop table #EX

--6. Разработать пример, демонстрирующий применение параметра FILLFACTOR при создании некластеризованного индекса.

use tempdb
CREATE table #EX
(    TKEY int, 
      CC int identity(1, 1),
      TF varchar(100)
);
set nocount on;
declare @i int = 0;
while @i < 20000 -- добавление в таблицу 20000 строк
begin
INSERT #EX(TKEY, TF) values(floor(30000*RAND()), replicate('строка ', 10));
set @i = @i + 1;
end;

CREATE index #EX_TKEY on #EX(TKEY) with (fillfactor = 65);
INSERT top(50)percent INTO #EX(TKEY, TF) SELECT TKEY, TF FROM #EX;

    SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
        FROM sys.dm_db_index_physical_stats(DB_ID('TEMPDB'), 
        OBJECT_ID('#EX_TKEY'), NULL, NULL, NULL) ss
        JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id WHERE name is not null

  drop table #EX
