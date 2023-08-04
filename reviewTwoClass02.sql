select a.AddressID, a.AddressLine1, a.City, sp.StateProvinceCode, sp.Name 
from address a
right join stateprovince sp on a.StateProvinceID = sp.StateProvinceID;

## just specified state by ID
select a.AddressID, a.AddressLine1, a.City, sp.StateProvinceCode, sp.Name 
from address a
inner join stateprovince sp on a.StateProvinceID = sp.StateProvinceID
where sp.StateProvinceID = 79;

select  sp.StateProvinceCode, sp.Name, count(a.AddressID) as AdressAmount 
from address a
inner join stateprovince sp on a.StateProvinceID = sproductp.StateProvinceID
group by sp.Name
having AdressAmount > 1000
order by AdressAmount
limit 2product;

#product with price and new price with tax
select Name, ProductNumber, ListPrice, FORMAT((ListPrice * 1.1 ), 2) as newPrice, SellEndDate
from product
where SellEndDate < now();

#total of birht by year
select year(birthDate) as nascimento, count(EmployeeID) as AmountEmployee
from employee
group by nascimento
order by AmountEmployee desc;

#sum of all product of subcategory having 2 or more and the price is 200 or below

select ProductSubcategoryID, count(ProductID), format(sum(ListPrice),2)
from product
where ListPrice < 200
group by ProductSubcategoryID
having count(distinct ProductID) >= 2;


