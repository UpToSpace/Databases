use master
create database KOR_MyBase
on primary
(name = 'KOR_MyBase_mdf', filename = 'D:\University\4\bd\KOR_MyBase_mdf.mdf', size = 10240Kb, maxsize = unlimited, filegrowth = 1024Kb),
filegroup fg1
(name = 'KOR_MyBase_fg1_1', filename = 'D:\University\4\bd\KOR_MyBase_fg1_1.ndf', size = 10240Kb, maxsize=1Gb, filegrowth=25%)
log on
(name = 'KOR_MyBase_log', filename = 'D:\University\4\bd\KOR_MyBase_log.ldf', size = 10240Kb, maxsize =2048gb, filegrowth = 10%),



use KOR_MyBase

create table ������
(
��������_������ nvarchar(50) not null unique,
�����_�������_��_������ int,
������� int primary key,
���� int
) on fg1;