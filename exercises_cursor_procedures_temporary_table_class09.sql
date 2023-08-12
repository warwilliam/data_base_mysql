DELIMITER $$
CREATE FUNCTION obter_idade(dataNasc date) returns tinyint
DETERMINISTIC
BEGIN
DECLARE RESULT TINYINT;
SET RESULT = (SELECT timestampdiff(YEAR, dataNasc, CURDATE()));
RETURN RESULT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE mostrar_conteudo(p_id int)
BEGIN
DEClARE dt_nasc date;
SET dt_nasc = (SELECT data_nascimento from usuarios WHERE id = p_id);
SELECT f.titulo, g.nome as genero 
FROM filmes f
INNER JOIN filme_genero fg
ON f.filme_id = fg.filme_id
INNER JOIN generos g
ON g.genero_id = fg.genero_id
WHERE g.idade = 
CASE WHEN obter_idade(dt_nasc) BETWEEN 0 AND 8 THEN 0
 WHEN obter_idade(dt_nasc) BETWEEN 9 AND 12 THEN 9
 WHEN obter_idade(dt_nasc) BETWEEN 13 AND 16 THEN 13
 WHEN obter_idade(dt_nasc) BETWEEN 17 AND 24 THEN 17
 WHEN obter_idade(dt_nasc) BETWEEN 25 AND 40 THEN 25
 WHEN obter_idade(dt_nasc) BETWEEN 40 AND 49 THEN 40
 WHEN obter_idade(dt_nasc) BETWEEN 50 AND 55 THEN 50
 WHEN obter_idade(dt_nasc) >= 55 THEN 55
 END;
END $$
DELIMITER ;

CALL mostrar_conteudo(1);


DELIMITER $$
CREATE FUNCTION fn_diaUtil(data1 date) RETURNS date DETERMINISTIC
BEGIN
	DECLARE diaUtil date;
    if weekday(data1) < 5 then
		SET diaUtil = data1;
	elseif weekday(data1) = 5 THEN 
    -- sabado
		SET diaUtil = date_add(data1, INTERVAL 2 DAY);
	else 
	-- domingo
		SET diaUtil = date_add(data1, INTERVAL 1 DAY);
	end if;
    RETURN diaUtil;
END $$
DELIMITER ; 


DELIMITER $$
CREATE PROCEDURE sp_gera_parcela(p_id int, p_dataInicio date)
BEGIN 
	DECLARE valorParcela decimal(10,2) default 1;
    DECLARE vParcela int;
    DECLARE pParcelas int;
    DECLARE dataParcela date;
    DECLARE dt_nasc date;
    DECLARE pPlano varchar(50);
    
    SET vParcela= 1;
    SET dt_nasc = (SELECT data_nascimento FROM usuarios where id = p_id);
    SET pParcelas = (SELECT fidelidade FROM pacotes WHERE obter_idade(dt_nasc)
    BETWEEN idade_min AND idade_max);
    SET pPlano = (SELECT tipo from pacotes WHERE obter_idade(dt_nasc)
    BETWEEN idade_min AND idade_max);
    
    SET valorParcela = (SELECT valor from pacotes WHERE obter_idade(dt_nasc)
    BETWEEN idade_min AND idade_max);
    DROP TABLE IF EXISTS tmpParcelas; 
    CREATE TEMPORARY TABLE tmpParcelas(
    id_usuario int, plano varchar(50), nroParcela int, dataVenc date, valor decimal(10,2));
    
    set dataParcela = p_dataInicio;
    WHILE vParcela <= pParcelas DO
    INSERT INTO tmpParcelas ( id_usuario, plano, nroParcela, dataVenc, valor) 
    VALUES (p_id, pPlano, vParcela, fn_diaUtil(dataParcela), valorParcela);
    
    SET dataParcela = date_add(dataParcela, INTERVAL 30 day);
    SET vParcela = vParcela +1;
END WHILE;

SELECT
	id_usuario as 'USUARIO',
    plano as 'Plano',
    nroParcela as 'nr da parcela',
    date_format(dataVenc, '%d %m %y') as 'Data de Vencimento',
    valor as 'Valo da Parcela'
    FROM tmpParcelas;
    END $$
    DELIMITER ;
    
    CALL sp_gera_parcela(396, '2022-08-25');
    
    
    
    DELIMITER $$
    CREATE PROCEDURE sp_assinaturas_inserir(p_id_usuario int, p_plano varchar(30), 
    p_parcela int, p_dataVenc date, p_valor decimal(10,2))
    
    BEGIN
    INSERT INTO assinaturas(id_usuario, plano, parcelas, dataVenc, valor)
    VALUES (p_id_usuario, p_plano, p_parcela, p_dataVenc, p_valor);
    
    END $$
    DELIMITER ;
    
    DELIMITER $$
    CREATE PROCEDURE sp_assinaturas_cursor()
    BEGIN
    DECLARE c_id_usuario int DEFAULT 0;
    DECLARE c_plano varchar(30) DEFAULT null;
    DECLARE c_parcela int DEFAULT 0;
    DECLARE c_dataVenc date;
    DECLARE c_valor decimal(10,2) DEFAULT 0;
    DECLARE fimLoop int DEFAULT 0;
    
    DECLARE insert_cursor CURSOR FOR SELECT id_usuario, plano, nroParcela, dataVenc, valor
    FROM tmpParcelas;
    DECLARE CONTINUE HANDLER FOR not found SET fimLoop =1;
    
    OPEN insert_cursor;
    carregarParcelas: LOOP
    FETCH insert_cursor INTO c_id_usuario, c_plano, c_parcela, c_dataVenc, c_valor;
    IF fimLoop = 1 THEN
		LEAVE carregarParcelas;
	else
    
		CALL sp_assinaturas_inserir(c_id_usuario, c_plano, c_parcela, c_dataVenc, c_valor);
	END IF;
	END LOOP;
    CLOSE insert_cursor;
    
    END $$
    DELIMITER ;
    
    CALL sp_assinaturas_cursor();
    

