use adventureWorks;

SELECT @@autocommit;

select * from employee_age;

-- 1.	Crie a tabela Employee_Age_Hist com os mesmos campos da tabela Employee_Age e com os seguintes campos:
-- CreatedDate, ModifiedDAte, CreatedUser, ModifiedUser. 

-- a)	criar a tabela Employee_Age_Hist;
CREATE TABLE Employee_Age_Hist(firstName VARCHAR(50), LastName VARCHAR(50), age tinyint, CreatedDate datetime,  ModifiedDate datetime, CreatedUser varchar(50), ModifedUser varchar(50));

-- b)	criar o  trigger que vai inserir dados na tabela Employee_Age_Hist
DELIMITER $$
CREATE TRIGGER After_Insert_Employee
BEFORE INSERT
ON Employee_Age FOR EACH ROW

BEGIN 

INSERT INTO employee_age_hist(FirstName , LastName , Age , CreatedDate ,  ModifiedDate , CreatedUser , ModifedUser)
VALUES (new.FirstName, new.LastName, new.Age, NOW(), NOW(), CURRENT_USER(), CURRENT_USER() );
END $$
DELIMITER ;

-- c)	criar uma procedure para inserir dados na tabela Employee_Age, tendo como parâmetros o FirstName, LastName e Age
DELIMITER  $$
CREATE PROCEDURE usp_Insert_Employee(pi_FirstName varchar(50), pi_LastName varchar(50), pi_Age tinyint)
BEGIN
INSERT INTO employee_age( FirstName , LastName , Age) VALUES (pi_FirstName, pi_LastName, pi_Age);

END $$
DELIMITER ;

-- Finalizando, evoque a procedure, passando os parâmetros. Depois, faça um select na tabela Employee_Age_Hist 
-- e veja se os dados foram inseridos.
CALL usp_Insert_Employee('William', 'Rodrigues', 36);

select * from employee_age_hist; 
 
 
-- 2.	Modifique a Procedure criada na questão 1, para qu permita inserir os valores na tabela Employee_Age 
-- e que também insira na tabela Employee_Age_Hist os mesmos resultados, com a data da criação, a data de modificação, 
-- usuário criador e usuário que modificou. A criação da tabela tem que estar em um handler. 
-- Mantenha os mesmos parâmetros de entrada.
 
 DROP TABLE employee_age_hist;
 DROP PROCEDURE usp_Insert_Employee;
 
 
 DELIMITER  $$
CREATE PROCEDURE usp_Insert_Employee(pi_FirstName varchar(50), pi_LastName varchar(50), pi_Age tinyint)
BEGIN

DECLARE CONTINUE HANDLER FOR  1146
BEGIN 
	SELECT 'Table Employee_age_hist not exists';
	CREATE TABLE Employee_Age_Hist(firstName VARCHAR(50), LastName VARCHAR(50), age tinyint, CreatedDate datetime,  ModifiedDate datetime, CreatedUser varchar(50), ModifedUser varchar(50));
END;
    
INSERT INTO employee_age( FirstName , LastName , Age) VALUES (pi_FirstName, pi_LastName, pi_Age);

INSERT INTO employee_age_hist(FirstName , LastName , Age , CreatedDate ,  ModifiedDate , CreatedUser , ModifedUser)
VALUES (new.FirstName, new.LastName, new.Age, NOW(), NOW(), CURRENT_USER(), CURRENT_USER() );

END $$
DELIMITER ;

CALL usp_Insert_Employee('Natalia', 'Mosquetto', 36);

select * from employee_age;
select * from employee_age_hist;



-- 3.	Crie uma consulta que retorne um produto de um vendedor que teve registro de venda em 10-09-2001 e também em 13-09-2001.
-- Além disso, mostre a quantidade de produtos do vendedor.
-- Para esta consulta você deverá utilizar as tabelas productVendor e Vendor.


SELECT *, (SELECT count(*) FROM productvendor pv2 WHERE pv2.VendorID = v.VendorID) as VendorQuant
FROM productvendor pv
INNER JOIN vendor v
	on pv.VendorID = v.VendorID
WHERE 
	EXISTS (
		SELECT *
			FROM productvendor pv2
            WHERE pv2.LastReceiptDate = '2001-09-10'
            AND pv.ProductID = pv2.ProductID
)

AND EXISTS (
		SELECT *
			FROM productvendor pv3
            WHERE pv3.LastReceiptDate = '2001-09-13'
            AND pv.ProductID = pv3.ProductID
);


select * from productvendor where ProductID in (376);





