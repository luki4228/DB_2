use AdventureWorks2012;

select 
	BusinessEntityID, 
	BirthDate, 
	MaritalStatus, 
	Gender, 
	HireDate 
from 
	HumanResources.Employee 
where
	MaritalStatus = 'S' and BirthDate < '1961-01-01';

select 
	BusinessEntityID, 
	JobTitle, 
	BirthDate, 
	Gender, 
	HireDate 
from 
	HumanResources.Employee 
where 
	JobTitle = 'Design Engineer' order by HireDate desc;

select 
	BusinessEntityID, 
	DepartmentID, 
	StartDate, 
	EndDate,
	DATEDIFF(YEAR, StartDate, case when EndDate is  NULL 
			then GETDATE() 
		else EndDate
	end) as YearsWorked 
from 
	HumanResources.EmployeeDepartmentHistory 
where 
	DepartmentID = '1';
