--На основе таблицы AUDITORIUM сформировать список аудиторий самых больших вместимостей
--(столбец AUDITORIUM_CAPACITY) для каждого типа аудитории (AUDITORIUM_TYPE). 
--При этом результат следует отсортировать в порядке убывания вместимости. 
--Примечание: использовать коррелируемый подзапрос c секциями TOP и ORDER BY.

select AUDITORIUM from AUDITORIUM a
where AUDITORIUM_CAPACITY = 
(select top(1) AUDITORIUM_CAPACITY from AUDITORIUM aa
where a.AUDITORIUM_TYPE = aa.AUDITORIUM_TYPE order by AUDITORIUM_CAPACITY desc)
