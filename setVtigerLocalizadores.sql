DROP PROCEDURE IF EXISTS setVtigerLocalizadores;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `setVtigerLocalizadores`(
	IN localizadoresid INT, 
	IN localizador VARCHAR(128), 
	IN contacto_id VARCHAR(255),
	IN sistemagds VARCHAR(128), 	
	IN paymentmethod VARCHAR(128),
	IN status VARCHAR(128)
	)
BEGIN 
set @salida = 0;
	INSERT INTO vtiger_localizadores (localizadoresid,localizador,contactoid,gds,paymentmethod,status) 
	VALUES (localizadoresid,localizador,contacto_id,sistemagds,paymentmethod,status);
	IF ROW_COUNT()>0 THEN
		call setVtigerLocalizadorescf(localizadoresid);
		call setCrmEntity("Localizadores", @_localizador, @_creationDate, @idcrm, @iduser);
		SET @salida = 1;
		SET @_sistemagds = sistemagds;
	END IF;
END |
DELIMITER ;