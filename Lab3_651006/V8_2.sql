use AdventureWorks2012;
go
/*
a) Добавление новых полей в dbo.Address
*/
alter table dbo.Address
	add AccountNumber nvarchar(15),
	MaxPrice money,
	AccountID as 'ID' + AccountNumber;
go
/*
b) Создание временной таблицы 
*/

create table dbo.#Address(
	AddressID int not null,
	AddressLine1 nvarchar(60),
	AddressLine2 nvarchar(60) not null ,
	City nvarchar(30),
	StateProvinceID int,
	PostalCode nvarchar(15),
	ModifiedDate datetime,
	ID int identity(1, 1) primary key,
	AccountNumber nvarchar(15),
	MaxPrice money
);
/*
c) Заполнение времменной таблицы
*/
with Address_CTE 
as
(select
	A.AddressID,
	A.AddressLine1,
	A.AddressLine2,	
	A.City,
	A.StateProvinceID,
	A.PostalCode,
	A.ModifiedDate,
	(select 
		AccountNumber
	from 
		Purchasing.Vendor as V inner join Person.BusinessEntityAddress as B
	on
		V.BusinessEntityID = B.BusinessEntityID	
	where 
		A.AddressID = B.AddressID) as AccountNumber,
	(select 
		MAX(StandardPrice) 
	from 
		Purchasing.ProductVendor as V inner join Person.BusinessEntityAddress as B
	on
		V.BusinessEntityID = B.BusinessEntityID	
	group by 
		V.BusinessEntityID, B.AddressID
	having 
		AddressID = A.AddressID) as MaxPrice
from 
	dbo.Address as A)

insert into dbo.#Address (
	AddressID,
	AddressLine1,
	AddressLine2,	
	City,
	StateProvinceID,
	PostalCode,
	ModifiedDate,
	AccountNumber,
	MaxPrice
) select 
	AddressID,
	AddressLine1,
	AddressLine2,	
	City,
	StateProvinceID,
	PostalCode,
	ModifiedDate,
	AccountNumber,
	MaxPrice
from Address_CTE;

/*
d) Удаление строки
*/
delete from dbo.Address where ID = 293;
/*
e) Merge выражение 
*/
merge dbo.Address as target 
using dbo.#Address as source
on 
	target.ID = source.ID
when matched 
	then update set
		AccountNumber = source.AccountNumber,
		MaxPrice = source.MaxPrice
when not matched  by target
	then insert (
			AddressID,
			AddressLine1,
			AddressLine2,	
			City,
			StateProvinceID,
			PostalCode,
			ModifiedDate,
			AccountNumber,
			MaxPrice)
		values (
			source.AddressID,
			source.AddressLine1,
			source.AddressLine2,	
			source.City,
			source.StateProvinceID,
			source.PostalCode,
			source.ModifiedDate,
			source.AccountNumber,
			source.MaxPrice)
when not matched  by source
	then delete;

select * from dbo.Address 
