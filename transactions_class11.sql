SELECT @@GLOBAL.transaction_isolation;

SELECT @@SESSION.transaction_isolation;

SELECT @@autocommit;

SET @@autocommit = off;

use musimundos;

-- 1.	Gere uma transação na tabela generos onde, dentro dela, vamos inserir o registro com id 28 e o nome que queremos.
--  Então vamos salvar a mudança.

select * from generos;

START TRANSACTION;
INSERT INTO generos(id, nome)
VALUES(28, 'loFizinho');

COMMIT;





	START TRANSACTION;
		SET foreign_key_checks = 0;
		DELETE FROM generos
		WHERE id = 28;
		SET foreign_key_checks = 1;
	COMMIT;


