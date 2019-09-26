use AdventureWorks2012;
go

select 
	Emp.BusinessEntityID, 
	Emp.OrganizationLevel,
	Emp.JobTitle,  
	JC.JobCandidateID,
	JC.Resume
from 
	HumanResources.Employee as Emp inner join HumanResources.JobCandidate as JC 
on 
	JC.BusinessEntityID = Emp.BusinessEntityID;

select 
	Dep.DepartmentID,
	Dep.Name,
	COUNT(Dep.DepartmentID) as EmpCount
from 
	HumanResources.Department as Dep inner join HumanResources.EmployeeDepartmentHistory as EDH
on 
	Dep.DepartmentID = EDH.DepartmentID 
group by 
	Dep.DepartmentID, Dep.Name
having COUNT(Dep.DepartmentID) > 10;

select 
	Dep.Name,
	Emp.HireDate,
	Emp.SickLeaveHours,
	(select 
		SUM(SickLeaveHours) 
	from 
		HumanResources.Employee as E inner join HumanResources.EmployeeDepartmentHistory as HEDH
	on
		E.BusinessEntityID = HEDH.BusinessEntityID inner join HumanResources.Department as D
	on 
		D.DepartmentID = HEDH.DepartmentID
	where 
		HireDate <= Emp.HireDate and D.Name = Dep.Name) as AccumulativeSum
from 
	HumanResources.Department as Dep inner join HumanResources.EmployeeDepartmentHistory as EDH
on 
	Dep.DepartmentID = EDH.DepartmentID inner join HumanResources.Employee as Emp
on 
	EDH.BusinessEntityID = Emp.BusinessEntityID
group by Dep.Name, Emp.HireDate, Emp.SickLeaveHours, Emp.BusinessEntityID 
order by Dep.Name, Emp.HireDate;

