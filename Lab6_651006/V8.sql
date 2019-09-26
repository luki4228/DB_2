use AdventureWorks2012;
go

create procedure  dbo.WorkOrdersByMonths(
	@months nvarchar(110))
as
begin
	declare @SQL nvarchar(MAX);
	set @SQl = '
	select distinct
		[Year],
		' + @months + '
	from 
		(select 
			YEAR(DueDate) as [Year],
			OrderQty,
			[Month] = DATENAME(month, DueDate)
		from
			Production.WorkOrder) as p
	pivot 
		(SUM(OrderQty) for Month in (' + @months + ')) as pvt';
	exec(@SQL);
end;

execute dbo.WorkOrdersByMonths '[January],[February],[March],[April],[May],[June]'