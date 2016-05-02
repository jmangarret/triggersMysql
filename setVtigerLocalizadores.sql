DROP PROCEDURE IF EXISTS setVtigerLocalizadores;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `setVtigerLocalizadores`(
	IN localizadoresid INT, 
	IN localizador VARCHAR(128), 
	IN contacto_id INT,
	IN sistemagds VARCHAR(128), 	
	IN paymentmethod VARCHAR(128),
	IN aerolinea VARCHAR(128),
	IN status VARCHAR(128)
	)
BEGIN 
set @salida = 0;	
	IF (paymentmethod="Cash") 	THEN	SET paymentmethod="Efectivo"; 			END IF;
	IF (paymentmethod="CC") 	THEN	SET paymentmethod="Credito"; 			END IF;
	IF (paymentmethod="AX") 	THEN	SET paymentmethod="American Express"; 	END IF;
	
	INSERT INTO vtiger_localizadores (localizadoresid,localizador,contactoid,gds,paymentmethod,airline,status) 
	VALUES (localizadoresid,localizador,contacto_id,sistemagds,paymentmethod,aerolinea,status);
	IF ROW_COUNT()>0 THEN
		call setVtigerLocalizadorescf(localizadoresid);
		call setCrmEntity("Localizadores", @_localizador, @_creationDate, @idcrm, @iduser);
		SET @salida = 1;
		SET @_sistemagds = sistemagds;
	END IF;
END |
DELIMITER ;