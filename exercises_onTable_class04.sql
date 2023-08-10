-- Exercicio de mesa

-- 1) Empregados 
-- a) Crie uma SP que liste os sobrenomes, nomes e idades dos funcionários em ordem alfabética. 
-- Observação: Para a idade, crie uma função que receba a data de nascimento como parâmetro de entrada e retorne a idade.
-- b) Invoque a SP para verificar o resultado. 


DELIMITER $$
CREATE FUNCTION calcAge(birthDate date)
RETURNS tinyint DETERMINISTIC
BEGIN
DECLARE result tinyint;
SET result = (SELECT TIMESTAMPDIFF(YEAR, birthDate, CURDATE()));

RETURN result;
END $$ DELIMITER ;

DELIMITER $$
CREATE PROCEDURE listEmployee()
BEGIN

SELECT e.Sobrenome as LastName, e.Nome as Name,  calcAge(e.DataNascimento) as Age
FROM empregados e
ORDER BY LastName;
END $$
DELIMITER ;

Call listEmployee();

select * from empregados;


-- 2) Empregado por cidade 
-- a) Crie uma SP que receba o nome de uma cidade e liste os funcionários dessa cidade com mais de 25 anos. 
-- Observação: Use a função criada no ponto 1 
-- b) Invoque a SP para listar funcionários de Londres. 

DELIMITER $$

CREATE PROCEDURE callByCity(city varchar(50))
BEGIN 
SELECT e.Cidade as Cidade, e.Nome AS Name, calcAge(e.DataNascimento) as Age
FROM empregados e
WHERE e.Cidade = city
HAVING Age > 25;
END $$
DELIMITER ;

Call callByCity('London');

select * from empregados;

-- 3) Empregados 
-- a) Crie uma SP que liste os sobrenomes, nomes, idade e a diferença em anos de idade com o valor máximo de idade 
-- que a tabela de empregador possui.
-- Observação: Use a função criada no ponto 1. Crie uma função que retorne a data mínima de nascimento da tabela de Empregados. 

DELIMITER $$

CREATE PROCEDURE callEmployeesAges()
BEGIN
DECLARE moreOld tinyint;
SET moreOld = (SELECT MAX(calcAge(e.DataNascimento)) FROM empregados e);
SELECT e.Sobrenome , e.Nome AS Name, calcAge(e.DataNascimento) as Age , moreOld-calcAge(e.DataNascimento) as Diferenca
FROM empregados e;
END $$
DELIMITER ;

Call callEmployeesAges;


-- 4) Vendas com desconto 
-- a) Crie um SP que receba uma porcentagem e liste os nomes dos produtos que foram vendidos com desconto igual ou superior 
-- ao valor indicado, indicando também o nome do cliente para quem foi vendido. 
-- Além disso, devolvam o preço do produto com um aumento.
-- Observação: Para devolver o preço do produto com o aumento, crie uma função que receba uma porcentagem e o preço do produto.

SELECT * FROM detalhefatura;

DELIMITER $$

CREATE FUNCTION incrisePrice( incrise FLOAT, price FLOAT)
RETURNS FLOAT DETERMINISTIC
BEGIN 
DECLARE result FLOAT;
SET result = ( price * (1 +incrise));

RETURN result;
END $$ 
DELIMITER ;


DELIMITER $$

CREATE PROCEDURE checkDisccountIncrise(discount float)
BEGIN

SELECT p.ProdutoNome as product, c.Empresa as ClientName, df.PrecoUnitario as unitPrice, df.Desconto as Disccount, incrisePrice(df.Desconto, df.PrecoUnitario) as IncrisedPrice
FROM produtos p
INNER JOIN detalhefatura df
ON p.ProdutoID = df.ProdutoID
INNER JOIN faturas f
ON df.FaturaId = f.FaturaId
INNER JOIN clientes c
ON f.ClienteID = c.ClienteID
GROUP BY Desconto
Having Desconto >= discount;
END $$
DELIMITER ;

CALL checkDisccountIncrise(0.05);


