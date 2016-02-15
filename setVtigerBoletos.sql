DROP PROCEDURE IF EXISTS setVtigerBoletos;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `setVtigerBoletos`(
	IN _boletosid INT, 
	IN _boleto_number VARCHAR(128), 
	IN _localizador VARCHAR(128),
	IN _currency VARCHAR(128), 	
	IN _fee double(8,2),	
	IN _amount double(8,2),
	IN _montobase double(8,2),
	IN _localizadorid INT,
	IN _fecha_emision date,
	IN _passenger VARCHAR(100),
	IN _itinerario VARCHAR(255),
	IN _status VARCHAR(50),
	IN _tipodevuelo VARCHAR(255),
	IN bandera INT
	)
BEGIN
DECLARE lastLocalizadorID INT;
	
	INSERT INTO vtiger_boletos (boletosid,boleto1,localizador,currency,fee_airline,amount,localizadorid,monto_base,fecha_emision,passenger,itinerario,status,tipodevuelo) 
	VALUES (_boletosid,_boleto_number,_localizador,_currency,_fee,_amount,_localizadorid,_montobase,_fecha_emision,_passenger,_itinerario,_status,_tipodevuelo);
	IF ROW_COUNT()>0 THEN	
		INSERT INTO vtiger_boletoscf (boletosid) VALUES (_boletosid);
		call getCrmId();

		INSERT INTO vtiger_crmentityrel VALUES (_localizadorid, "Localizadores", _boletosid, "Boletos");

		call setCrmEntity("Boletos", CONCAT(@_passenger,'',_boleto_number), @_creationDate, @idcrm, @iduser);

		IF bandera = 1 THEN
			SET lastLocalizadorID = (SELECT localizadoresid FROM vtigercrm600.vtiger_localizadores WHERE localizador = _localizador);
		ELSE
			SET lastLocalizadorID = (SELECT max(localizadoresid) FROM vtigercrm600.vtiger_localizadores);
		END IF;

		call getTypeComision(lastLocalizadorID,0);

	END IF;
END |
DELIMITER ;