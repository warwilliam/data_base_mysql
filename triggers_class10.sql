use musimundos;

-- 1.	Modifique a tabela de artistas, adicione o campo userCreator varchar(50) e dateCreation datetime. Então faça o seguinte:
-- a)	Crie um trigger que ao inserir um registro na tabela de artistas, o usuário que criou o registro seja adicionado à coluna userCreator. Dica: qual função usamos para obter o usuário?
-- b)	Além disso, deve-se adicionar no campo dateCreation em que dia e em que horário foi inserido o registro.
-- c)	Execute um insert na tabela de artistas e depois faça um select no último registro para ver os resultados. Qual usuário foi adicionado?


SELECT * FROM artistas;

ALTER TABLE artistas add userCreator varchar(50);
ALTER TABLE artistas add dateCreaton datetime;

DELIMITER $$
CREATE TRIGGER trg_before_insert_artista
BEFORE INSERT ON artistas for each row
BEGIN
SET new.userCreator = (select current_user());
SET new.dateCreaton = now();
END $$
DELIMITER ;

DROP TRIGGER trg_before_insert_artista;

INSERT INTO artistas (id, nome)
VALUES (277, 'Rammstain');

-- 2.	Modifique a tabela de artistas, adicione o campo userModification varchar(50) e dateModification datetime. 
   
   ALTER TABLE artistas add userModification varchar(50);
   
-- a)	Crie um trigger que quando um registro for atualizado na tabela de artistas, 
-- o usuário que atualizou o registro seja adicionado à coluna userModification.   

DELIMITER $$
CREATE TRIGGER trg_before_update_artista
BEFORE UPDATE ON artistas for each row
BEGIN
SET new.userModification = (select current_user());
END $$
DELIMITER ;

-- b)	Além disso, deve-se adicionar no campo dateMoficacion em que dia e em que horário foi realizada a execução.

UPDATE artistas SET nome = 'Giba' WHERE (id = '277');

ALTER TABLE artistas add dateModification datetime;

DROP TRIGGER trg_before_update_artista;

DELIMITER $$
CREATE TRIGGER trg_before_update_artista
BEFORE UPDATE ON artistas for each row
BEGIN
SET new.userModification = (select current_user());
SET new.dateModification = now();
END $$
DELIMITER ;

-- c)	Execute uma atualização na tabela de artistas e selecione no último registro para ver os resultados. 
-- Qual foi o usuário  que modificou os dados?

UPDATE artistas SET nome = 'Gojira' WHERE (id = '277');

SELECT * from artistas;

-- 3.	Crie a tabela artista_historico com os campos: 
-- id int, nome varchar(85), rating double(3,1), user varchar(50), date datetime, ação varchar(10).

CREATE TABLE artistas_historico(id int, nome varchar(85), rating double(3,1), usuario varchar(50), 
dataMod datetime, acao varchar(10));


-- 4.Crie um trigger que quando um registro for inserido na tabela artistas, um valor seja inserido na tabela artista_historico,
-- com os mesmos valores de id, nome e rating, o usuário que executou a ação, o dia e horário de execução e ,
-- em ação, adicione o valor "Inserir"

DROP TRIGGER register_insert;

ALTER TABLE artistas add rating double(3,2);


DELIMITER $$
CREATE TRIGGER register_insert
BEFORE INSERT ON artistas for each row
BEGIN
INSERT INTO artistas_historico (id, nome, rating, usuario, dataMod, acao)
values (new.id, new.nome, new.rating, (select current_user()), now(), 'Isert');
END $$
DELIMITER ;

INSERT INTO artistas(id, nome)
values(279, 'Lamb og God');

    select * from artistas_historico;
    
    
-- 5. Crie um trigger que quando for feita uma atualização de um registro na tabela artistas,
--  seja inserido um valor na tabela artista_histórico, com os mesmos valores de id, nome e rating, 
-- o usuário que executou a ação, o dia e hora da execução e, em ação, adicionar o valor "Update"

DELIMITER $$
CREATE TRIGGER register_insert
AFTER UPDATE ON artistas for each row
BEGIN
INSERT INTO artistas_historico (id, nome, rating, usuario, dataMod, acao)
values (new.id, new.nome, new.rating, (select current_user()), now(), 'Isert');
END $$
DELIMITER ;

-- 5.	Crie um trigger que quando for feita uma atualização de um registro na tabela artistas,
-- seja inserido um valor na tabela artista_histórico, com os mesmos valores de id, nome e rating, o usuário que 
-- executou a ação, o dia e hora da execução e, em ação, adicionar o valor "Update"
DELIMITER $$
CREATE TRIGGER update_artistas
AFTER update on artistas for each row
BEGIN

INSERT INTO artistas_historico(id, nome, rating, usuario, dataMod, acao)
values(new.id, new.nome, new.rating, (select current_user()), now(), 'updated');
END $$
DELIMITER ;




-- 6.	Crie uma trigger que quando um registro for deletado na tabela artistas,
-- seja inserido um valor na tabela artista_historico, com os mesmos valores de id, nome e rating, 
-- o usuário que executou a ação, o dia e hora da execução e, em ação, adicione o valor "Delete"

DELIMITER $$
CREATE TRIGGER delete_artista
after delete on artistas for each row
BEGIN
INSERT INTO artistas_historico(id, nome, rating, usuario, dataMod, acao)
values(old.id, old.nome, old.rating, (select current_user()), now(), 'Delete');
END $$
DELIMITER ;

-- 7.	Execute uma inserção, atualização e exclusão na tabela de artistas. 
-- Em seguida, faça um select na tabela artista_historico.

INSERT INTO artistas(id, nome)
values(279, 'Lamb og God');


delete from artistas
where id = 279;

update artistas set nome = 'Arch Enemy'
WHERE id = 15;



select * from artistas;

select * from artistas_historico;


-- Colocando em prática: Subconsultas

-- 1.	Crie uma consulta que retorne os clientes e faturas que possuem a data mínima da fatura gerada no ano de 2010.

SELECT distinct c.nome, sobrenome, f.data_fatura, f.valor_total
FROM clientes c
INNER JOIN faturas f
ON c.id = f.id_cliente
WHERE f.data_fatura = (select min(data_fatura) from faturas where year(data_fatura) = 2010);


-- 2.	Crie uma consulta que retorne os clientes e faturas que possuem a data máxima da fatura que foi gerada no ano de 2010
--  desde que existam faturas de músicas com o gênero "rock" no ano de 2011.

SELECT distinct c.nome, sobrenome, f.data_fatura, f.valor_total, g.nome as genero
FROM clientes c
INNER JOIN faturas f
ON c.id = f.id_cliente
INNER JOIN itens_faturas itf
ON f.id = itf.id_fatura
INNER JOIN cancoes cc
ON itf.id_cancao = cc.id
INNER JOIN generos g
ON cc.id_genero = g.id
WHERE f.data_fatura = (select max(data_fatura) from faturas where year(data_fatura) <= 2010)
Group By c.nome
having g.nome = 'rock';





