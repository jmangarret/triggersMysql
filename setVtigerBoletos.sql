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
	IN _YN_tax decimal(15,2),
	IN _total_tax decimal(15,2),
	IN bandera INT
	)
BEGIN
DECLARE lastLocalizadorID INT;
	IF (_tipodevuelo="International") 	THEN	SET _tipodevuelo="Internacional"; 	END IF;
	IF (_tipodevuelo="National") 		THEN	SET _tipodevuelo="Nacional"; 		END IF;

	IF (_status="" OR _status IS NULL) THEN
		SET _status=(SELECT DISTINCT emittedStatus FROM ibiptest.ifm_pnrairsegment WHERE pnrLocator=_localizador);
	END IF;	

	IF (_status="Anulado" OR _status="Cancelado") THEN
		UPDATE vtiger_boletos SET status=_status,localizador=_localizador,localizadorid=_localizadorid WHERE boleto1=_boleto_number;
	ELSE
		INSERT INTO vtiger_boletos (boletosid,boleto1,localizador,currency,fee_airline,amount,localizadorid,monto_base,fecha_emision,passenger,itinerario,status,tipodevuelo,yn_tax,total_tax) 
		VALUES (_boletosid,_boleto_number,_localizador,_currency,_fee,_amount,_localizadorid,_montobase,_fecha_emision,_passenger,_itinerario,_status,_tipodevuelo,_YN_tax,_total_tax);
		IF ROW_COUNT()>0 THEN	
			INSERT INTO vtiger_boletoscf (boletosid) VALUES (_boletosid);
			call getCrmId();

			INSERT INTO vtiger_crmentityrel VALUES (_localizadorid, "Localizadores", _boletosid, "Boletos");

			call setCrmEntity("Boletos", CONCAT(@_passenger,'',_boleto_number), @_creationDate, @idcrm, @iduser);

			call setComission(_boletosid,0);

		END IF;
	END IF;
END |
DELIMITER ;