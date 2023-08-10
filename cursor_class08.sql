DELIMITER $$
CREATE PROCEDURE sumExemp(out sumTotal decimal(10,2))
BEGIN	
	DECLARE vv decimal(10,2) DEFAULT 0;
    DECLARE endLoop int DEFAULT 0;
    
    DECLARE sum_cursor CURSOR FOR SELECT valor_total FROM faturas;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET endLoop = 1;
    
    SET sumTotal = 0;
    
    OPEN sum_cursor;
    WHILE(fimloop != 1) DO
		FETCH sum_cursor INTO vv;
        SET sumTotal = sumTotal +vv;
	END WHILE;
    CLOSE sum_cursor;
    END $$
    DELIMITER ;