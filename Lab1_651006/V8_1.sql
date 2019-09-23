use master;
go

create database	Evgeniy_Lushchyk;
go

use Evgeniy_Lushchyk;
go

CREATE SCHEMA sales;
go

CREATE SCHEMA persons;
go

CREATE TABLE sales.Orders (OrderNum INT NULL);
go

backup database Evgeniy_Lushchyk
to disk 'D:\DB_2\Evgeniy_Lushchyk.bak';

drop database Evgeniy_Lushchyk;

RESTORE DATABASE AdventureWorks2012
FROM disk= 'D:\DB_2\Evgeniy_Lushchyk.bak'