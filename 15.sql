--1. Разработать сценарий создания XML-документа в режиме PATH из таблицы TEACHER для преподавателей кафедры ИСиТ. 

select PULPIT.FACULTY[факультет], TEACHER.PULPIT[кафедра], TEACHER.TEACHER_NAME[преподаватель]
from TEACHER inner join PULPIT on TEACHER.PULPIT = PULPIT.PULPIT
where TEACHER.PULPIT = 'ИСиТ' for xml path, root('Преподаватели_ИСиТ');

--2. Разработать сценарий создания XML-документа в режиме AUTO на основе SELECT-запроса к таблицам AUDITORIUM и 
--AUDITORIUM_TYPE, который содержит следующие столбцы: наименование аудитории, наименование типа аудитории и вместимость. 
--Найти только лекционные аудитории. 

select AUDITORIUM.AUDITORIUM [Аудитория], AUDITORIUM.AUDITORIUM_TYPE [Тип],AUDITORIUM.AUDITORIUM_CAPACITY [Вместимость] 
from AUDITORIUM join AUDITORIUM_TYPE on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
where AUDITORIUM.AUDITORIUM_TYPE = 'ЛК' for xml AUTO, root('Список');

--3. Разработать XML-документ, содержащий данные о трех новых учебных дисциплинах, которые следует добавить в таблицу SUBJECT. 
--Разработать сценарий, извлекающий данные о дисциплинах из XML-документа и добавляющий их в таблицу SUBJECT. 
--При этом применить системную функцию OPENXML и конструкцию INSERT… SELECT. 

declare @h int = 0,
@sbj varchar(3000) = '<?xml version="1.0" encoding="windows-1251" ?>
                      <дисциплины>
					     <дисциплина код="КЯР" название="Компьютерные языки разметки" кафедра="ИСиТ" />
						 <дисциплина код="ЯП" название="Языки программирования" кафедра="ИСиТ" />
						 <дисциплина код="КСиС" название="Компьютерные системы" кафедра="ИСиТ" />
					  </дисциплины>';
exec sp_xml_preparedocument @h output, @sbj;
insert SUBJECT select [код], [название], [кафедра] from openxml(@h, '/дисциплины/дисциплина',0)
with([код] char(10), [название] varchar(100), [кафедра] char(20));

select * from SUBJECT where SUBJECT.PULPIT = 'ИСиТ'


--4. Используя таблицу STUDENT разработать XML-структуру, содержащую паспортные данные студента: серию и номер паспорта,
--личный номер, дата выдачи и адрес прописки. 
--Разработать сценарий, в который включен оператор INSERT, добавляющий строку с XML-столбцом.
--Включить в этот же сценарий оператор UPDATE, изменяющий столбец INFO у одной строки таблицы
--STUDENT и оператор SELECT, формирующий результирующий набор, аналогичный представленному на рисунке. 
--В SELECT-запросе использовать методы QUERY и VALUEXML-типа.

 insert into STUDENT(IDGROUP, NAME, BDAY, INFO)
values(4, 'Человек 1. 1.', '2001-12-10',
	'<студент>
		<паспорт серия="ГР" номер="4133033" дата="2013-04-19" />
		<телефон>+375291234567</телефон>
		<адрес>
			<страна>Беларусь</страна>
			<город>Гродно</город>
			<улица>Советская</улица>
			<дом>10</дом>
			<квартира>10</квартира>
		</адрес>
	</студент>');

select * from STUDENT where NAME = 'Человек 1. 1.';

update STUDENT set INFO = 
	'<студент>
		<паспорт серия="ГР" номер="4133033" дата="19.04.2013" />
		<телефон>+375291234567</телефон>
		<адрес>
			<страна>Беларусь</страна>
			<город>Гомель</город>
			<улица>Советская</улица>
			<дом>10</дом>
			<квартира>10</квартира>
		</адрес>
	</студент>' where NAME='Человек 1. 1.'

select NAME[ФИО], INFO.value('(студент/паспорт/@серия)[1]', 'char(2)')[Серия паспорта],
INFO.value('(студент/паспорт/@номер)[1]', 'varchar(20)')[Номер паспорта], 
INFO.query('/студент/адрес')[Адрес]
from  STUDENT where NAME = 'Человек 1. 1.';  

--5. Изменить (ALTER TABLE) таблицу STUDENT в базе данных UNIVER таким образом, чтобы 
--значения типизированного столбца с именем INFO контролировались коллекцией XML-схем (XML SCHEMACOLLECTION),
--представленной в правой части. 
--Разработать сценарии, демонстрирующие ввод и корректировку данных (операторы INSERT и UPDATE)
--в столбец INFO таблицы STUDENT, как содержащие ошибки, так и правильные.
--Разработать другую XML-схему и добавить ее в коллекцию XML-схем в БД UNIVER.

create xml schema collection Student as 
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
   elementFormDefault="qualified"
   xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xs:element name="студент">
<xs:complexType><xs:sequence>
<xs:element name="паспорт" maxOccurs="1" minOccurs="1">
  <xs:complexType>
    <xs:attribute name="серия" type="xs:string" use="required" />
    <xs:attribute name="номер" type="xs:unsignedInt" use="required"/>
    <xs:attribute name="дата"  use="required">
	<xs:simpleType>  <xs:restriction base ="xs:string">
		<xs:pattern value="[0-9]{2}.[0-9]{2}.[0-9]{4}"/>
	 </xs:restriction> 	</xs:simpleType>
     </xs:attribute>
  </xs:complexType>
</xs:element>
<xs:element maxOccurs="10" name="телефон" type="xs:string"/>
<xs:element name="адрес">   <xs:complexType><xs:sequence>
   <xs:element name="страна" type="xs:string" />
   <xs:element name="город" type="xs:string" />
   <xs:element name="улица" type="xs:string" />
   <xs:element name="дом" type="xs:string" />
   <xs:element name="квартира" type="xs:string" />
</xs:sequence></xs:complexType>  </xs:element>
</xs:sequence></xs:complexType>
</xs:element></xs:schema>';

alter table STUDENT alter column INFO xml(Student);

drop XML SCHEMA COLLECTION Student;

select Name, INFO from STUDENT where NAME='Человек 1. 1.'

delete from STUDENT where NAME = 'Человек 1. 1.'
