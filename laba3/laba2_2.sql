use KOR_MyBase

create table ������
(
��������_������ nvarchar(50) not null unique,
�����_�������_��_������ int,
������� int primary key,
���� int
);

create table ����������
(
���_���������� int primary key,
��������_���������� nvarchar(50),
����� nvarchar(50),
������� nvarchar(50),
������������_������ int foreign key references ������(�������)
);

create table ������
(
���������� nvarchar(50),
�����_����������_������� int,
����_������ date,
�����_������ int primary key,
�������_������ int foreign key references ������(�������)
);

select * from ������;