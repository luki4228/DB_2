use AdventureWorks2012;
go

create procedure XmlToTable(@Data xml)
as

	select 
		T.X.value('@ID', 'INT') as AddressID,
		T.X.value('(City/text())[1]', 'NVARCHAR(30)') as City,
		T.X.value('(./Province/@ID)[1]', 'INT') as StateProvinceID,
		T.X.value('(./Province/Region)[1]', 'NVARCHAR(3)') as CountryRegionCode
	from @Data.nodes('/Addresses/Address') as T(X);
return

declare @AddressTable table (
		AddressID int,
		City nvarchar(30),
		StateProvinceID int,
		CountryRegionCode nvarchar(3));

declare @XML xml =
(select * from 
	(select 
	1 as Tag,
    null as Parent,
	A.AddressID as [Address!1!ID],
	A.City as [Address!1!City!ELEMENT],
	null as [Province!2!ID] ,
	null as [Province!2!Region!ELEMENT]
from 
	Person.Address as A  inner join Person.StateProvince as SP
on	
	A.StateProvinceID = SP.StateProvinceID
union all
select 
	2 as Tag,
    1 as Parent,
	A.AddressID, 
	null,
	SP.StateProvinceID,
	SP.CountryRegionCode 
from 
	Person.Address as A  inner join Person.StateProvince as SP
on	
	A.StateProvinceID = SP.StateProvinceID) as X
order by [Address!1!ID], [Province!2!ID]
for XML explicit, root ('Addresses'));

insert into @AddressTable exec XmlToTable @XML;
select * from @AddressTable;

