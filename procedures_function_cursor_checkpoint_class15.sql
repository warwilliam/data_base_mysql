-- Checkpoint I 
-- Projeto DHFitness 
 
-- Descrição
-- A DhFitness é uma empresa global cujo objetivo é fornecer soluções para monitoramento de atividades diárias e esportivas. 
-- Para isso, a DhFitness tem um produto carro-chefe que é o SmartWatDH, com GPS integrado, monitoramento de VO2, contador de passos, medidor de frequência cardíaca e estresse.
-- Além disso, possui um aplicativo onde podemos ver todos os nossos valores graficamente e também compartilhá-los com nossos amigos.
-- O DhFitness é sincronizado com Bluetooth ao nosso telefone e através de um processo, todos os dados são inseridos no banco de dados do aplicativo do usuário e, em seguida, esses valores são sincronizados para um banco de dados na nuvem que armazena as medições de todos os usuários. 
 
-- 1. Criar uma SP que insira um registro na tabela RelatorioDiario.
-- Nome da SP: sp_relatorio_diario_inserir 
-- Parâmetros de entrada: NomeAtividade, NomeMedicao, 
-- NomeUnidadeMedida,Data, Valor, idUsuario 

DELIMITER $$
CREATE PROCEDURE sp_relatorio_diario_inserir(IN p_NomeAtividade varchar(45) , p_NomeMedicao varchar(45), p_NomeUnidadeMedida varchar(45), p_DataRel date, p_Valor float, p_idUsuario int)
BEGIN
	INSERT INTO relatoriodiario( NomeAtividade , NomeMedicao , NomeUnidadeMedida , DataRel , Valor , idUsuario )
    VALUES(p_NomeAtividade, p_NomeMedicao, p_NomeUnidadeMedida , p_DataRel , p_Valor , p_idUsuario );
END $$
DEMILITER ;

-- 2. Criar uma função que verifique se já existe um registro na tabela RelatorioDiario.
-- Nome da função: fn_existe_relatorioDiario 
-- Parâmetros: idUsuario, NomeAtividade, NomeMedicao, Data 
-- Tipo de Resultado: TINYINT 
-- Retornar 1 se na tabela RelatorioDiario existe um registro com TODOS os parâmetros de entrada. Para validar a existência, pode-se utilizar: SELECT EXISTS (consulta).


DELIMITER $$
CREATE FUNCTION fn_existe_relatorioDiario2(f_idUsuario int, f_NomeAtividade varchar(45), f_NomeMedicao varchar(45), f_Data Date) 
RETURNS TINYINT DETERMINISTIC
BEGIN
	
DECLARE RESULT TINYINT DEFAULT 0;
	SET RESULT = (SELECT EXISTS(select 1 from relatorioDiario
    WHERE NomeAtividade = f_nomeAtividade AND NomeMedicao = f_NomeMedicao AND DataRel = f_Data AND idUsuario = f_IdUsuario ) AS RESULT);
    RETURN RESULT;
END $$ 
DELIMITER ;


-- 3.  Criar uma SP que percorra todos os valores de medição diária por um ano e inserir os valores correspondentes na tabela RelatorioDiario. Atenção  para não inserir registros duplicados na tabela RelatorioDiario.
-- Nome SP: sp_relatorio_diario_inserir_ano 
-- Parâmetros Entrada: ano smallint 

-- A sp deve conter:
-- Um cursor: que percorrerá todas as medições do ano;
-- Tratamento de erros: SQLEXCEPTION;
-- Transação: TODOS os valores devem ser inseridos se não houver erros. Se houver um erro, não insira NENHUM valor.
-- Além disso, a sp criada no exercício 1 e a função criada no exercício 2 devem ser usadas.

DELIMITER $$
CREATE PROCEDURE sp_relatorio_diario_inserir_ano2(ano smallint)
BEGIN
DECLARE p_NomeAtividade varchar(45);
DECLARE p_NomeMedicao varchar(45);
DECLARE P_NomeUnidadeMedida varchar(45);
DECLARE p_DataRel Date;
DECLARE p_valor float;
DECLARE p_Usuario_idUsuario int;
DECLARE fimLoop int DEFAULT 0;
DECLARE error_code CHAR(5) DEFAULT '00000';
DECLARE error_msg TEXT DEFAULT '';


DECLARE insert_cursor CURSOR FOR SELECT
r.idRelatorio, a.nome, m.nome, u.nome, m.timestamp, r.Valor  FROM 
relatoriodiario r
INNER JOIN medicao m
ON r.Usuario_idUsuario = m.Usuario_idUsuario
INNER JOIN tipo_medicao t
ON t.id = m.Tipo_Medicao_id
INNER JOIN unidademedida u
ON u.id = m.UnidadeMedida_Id
INNER JOIN atividade a
ON a.id = m.Atividade_id;


DECLARE CONTINUE HANDLER FOR not found SET fimLoop =1;
DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        GET DIAGNOSTICS CONDITION 1
        error_code = RETURNED_SQLSTATE, error_msg = MESSAGE_TEXT;
        SELECT error_code, error_msg;
    END;

OPEN insert_cursor;
START TRANSACTION;

cicle:LOOP
	FETCH insert_cursor INTO p_NomeAtividade, p_NomeMedicao, P_NomeUnidadeMedida, p_DataRel, p_valor, p_Usuario_idUsuario;
    IF fimLoop = 1 THEN
		LEAVE cicle;
	END IF;
    
    IF  fn_existe_relatorioDiario2(p_NomeAtividade, p_NomeMedicao, P_NomeUnidadeMedida, p_DataRel, p_valor, p_Usuario_idUsuario) = 2 THEN 
	CALL sp_relatorio_diario_inserir(p_NomeAtividade, p_NomeMedicao, P_NomeUnidadeMedida, p_DataRel, p_valor, p_Usuario_idUsuario);
	END IF;
    END LOOP;
    COMMIT;
END $$
DELIMITER ;


