DELIMITER $$
CREATE PROCEDURE sumExemp(out sumTotal decimal(10,2))
BEGIN	
	DECLARE vv decimal(10,2) DEFAULT 0;
    DECLARE endLoop int DEFAULT 0;
    
    DECLARE sum_cursor CURSOR FOR SELECT valor_total FROM faturas;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET endLoop = 1;
    
    SET sumTotal = 0;
    
    OPEN sum_cursor;
    WHILE(endloop != 1) DO
		FETCH sum_cursor INTO vv;
        SET sumTotal = sumTotal +vv;
	END WHILE;
    CLOSE sum_cursor;
    END $$
    DELIMITER ;
    
    CALL sumExemp(@totalFaturas);
    select @totalFaturas;
    
    -- TEMPORARY TABLE
    CREATE TEMPORARY TABLE tmp_faturas
    SELECT id, id_Cliente, cidade_cobranca, valor_total
    FROM faturas;
    
    SELECT * FROM tmp_faturas;
    
    DELIMITER $$
    CREATE PROCEDURE sp_itens_faturas_inserir(p_id smallint, p_id_fatura smallint, p_id_cancao smallint, 
    p_preco_unitario decimal(3,2), p_quantidade tinyint)
    BEGIN
    INSERT INTO itens_faturas(id, id_fatura, id_cancao, preco_unitario, quantidade)
    VALUES(p_id, p_id_fatura, p_id_cancao, p_preco_unitario, p_quantidade);
    
    END $$
    DELIMITER $$
    
    CREATE PROCEDURE sp_itens_faturas_cursor()
    
    BEGIN 
    DECLARE c_id smallint default 0;
    DECLARE c_id_fatura smallint default 0;
    DECLARE c_id_cancao smallint default 0;
    DECLARE c_preco_unitario DECIMAL(3,2) DEFAULT 0;
    DECLARE c_quantidade tinyint DEFAULT 0;
    DECLARE has_error int DEFAULT 0;
    
    DECLARE meuCursor CURSOR FOR SELECT id, id_fatura, id_cancao, preco_unitario, quantidade
    FROM temp_itens_faturas;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET has_error = 1;
    
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_itens_faturas
    SELECT id, id_fatura, id_cancao, preco_unitario, 20 as quantidade
    FROM itens_faturas ORDER BY id LIMIT 100;
    
    OPEN meuCursor;
    
    carregarFaturas : LOOP
    
    FETCH meuCursor INTO c_id, c_id_fatura, c_id_cancao, c_preco_unitario, c_quantidade;
    
    if has_error = 1 THEN
		LEAVE carregarFaturas;
	else
		SET c_id = (SELECT MAX(id) + 1 FROM itens_faturas);
	
    CALL sp_itens_faturas_inserir(c_id, c_id_fatura, c_id_cancao, c_preco_unitario, c_quantidade);
    
    END IF;
    END LOOP;
    CLOSE meuCursor;
    
    END $$
    DELIMITER ;
    
    
    call sp_itens_faturas_cursor;
    
    
    
    
    