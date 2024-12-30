----Retrieve list of all employees' full name, combine first name, last name, and middle and phone numbers.---
SELECT * FROM Person.Person;
SELECT * FROM Person.EmailAddress;
SELECT * FROM Person.PersonPhone;

SELECT CONCAT(P.FIRSTNAME,' ',P.LASTNAME,' ',P.MIDDLENAME,'.') AS FULLNAME,
g.emailaddress,b.phonenumber
FROM PERSON.PERSON P
INNER JOIN PERSON.EmailAddress g
ON p.BusinessEntityID = g.BusinessEntityID
inner join person.personphone  b on
b.businessentityid = p.businessentityid
where PersonType = 'em'
order by fullname asc;

---Retrieve products with inventory levels < 100---
select * from Production.ProductInventory;
select * from production.product;

select p.name as ProductName,
a.quantity as NewQuantity
from production.ProductInventory a
join production.product p on 
a.ProductID = p.ProductID
where a.Quantity < 100;

----Retrieve Total sales by region---
select * from sales.SalesOrderHeader;
select * from sales.SalesTerritory;

select a.name as Region,sum(s.TotalDue) as TotalSales
from sales.salesorderheader s
join sales.salesTerritory a 
on s.TerritoryID = a.territoryID
group by a.name;

---Retrieve sales by quater and year---
select * from sales.SalesOrderDetail;
select * from production.Product;

select o.Name, datepart(quarter,a.ModifiedDate) as Quarter,datepart(year,a.ModifiedDate) as year,
sum(a.UnitPrice) as TotalUnitprice
from sales.SalesOrderDetail a
join Production.Product o
on a.productid = o.ProductID
where o.name = 'adjustable race'
group by datepart(quarter,a.ModifiedDate),
datepart(year,a.ModifiedDate)
order by year,quarter;

--Retrieve all products by unit price---
select * from sales.SalesOrderDetail;
select * from production.product;

select c.name as ProductName, sum(s.unitPrice) as TotalUnitprice
from sales.SalesOrderDetail s
join production.product c
on s.ProductID = c.ProductID
group by c.Name
order by TotalUnitprice desc;

---- compare the total sales for the current year (SalesYTD) and the previous year (saleslastYear) for each country---
--calculate the difference between these two figures---
select * from person.CountryRegion;
select * from sales.SalesTerritory;

SELECT p.name,sum(b.salesytd) as currentYearSale,sum(b.saleslastyear) as saleslastyear,sum(b.salesytd-b.saleslastyear) as salesdifference
from PERSON.CountryRegion p
right join SALES.SALESTERRITORY b
on p.Countryregioncode = b.Countryregioncode
Group by p.name 
order by sum(b.salesytd) desc;

---Identify top-performing salespeople who have generated significant revenue from the Sales.SalesOrderHeader table---
---Find out which salespeople have achieved total sales amounts greater than $50,000---
--rank them in descending order of their total sales---
select * from sales.SalesOrderHeader;
select * from sales.SalesPerson;
select * from HumanResources.Employee;

Select p.FirstName, p.lastname, sum(s.TotalDue) as totalsalesamount
from sales.SalesOrderHeader as s
join sales.SalesPerson as b
on s.SalesPersonID = b.BusinessEntityID
join humanresources.Employee as e
on b.BusinessEntityID=e.BusinessEntityID
join person.Person as p
on p.BusinessEntityID=e.BusinessEntityID
group by p.FirstName,p.LastName
having sum(s.TotalDue)>50000
order by sum(s.TotalDue) desc;

--- Get an overview of your customer base--
--including how many orders each customer has placed from Sales.Customer table---
--Retrieve list of all customers along with the total number of orders they have made---
--rank in descending order of their total orders- --
select * from sales.Customer;
select * from sales.salesterritory;
select * from sales.store;
select * from person.person;

Select p.firstname,p.lastname, count(salesorderid) as Total_orders
from  sales.customer c
left join sales.SalesOrderHeader S
on  c.CustomerID = S.CUSTOMERID
left join person.Person p
on  c.PersonID = p.BusinessEntityID
group by p.firstname,p.lastname
order by Total_orders desc;

--- Identify departments with a significant number of staff members---
---find out which departments have more than 5 employees----
---list them in descending order based on the number of employees---
select * from HumanResources.Department;
select * from HumanResources.EmployeeDepartmentHistory;

Select d.name as department_name, count(t.DepartmentID) as Total_no_of_staffperdept
from HumanResources.Department d
inner join HumanResources.EmployeeDepartmentHistory t
on d.DepartmentID = t.DepartmentID
group by d.Name
having count(t.departmentID)>5
order by count(t.departmentID) desc;

---RETRIEVE FIRST NAME,LAST NAME AND EMAIL ADDRESS---
select * from person.person;
select * from person.EmailAddress;

Select p.firstname,p.lastname,e.emailaddress
from person.person p
inner join person.EmailAddress e
on p.BusinessEntityID = e.BusinessEntityID;

--Retrieve customer info along with their respective order ids--
select  * from sales.customer;
select * from sales.SalesOrderHeader;

Select c.CustomerID,StoreID,SOH.SalesOrderID
from  sales.customer c
inner join sales.SalesOrderHeader SOH
on  c.CustomerID = SOH.CUSTOMERID;

--Retrieve THE total sales amount for each customer who has placed order,filtering those with --
--total sales greater than 10000--
select * from sales.Customer;
select * from sales.SalesOrderHeader;
Select c.CustomerID, round(sum(Soh.totaldue),2) as Total_Sales
from  sales.customer c
inner join sales.SalesOrderHeader SOH
on  c.CustomerID = SOH.CUSTOMERID
group by c.CustomerID
having sum(soh.totaldue) > 10000
order by Total_Sales desc;


--retrieve customers and their total sales, including
--customers who havent placed any order---
select * from sales.Customer;
select * from sales.SalesOrderHeader;

Select c.CustomerID,p.firstname,p.lastname, round(sum(Soh.totaldue),2) as Total_Sales
from  sales.customer c
left join sales.SalesOrderHeader SOH
on  c.CustomerID = SOH.CUSTOMERID
left join person.Person p
on  c.PersonID = p.BusinessEntityID
group by c.CustomerID,p.firstname,p.lastname
order by Total_Sales desc;

--Retrieve the first and last name of employees, their job titles
--and the name of dept they worked in--
select * from HumanResources.Employee;
select * from person.person;
select * from HumanResources.EmployeeDepartmentHistory;
select * from HumanResources.Department;

select p.firstname, p.lastname, E.jobtitle, D.Name AS DEPT_NAME
from HumanResources.Employee E
join person.person P
ON P.BusinessEntityID = E.BusinessEntityID
join HumanResources.EmployeeDepartmentHistory EDH
ON EDH.BusinessEntityID = E.BusinessEntityID
JOIN HumanResources.DEPARTMENT D
ON D.DepartmentID = EDH;

Select sc.customerId, p.firstname ,p.lastname, soh.salesorderID,pp.name as product_name
from sales.Customer sc
left join sales.SalesOrderHeader soh
on sc.CustomerID = soh.CustomerID
left join sales.SalesOrderDetail sod
on sod.SalesOrderID= soh.SalesOrderID
left join Production.product pp
on pp.ProductID = sod.ProductID
left join person.Person p
on p.BusinessEntityID= sc.PersonID;
 
 Select PP.name as product_name , PPc.name as product_category, sum(sod.orderqty) as total_qty
 from Sales.SalesOrderDetail SOD
 join Production.Product pp
 on pp.ProductID=SOD.ProductID
 join Production.ProductSubcategory PPS
 on pps.ProductSubcategoryID=pp.ProductSubcategoryID
 join Production.ProductCategory ppc
 on ppc.ProductCategoryID=pps.ProductCategoryID
 group by pp.Name,ppc.name
 having sum(sod.orderqty)>100 order by total_qty desc; 
