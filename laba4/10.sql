
--with inner join
select * from ������ inner join ������
on ������.�������_������ = ������.�������

select * from ������ inner join ������
on ������.�������_������ = ������.������� and ��������_������ like '%�%'

--without inner join
select * from ������, ������
where ������.�������_������ = ������.�������

select * from ������, ������
where ������.�������_������ = ������.������� and ��������_������ like '%�%'

-- cases
select *,
case 
when (�����_�������_��_������ > 30) then 'a lot'
when (�����_�������_��_������ <= 30) then 'a few'
end 
from ������ inner join ������
on ������.�������_������ = ������.�������

-- with sort
select *,
case 
when (�����_�������_��_������ > 30) then 'a lot'
when (�����_�������_��_������ <= 30) then 'a few'
end 
from ������ inner join ������
on ������.�������_������ = ������.�������
order by ������� 
 -- left outer join
select ��������_������, isnull(���_����������, '0') [���_����������] from ������ left outer join ����������
on ������.������� = ����������.������������_������

--right outer join
select * from ������ right outer join ����������
on ������.������� = ����������.������������_������

--full outer join
select * from ������ full outer join ����������
on ������.������� = ����������.������������_������

--cross join
select * from ������ cross join ����������

