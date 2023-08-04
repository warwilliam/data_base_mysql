#Resolução Aula 2 - Adventure works revisão

#Where
#1 - Mostre as pessoas  cuja segunda letra do sobrenome é “a”.

select c.FirstName as name, c.LastName as surName
from  contact c
where LastName like '_a%';



#2 -  Mostre o nome concatenado com o sobrenome das pessoas que têm 
#como "Títle" os valores "Mr." e “Ms”

select concat(c.FirstName ,' ', c.LastName) as fullName
from contact c
where Title in ('Mr.', 'Ms.'); 


#3 - Mostre os nomes dos produtos cujo número do produto começa com “AR” ou “BE” ou “DC”.

select * from product p;

select p.Name as product, p.ProductNumber
from product p
where ProductNumber like 'AR%' or ProductNumber like'BE%'or ProductNumber like'DC%';


#4 - Mostrar pessoas cujos nomes têm um C como o primeiro caractere e o segundo caractere 
#não é "O" nem "E".

select c.FirstName as name
from contact c 
where c.FirstName like 'C%' 
and c.FirstName not like '_o%' 
and c.FirstName not like '_e%';

#5 - Mostre todos os produtos cujo preço de tabela está entre 400 e 500

select * from product;
 
select p.Name as Produto, p.ListPrice
from product p
where p.ListPrice between 400 and 500
Order by ListPrice desc;


#6 -  Mostre todos os funcionários que nasceram entre 1960 e 1980 
#e cujos anos de nascimento sejam pares.

select * from employee;

select e.ContactID, c.FirstName, year(e.BirthDate)
from employee e
inner join contact c
where c.ContactID= e.ContactID and year(e.BirthDate) between 1960 and 1980 and
year(e.BirthDate)%2 =0;

#operadores and joins

#1 - Mostre o código, data de entrada e horas de férias
# dos funcionários que entraram a partir do ano 2000.

select e.EmployeeID, e.HireDate, e.VacationHours
from employee e
where year(e.HireDate) >= 2000;


#2 - Mostre o nome, número do produto, preço de tabela e o preço de tabela 
#acrescido de 10% dos produtos cuja data final de venda seja anterior a hoje.

select p.Name, p.ProductNumber, p.ListPrice, format((p.ListPrice*1.1),2) as newPrice
from product p
where SellEndDate < now() ;


#Group By
#1 - Mostre o número de funcionários por ano de nascimento.

select count(e.EmployeeID) as totalEmployee, year(e.BirthDate) as birthYear
from employee e
Group by birthYear
order by totalEmployee desc;



#2 -Mostre o preço médio dos produtos por ano de início da venda.
select sum(p.ListPrice), AVG(p.ListPrice) as precoMedio, p.ProductID, year(SellStartDate) as year
from product p
group by year(p.SellStartDate),ProductID;


select * from product
where ProductID = 680;


#3 - Mostre os produtos e o total vendido de cada um deles, ordenados pelo total vendido.

select p.name, p.ProductID,sd.LineTotal as total
from product p
inner join salesorderdetail sd
where  p.ProductID = sd.ProductID
group by p.ProductID
order by sd.OrderQty desc;

Select productID, format(sum(lineTotal),2) as totalVendido
from salesorderdetail 
group by productID 
order by totalVendido;

select p.name, sd.OrderQty, sd.UnitPrice
from product p
inner join salesorderdetail sd
where p.ProductID = 776;


select sum(salesorderdetail.LineTotal)
from salesorderdetail
where ProductID = 867;


#4 - Mostre a média vendida por fatura. 

select sd.SalesOrderID, format(sd.LineTotal ,2) as total, avg(sd.LineTotal) as media 
 from salesorderdetail sd
 group by SalesOrderID;
 
 
 select * from salesorderdetail;
 
 #Having
#1 -  Mostre subcategorias para produtos que têm dois ou mais produtos que custam menos de US$ 200. 

select p.ProductSubcategoryID, p.ListPrice
from product p
where p.ListPrice < 200
group by p.ProductSubcategoryID
having count(distinct ProductID) >= 2 ; 

Select 
	ProductSubcategoryID
    , format(sum(ListPrice),2)
from product  
where listPrice <= 200
group by ProductSubcategoryID 
having count(distinct productId) >= 2;

#2 - Mostre todos os códigos de subcategoria existentes juntamente com a quantidade de produtos 
# cujo preço de tabela é superior a US$ 100 e o preço médio é inferior a US$ 300.

select distinct product.ProductSubcategoryID, count(ProductID), format(avg(ListPrice),2) as precoMedio
from product
where ListPrice > 100
group by ProductSubcategoryID
having avg(ListPrice) < 300;



#Joins

#1 - Mostre os preços de venda dos produtos em que o valor é inferior ao preço de tabela 
# recomendado para esse produto ordenado pelo nome do produto.

select p.Name, pd.UnitPrice, p.ListPrice
from purchaseorderdetail pd
inner join product p
where pd.ProductID = p.ProductID
group by Name
having pd.UnitPrice < p.ListPrice
order by Name;



#2 - Mostre todos os produtos que têm o mesmo preço. O código e o nome de cada um dos dois produtos 
# e o preço de ambos devem ser apresentados em pares. 

select  distinct p.Name as n1, p.ProductID as id1, p2.Name as n2, p2.ProductID as id2, concat(p.ListPrice, ' ', p2.ListPrice)
from product p
inner join product p2
where  p.ListPrice >0 AND p.ListPrice = p2.ListPrice
order by p.ListPrice desc;

select distinct  p.ProductID, p.name, p.ListPrice, p2.productId , p2.name, p2.ListPrice
from product p 
inner join product p2 on p.ListPrice = p2.ListPrice
order by p.ListPrice desc;

#3 - Mostre o nome dos produtos e fornecedores ordenados por nome de fornecedor decrescente.

select p.Name as Product, v.Name as Vendor
 from product p
inner join productvendor pv on  p.ProductID = pv.ProductID
inner join vendor v on v.VendorID = pv.VendorID  
order by Vendor desc;


#4 - Mostre todas as pessoas —nome e sobrenome— e se forem funcionários,
#  mostre também o id de login, caso contrário, mostre null.

select concat(FirstName, " ",LastName) as Name, employee.LoginID
from contact c 
left join employee on c.ContactID = employee.ContactID
order by LoginID desc;

select c.FirstName, c.LastName , e.LoginID
from contact c 
left join employee e 
	on e.contactId = c.contactID ;