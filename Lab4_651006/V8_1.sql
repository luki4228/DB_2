use AdventureWorks2012;
go
/*
a) Создание таблицы
*/

create table Person.CountryRegionHst (
	ID int identity(1,1) primary key,
	Action nvarchar(6) not null check (Action in ('INSERT', 'UPDATE', 'DELETE')),
	ModifiedDate datetime not null default GETDATE(),
	SourceID nvarchar(3) not null,
	UserName nvarchar(100) not null default USER_NAME()
);
go
/*
b) Создание AFTER триггеров
*/
create trigger Person.CountryRegion_INSERT
on Person.CountryRegion
after insert 
as
	insert into Person.CountryRegionHst (
		Action,
		SourceID)
	values (
		'INSERT',
		(select 
			CountryRegionCode 
		from 
			inserted));	
go

create trigger Person.CountryRegion_UPDATE
on Person.CountryRegion
after update 
as
	insert into Person.CountryRegionHst (
		Action,
		SourceID)
	values (
		'UPDATE',
		(select 
			CountryRegionCode 
		from 
			inserted));
go

create trigger Person.CountryRegion_DELETE
on Person.CountryRegion
after delete 
as
	insert into Person.CountryRegionHst (
		Action,
		SourceID)
	values (
		'DELETE',
		(select 
			CountryRegionCode 
		from 
			deleted));
go
/*
c) Создание вьюшки
*/
create view Person.CountryRegionView
with encryption
as 
	(select * from Person.CountryRegion);
go
/*
d) Проверка триггеров
*/
insert into Person.CountryRegionView (
	CountryRegionCode, 
	Name, 
	ModifiedDate)
values (
	'ZZ',
	'Zanzibar',
	getdate())

update Person.CountryRegionView
set
	Name = 'ZombiZanuda'
where
	CountryRegionCode = 'ZZ' 

delete Person.CountryRegionView
where
	CountryRegionCode = 'ZZ'

select * from Person.CountryRegionHst