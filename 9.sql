--1. � ������� SSMS ���������� ��� �������, ������� ������� � �� UNIVER. ����������, ����� �� ��� �������� �����������������, 
--� ����� �������������������. 
--������� ��������� ��������� �������. ��������� �� �������. 
--����������� SELECT-������. �������� ���� ������� � ���������� ��� ���������. 
--������� ���������������� ������, ����������� ��������� SELECT-�������.

exec sp_helpindex 'PULPIT'
exec sp_helpindex 'SUBJECT'	
exec sp_helpindex 'FACULTY'
exec sp_helpindex 'TEACHER'

create table #temp_table
(	some_ind int, 
	some_field varchar(20)
)
SET nocount on;		--�� ����� ��������� � ����� �����
DECLARE @i int = 0;
while @i < 100
	begin
		insert #temp_table(some_ind, some_field)
			values(FLOOR(RAND()*10000), REPLICATE('���� ',3));
		SET @i = @i + 1; 
	end

select * from #temp_table where some_ind between 1500 and 5000 order by some_ind 
	checkpoint;				--�������� ��
	DBCC DROPCLEANBUFFERS;	--�������� �������� ���
CREATE clustered index #temp_table_cl on #temp_table(some_ind asc)
drop table #temp_table

--2. ������� ��������� ��������� �������. ��������� �� ������� (10000 ����� ��� ������). 
--����������� SELECT-������. �������� ���� ������� � ���������� ��� ���������. 
--������� ������������������ ������������ ��������� ������. 
--������� ��������� ������ ����������.

CREATE table #EX
(    TKEY int, 
      CC int identity(1, 1),
      TF varchar(100)
);

  set nocount on;           
  declare @i int = 0;
  while   @i < 10000       -- ���������� � ������� 10000 �����
  begin
       INSERT #EX(TKEY, TF) values(floor(30000*RAND()), replicate('������ ', 10));
        set @i = @i + 1; 
  end;
  
  SELECT * from #EX

  CREATE index #EX_NONCLU on #EX(TKEY, CC)
  SELECT count(*)[���������� �����] from #EX;

  drop table #EX

--3. ������� ��������� ��������� �������. ��������� �� ������� (�� ����� 10000 �����). 
--����������� SELECT-������. �������� ���� ������� � ���������� ��� ���������. 
--������� ������������������ ������ ��������, ����������� ��������� SELECT-�������. 

CREATE table #EX
(    TKEY int, 
      CC int identity(1, 1),
      TF varchar(100)
);

  set nocount on;           
  declare @i int = 0;
  while   @i < 10000       -- ���������� � ������� 10000 �����
  begin
       INSERT #EX(TKEY, TF) values(floor(30000*RAND()), replicate('������ ', 10));
        set @i = @i + 1; 
  end;
  
  SELECT CC from #EX where TKEY>15000 

  CREATE  index #EX_TKEY_X on #EX(TKEY) INCLUDE (CC)

  drop table #EX

--4. ������� � ��������� ��������� ��������� �������. 
--����������� SELECT-������, �������� ���� ������� � ���������� ��� ���������. 
--������� ������������������ ����������� ������, ����������� ��������� SELECT-�������.

CREATE table #EX
(    TKEY int, 
      CC int identity(1, 1),
      TF varchar(100)
);

  set nocount on;           
  declare @i int = 0;
  while   @i < 10000       -- ���������� � ������� 10000 �����
  begin
       INSERT #EX(TKEY, TF) values(floor(30000*RAND()), replicate('������ ', 10));
        set @i = @i + 1; 
  end;

SELECT TKEY from  #EX where TKEY between 5000 and 19999; 
SELECT TKEY from  #EX where TKEY>15000 and  TKEY < 20000  
SELECT TKEY from  #EX where TKEY=17000

CREATE  index #EX_WHERE on #EX(TKEY) where (TKEY>=15000 and 
 TKEY < 20000);  

   drop table #EX

--5. ��������� ��������� ��������� �������. 
--������� ������������������ ������. ������� ������� ������������ �������. 
--����������� �������� �� T-SQL, ���������� �������� �������� � ������ ������������ ������� ���� 90%. 
--������� ������� ������������ �������. 
--��������� ��������� ������������� �������, ������� ������� ������������. 
--��������� ��������� ����������� ������� � ������� ������� ������������ �������.

use tempdb
CREATE table #EX
(    TKEY int, 
      CC int identity(1, 1),
      TF varchar(100)
);
set nocount on;
declare @i int = 0;
while @i < 20000 -- ���������� � ������� 20000 �����
begin
INSERT #EX(TKEY, TF) values(floor(30000*RAND()), replicate('������ ', 10));
set @i = @i + 1;
end;

CREATE index #EX_TKEY ON #EX(TKEY); 

INSERT top(10000) #EX(TKEY, TF) select TKEY, TF from #EX;

    SELECT name [������], avg_fragmentation_in_percent [������������ (%)]
        FROM sys.dm_db_index_physical_stats(DB_ID('TEMPDB'), 
        OBJECT_ID('#EX_TKEY'), NULL, NULL, NULL) ss
        JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id WHERE name is not null

ALTER index #EX_TKEY on #EX reorganize;

ALTER index #EX_TKEY on #EX rebuild with (online = off);

  drop table #EX

--6. ����������� ������, ��������������� ���������� ��������� FILLFACTOR ��� �������� ������������������� �������.

use tempdb
CREATE table #EX
(    TKEY int, 
      CC int identity(1, 1),
      TF varchar(100)
);
set nocount on;
declare @i int = 0;
while @i < 20000 -- ���������� � ������� 20000 �����
begin
INSERT #EX(TKEY, TF) values(floor(30000*RAND()), replicate('������ ', 10));
set @i = @i + 1;
end;

CREATE index #EX_TKEY on #EX(TKEY) with (fillfactor = 65);
INSERT top(50)percent INTO #EX(TKEY, TF) SELECT TKEY, TF FROM #EX;

    SELECT name [������], avg_fragmentation_in_percent [������������ (%)]
        FROM sys.dm_db_index_physical_stats(DB_ID('TEMPDB'), 
        OBJECT_ID('#EX_TKEY'), NULL, NULL, NULL) ss
        JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id WHERE name is not null

  drop table #EX
