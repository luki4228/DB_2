use AdventureWorks2012;
go
/*
a) Добавление поля PersonName 
*/
alter table dbo.Address 
	add PersonName nvarchar(100);
go
/*
b) Создание и заполнение табличной переменной со структурой dbo.Address 
*/
declare @AddressTemp table (
	AddressID int not null,
	AddressLine1 nvarchar(60) null,
	AddressLine2 nvarchar(60) not null,
	City nvarchar(30) null,
	StateProvinceID int null,
	PostalCode nvarchar(15) null,
	ModifiedDate datetime null,
	ID int identity(1,1) UNIQUE not null,
	PersonName nvarchar(100) null
);

insert into @AddressTemp
	(AddressID,
	AddressLine1,	
	AddressLine2,
	City,
	StateProvinceID,
	PostalCode,
	ModifiedDate)
select 
	AddressID,
	AddressLine1,
	(CONCAT(
		(select 
			CR.CountryRegionCode 
		from 
			Person.CountryRegion as CR inner join Person.StateProvince as SP 
		on 
			CR.CountryRegionCode = SP.CountryRegionCode inner join Person.Address as AD
		on 
			SP.StateProvinceID = AD.StateProvinceID
		where 
			AD.AddressID = A.AddressID),', ', 
		(select 
			SP.Name 
		from 
			Person.StateProvince as SP inner join Person.Address as AD 
		on 
			SP.StateProvinceID = AD.StateProvinceID
		where 
			AD.AddressID = A.AddressID), ', ', 
		City)),
	City,
	StateProvinceID,
	PostalCode,
	ModifiedDate
from 
	dbo.Address as A
where 
	StateProvinceID = 77;
/*
с) Обновление данных в dbo.Address
*/
update dbo.Address
set 
	AddressLine2 = AT.AddressLine2 
from 
	@AddressTemp as AT;

update dbo.Address 
set 
	PersonName = P.FirstName + ' ' + P.LastName 
from 
	Person.Person as P inner join Person.BusinessEntityAddress as B 
on 
	B.BusinessEntityID = P.BusinessEntityID 
where 
	B.AddressID = dbo.Address.AddressID;

/*
d) Удаление данных 
*/
delete dbo.Address 
from 
	dbo.Address as A inner join Person.BusinessEntityAddress as B
on
	A.AddressID = B.AddressID inner join Person.AddressType as AT
on
	B.AddressTypeID = AT.AddressTypeID
where 
	AT.Name = 'Main Office';

select * from dbo.Address

SELECT *
FROM AdventureWorks2012.INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Address';

/*
e) Удаление ограничений 
*/
alter table dbo.Address drop column PersonName;
alter table dbo.Address drop constraint PK__Address__091C2A1BC3154996
alter table dbo.Address drop constraint UQ__Address__3214EC2661E443AC
alter table dbo.Address drop constraint ChkRemainder
alter table dbo.Address drop constraint dfltValue
/*
f) Удаление таблицы  
*/
drop table dbo.Address