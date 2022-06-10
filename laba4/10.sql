
--with inner join
select * from Заказы inner join Детали
on Заказы.Артикул_детали = Детали.Артикул

select * from Заказы inner join Детали
on Заказы.Артикул_детали = Детали.Артикул and Название_детали like '%а%'

--without inner join
select * from Заказы, Детали
where Заказы.Артикул_детали = Детали.Артикул

select * from Заказы, Детали
where Заказы.Артикул_детали = Детали.Артикул and Название_детали like '%а%'

-- cases
select *,
case 
when (Колво_деталей_на_складе > 30) then 'a lot'
when (Колво_деталей_на_складе <= 30) then 'a few'
end 
from Заказы inner join Детали
on Заказы.Артикул_детали = Детали.Артикул

-- with sort
select *,
case 
when (Колво_деталей_на_складе > 30) then 'a lot'
when (Колво_деталей_на_складе <= 30) then 'a few'
end 
from Заказы inner join Детали
on Заказы.Артикул_детали = Детали.Артикул
order by Артикул 
 -- left outer join
select Название_детали, isnull(Код_поставщика, '0') [Код_поставщика] from Детали left outer join Поставщики
on Детали.Артикул = Поставщики.Поставляемая_деталь

--right outer join
select * from Детали right outer join Поставщики
on Детали.Артикул = Поставщики.Поставляемая_деталь

--full outer join
select * from Детали full outer join Поставщики
on Детали.Артикул = Поставщики.Поставляемая_деталь

--cross join
select * from Детали cross join Поставщики

