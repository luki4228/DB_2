use AdventureWorks2012;
go
/*
Создание scalar-valued функции
*/
create function Production.ProductsCount (
	@id int)
returns int 
as
begin 
	declare @res int
	set @res = (
		select 
			count(ProductID) 
		from 
			Production.Product 
		where 
			ProductSubcategoryID = @id)
	return @res
end;
go
/*
Создание inline table-valued функции
*/
create function Production.ExpensiveProductsCount (
	@id int)
returns table 
as
return (
	select 
		ProductSubcategoryID,
		ProductID 
	from 
		Production.Product 
	where 
		ProductSubcategoryID = @id and StandardCost > 1000);

go
/*
Вызов с CROSS APPLY и OUTER APPLY
*/

select * from Production.Product cross apply Production.ExpensiveProductsCount(ProductSubcategoryID) as E
order by 
	E.ProductSubcategoryID;

select * from Production.Product outer apply Production.ExpensiveProductsCount(ProductSubcategoryID) as E
order by 
	E.ProductSubcategoryID;
go

create function Production.ExpensiveProductsCountNew(@id int)
	returns @expensiveProducts table (
		ProductSubcategoryID int null,
		ProductID  int not null
	)
as
begin
	insert into @expensiveProducts
	select
		ProductSubcategoryID,
		ProductID 
	from
		Production.Product 
	where 
		ProductSubcategoryID = @id and StandardCost > 1000
	return
end;