--1. ����������� �������� �������� XML-��������� � ������ PATH �� ������� TEACHER ��� �������������� ������� ����. 

select PULPIT.FACULTY[���������], TEACHER.PULPIT[�������], TEACHER.TEACHER_NAME[�������������]
from TEACHER inner join PULPIT on TEACHER.PULPIT = PULPIT.PULPIT
where TEACHER.PULPIT = '����' for xml path, root('�������������_����');

--2. ����������� �������� �������� XML-��������� � ������ AUTO �� ������ SELECT-������� � �������� AUDITORIUM � 
--AUDITORIUM_TYPE, ������� �������� ��������� �������: ������������ ���������, ������������ ���� ��������� � �����������. 
--����� ������ ���������� ���������. 

select AUDITORIUM.AUDITORIUM [���������], AUDITORIUM.AUDITORIUM_TYPE [���],AUDITORIUM.AUDITORIUM_CAPACITY [�����������] 
from AUDITORIUM join AUDITORIUM_TYPE on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
where AUDITORIUM.AUDITORIUM_TYPE = '��' for xml AUTO, root('������');

--3. ����������� XML-��������, ���������� ������ � ���� ����� ������� �����������, ������� ������� �������� � ������� SUBJECT. 
--����������� ��������, ����������� ������ � ����������� �� XML-��������� � ����������� �� � ������� SUBJECT. 
--��� ���� ��������� ��������� ������� OPENXML � ����������� INSERT� SELECT. 

declare @h int = 0,
@sbj varchar(3000) = '<?xml version="1.0" encoding="windows-1251" ?>
                      <����������>
					     <���������� ���="���" ��������="������������ ����� ��������" �������="����" />
						 <���������� ���="��" ��������="����� ����������������" �������="����" />
						 <���������� ���="����" ��������="������������ �������" �������="����" />
					  </����������>';
exec sp_xml_preparedocument @h output, @sbj;
insert SUBJECT select [���], [��������], [�������] from openxml(@h, '/����������/����������',0)
with([���] char(10), [��������] varchar(100), [�������] char(20));

select * from SUBJECT where SUBJECT.PULPIT = '����'


--4. ��������� ������� STUDENT ����������� XML-���������, ���������� ���������� ������ ��������: ����� � ����� ��������,
--������ �����, ���� ������ � ����� ��������. 
--����������� ��������, � ������� ������� �������� INSERT, ����������� ������ � XML-��������.
--�������� � ���� �� �������� �������� UPDATE, ���������� ������� INFO � ����� ������ �������
--STUDENT � �������� SELECT, ����������� �������������� �����, ����������� ��������������� �� �������. 
--� SELECT-������� ������������ ������ QUERY � VALUEXML-����.

 insert into STUDENT(IDGROUP, NAME, BDAY, INFO)
values(4, '������� 1. 1.', '2001-12-10',
	'<�������>
		<������� �����="��" �����="4133033" ����="2013-04-19" />
		<�������>+375291234567</�������>
		<�����>
			<������>��������</������>
			<�����>������</�����>
			<�����>���������</�����>
			<���>10</���>
			<��������>10</��������>
		</�����>
	</�������>');

select * from STUDENT where NAME = '������� 1. 1.';

update STUDENT set INFO = 
	'<�������>
		<������� �����="��" �����="4133033" ����="19.04.2013" />
		<�������>+375291234567</�������>
		<�����>
			<������>��������</������>
			<�����>������</�����>
			<�����>���������</�����>
			<���>10</���>
			<��������>10</��������>
		</�����>
	</�������>' where NAME='������� 1. 1.'

select NAME[���], INFO.value('(�������/�������/@�����)[1]', 'char(2)')[����� ��������],
INFO.value('(�������/�������/@�����)[1]', 'varchar(20)')[����� ��������], 
INFO.query('/�������/�����')[�����]
from  STUDENT where NAME = '������� 1. 1.';  

--5. �������� (ALTER TABLE) ������� STUDENT � ���� ������ UNIVER ����� �������, ����� 
--�������� ��������������� ������� � ������ INFO ���������������� ���������� XML-���� (XML SCHEMACOLLECTION),
--�������������� � ������ �����. 
--����������� ��������, ��������������� ���� � ������������� ������ (��������� INSERT � UPDATE)
--� ������� INFO ������� STUDENT, ��� ���������� ������, ��� � ����������.
--����������� ������ XML-����� � �������� �� � ��������� XML-���� � �� UNIVER.

create xml schema collection Student as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
   elementFormDefault="qualified"
   xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xs:element name="�������">
<xs:complexType><xs:sequence>
<xs:element name="�������" maxOccurs="1" minOccurs="1">
  <xs:complexType>
    <xs:attribute name="�����" type="xs:string" use="required" />
    <xs:attribute name="�����" type="xs:unsignedInt" use="required"/>
    <xs:attribute name="����"  use="required">
	<xs:simpleType>  <xs:restriction base ="xs:string">
		<xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
	 </xs:restriction> 	</xs:simpleType>
     </xs:attribute>
  </xs:complexType>
</xs:element>
<xs:element maxOccurs="10" name="�������" type="xs:string"/>
<xs:element name="�����">   <xs:complexType><xs:sequence>
   <xs:element name="������" type="xs:string" />
   <xs:element name="�����" type="xs:string" />
   <xs:element name="�����" type="xs:string" />
   <xs:element name="���" type="xs:string" />
   <xs:element name="��������" type="xs:string" />
</xs:sequence></xs:complexType>  </xs:element>
</xs:sequence></xs:complexType>
</xs:element></xs:schema>';

alter table STUDENT alter column INFO xml(Student);

drop XML SCHEMA COLLECTION Student;

select Name, INFO from STUDENT where NAME='������� 1. 1.'

delete from STUDENT where NAME = '������� 1. 1.'
