--�� ������ ������� AUDITORIUM ������������ ������ ��������� ����� ������� ������������
--(������� AUDITORIUM_CAPACITY) ��� ������� ���� ��������� (AUDITORIUM_TYPE). 
--��� ���� ��������� ������� ������������� � ������� �������� �����������. 
--����������: ������������ ������������� ��������� c �������� TOP � ORDER BY.

select AUDITORIUM from AUDITORIUM a
where AUDITORIUM_CAPACITY = 
(select top(1) AUDITORIUM_CAPACITY from AUDITORIUM aa
where a.AUDITORIUM_TYPE = aa.AUDITORIUM_TYPE order by AUDITORIUM_CAPACITY desc)
