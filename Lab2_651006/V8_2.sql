use AdventureWorks2012;
go
/*
a) Создание таблицы со структурой Person.Address
*/
create table dbo.Address (
	AddressID int,
	AddressLine1 nvarchar(60),
	AddressLine2 nvarchar(60),
	City nvarchar(30),
	StateProvinceID int,
	PostalCode nvarchar(15),
	ModifiedDate datetime,
	PRIMARY KEY (AddressID)
);
go
/*
b) Добавление поля ID
*/
alter table dbo.Address 
	add ID int identity(1,1) UNIQUE;
go
/*
с) Добавление ограничения на поле StateProvince(вставка только нечетных чисел)
*/
alter table dbo.Address 
	add constraint ChkRemainder check((StateProvinceID % 2) = 1);
go
/*
d) Добавление ограничения на поле AddressLine2(Default 'Unknown')
*/
alter table dbo.Address 
	add constraint dfltValue 
	default 'Unknown' for AddressLine2;
go
/*
e) Заполнение таблицы
*/
insert into dbo.Address 
	(A.AddressID,
	A.AddressLine1,	
	A.City,
	A.StateProvinceID,
	A.PostalCode,
	A.ModifiedDate)
select 
	A.AddressID,
	A.AddressLine1,	
	A.City,
	A.StateProvinceID,
	A.PostalCode,
	A.ModifiedDate 
from 
	Person.Address as A inner join Person.StateProvince as S
on 
	A.StateProvinceID = S.StateProvinceID inner join Person.CountryRegion as C
on 
	S.CountryRegionCode = C.CountryRegionCode and C.Name like 'a%' and (A.StateProvinceID % 2) = 1;
go
/*
f) Добавление ограничения на поле AddressLine2 (not null)
*/
alter table dbo.Address 
	alter column AddressLine2 nvarchar(60) not null;

select * from dbo.Address
