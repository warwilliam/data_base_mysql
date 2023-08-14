-- INDEXAÇÃO E OTIMIZAÇÃO

CREATE FULLTEXT INDEX idx_title ON employee (LoginID, Title);
DROP INDEX idx_title on employee;
SHOW INDEX FROM employee;

-- NATURAL MODE

SELECT Title AS cargo, count(ContactID) AS qtd,
FORMAT(MATCH(LoginID, Title) AGAINST('Production Technician'),2) as relevancia
FROM employee
WHERE MATCH(LoginID, Title) AGAINST('Production Technician')
GROUP BY Title;

-- BOOLEAN MODE

SELECT Title, Match(LoginID, Title)
AGAINST ('>Marketing <Manager'IN BOOLEAN MODE) as relevancia
FROM employee
WHERE MATCH (LoginID, Title)
AGAINST('>Marketing <Manager' IN BOOLEAN MODE);

-- 1.	Acesse a tabela productmodel e responda: 
-- ●	Quantos índices clusterizados existem nessa tabela?
-- 1

-- ●	Quantos índices não clusterizados existem nessa tabela?
-- 2

-- 2.	Crie um índice FULLTEXT, utilizando como parâmetro as colunas `name` e `catalogDescription” 

SHOW INDEX FROM productmodel;

CREATE FULLTEXT INDEX idx_descModel
ON productModel (`name`, `catalogDescription`);

-- 3.	Crie uma consulta Fulltext, que retorne o modelo e a quantidade de catálogos que possuam a descrição 
-- “A light yet stiff aluminum bar for long distance riding”.

-- ●	Quantos registros retornaram? 07
-- ●	Qual o tempo de duração dessa consulta? 0,046 sec


SELECT `name`, count(`ProductModelID`) as qtd
FROM productmodel
WHERE MATCH (`name`, `catalogDescription`)
AGAINST ('A light yet stiff aluminum bar for long distance riding')
GROUP BY `name`;


-- 4.	Crie uma consulta, utilizando a sentença Match( ) Against( ) que retorne a porcentagem de relevância da descrição 
-- “A light yet stiff aluminum bar for long distance riding”  para todos os modelos envolvidos.

SELECT `ProductModelID`, `name`, FORMAT(MATCH(`name`,`catalogDescription`)
AGAINST ('A light yet stiff aluminum bar for long distance riding'),2) as relevancia
FROM productmodel
WHERE MATCH (`name`, `catalogDescription`)
AGAINST ('A light yet stiff aluminum bar for long distance riding');

-- ●	Em qual modelo a descrição teve maior relevância? Touring-2000
-- ●	Em qual modelo a descrição foi menos relevante? Long-Sleeve
-- ●	Qual o tempo de duração dessa consulta? 0,000


-- 5.	Acesse o Schema Inspector e responda:
-- ●	Quantas tabelas existem neste banco de dados? 74
-- ●	Qual a menor tabela do banco de dados em quantidade de registros, cujo valor  seja maior do que 0?  shoppingcartitem 3 rows


-- 6.	 Acesse o Table Inspector da tabela productmodel e responda:
-- ●	Quantas colunas existem nessa tabela? 6 
-- ●	Quantos registros existem nessa tabela? 128
-- ●	Qual o tamanho da tabela? 96 KiB
-- ●	Qual o tamanho do índice? 16KiB

-- 7.	Aplique o Analyze Table e responda:
-- ●	Qual o tamanho do índice agora? 96KiB
-- ●	Qual o tamanho estimado da tabela? 16KiB

-- 8.	Exclua o índice FULLTEXT pela guia Indexes.
