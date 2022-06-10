use KOR_MyBase

create table Детали
(
Название_детали nvarchar(50) not null unique,
Колво_деталей_на_складе int,
Артикул int primary key,
Цена int
);

create table Поставщики
(
Код_поставщика int primary key,
Название_поставщика nvarchar(50),
Адрес nvarchar(50),
Телефон nvarchar(50),
Поставляемая_деталь int foreign key references Детали(Артикул)
);

create table Заказы
(
Примечание nvarchar(50),
Колво_заказанных_деталей int,
Дата_заказа date,
Номер_заказа int primary key,
Артикул_детали int foreign key references Детали(Артикул)
);

select * from Заказы;