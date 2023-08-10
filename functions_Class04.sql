

-- Functions: Músicas
-- Tabela: Músicas
-- 1. Crie uma função que solicite os milissegundos da tabela de músicas como parâmetros de entrada e que retorne
-- as mesmas informações como resultado, mas com o formato de horas, minutos e segundos — sem milissegundos. 
-- Caso o parâmetro cidade esteja vazio, 00:00:00 deve ser retornado.

DELIMITER $$
CREATE FUNCTION fullName( firstName varchar(50), LastName varchar(50))
RETURNS varchar(100)
DETERMINISTIC
BEGIN
RETURN CONCAT(nome, ' ', sobrenome);
END %%
DELIMITER ;

SELECT fullName(FirstName, LastName)
FROM contact;

-- 2. Invoque a função para obter as informações de todas as músicas do gênero rock, usando a função para mostrar sua duração.
