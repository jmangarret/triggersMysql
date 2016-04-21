DROP PROCEDURE IF EXISTS getFeeBoleto;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `getFeeBoleto`(
	IN _status VARCHAR(50), 
	IN _tipodevuelo VARCHAR(50), 
	IN _itinerario VARCHAR(250)
	)
BEGIN 
DECLARE MONTO_FEE DOUBLE(8,2) DEFAULT 0;
SET sql_safe_updates=0;
	IF (_status = 'Emitido') THEN
		IF (_tipodevuelo = 'Nacional') THEN
			IF (length(_itinerario) > 7) THEN
				SET MONTO_FEE=(select valor_base from vtiger_tarifas where codigo LIKE '%EMI_NAC_IDV%');
			ELSE
				SET MONTO_FEE=(select valor_base from vtiger_tarifas where codigo LIKE '%EMI_NAC_IDA%');
			END IF;
		ELSE
			SET MONTO_FEE=(select valor_base from vtiger_tarifas where codigo LIKE '%EMI_INT%');
		END IF;
	ELSEIF (_status = 'Reemitido') THEN
		IF (_tipodevuelo = 'Nacional') THEN
			/*IF (cliente = publico general) THEN*/
				SET MONTO_FEE=(select valor_base from vtiger_tarifas where codigo  LIKE	'%REE_NAC_PGE%');
			/*ELSE
				SET MONTO_FEE=(select valor_base from vtiger_tarifas where codigo LIKE '%REE_NAC_SAT%');
			END IF;
		ELSEIF (NEW.tipodevuelo = 'Internacional') THEN
			IF (cliente = publico general) THEN
				SET MONTO_FEE=(select valor_base from vtiger_tarifas where codigo LIKE '%REE_INT_PGE%');*/
			ELSE
				/*SET MONTO_FEE=(select valor_base from vtiger_tarifas where codigo LIKE '%REE_INT_SAT%');*/
				SET MONTO_FEE=(select valor_base from vtiger_tarifas where codigo LIKE '%REE_INT_PGE%'); /*Si existe tipo de cliente se elimina esta linea y se deja la de arriba*/
		END IF;
	ELSEIF (_status = 'Reembolsos') THEN
		/*IF (cliente = publico general) THEN*/
			SET MONTO_FEE=(select valor_base from vtiger_tarifas where codigo LIKE '%REM_INT_PGE%');
		/*ELSE
			SET MONTO_FEE=(select valor_base from vtiger_tarifas where codigo LIKE '%REM_INT_SAT%');
		END IF;*/
	ELSEIF (_status = 'Anulado') THEN
		IF (_tipodevuelo = 'Nacional') THEN
			SET MONTO_FEE=(select valor_base from vtiger_tarifas where codigo LIKE '%ANU_NAC%');
		ELSE
			SET MONTO_FEE=(select valor_base from vtiger_tarifas where codigo LIKE '%ANU_INT_PGE%');
		END IF;
	ELSEIF (_status = 'Seguro') THEN
		SET MONTO_FEE=(select valor_base from vtiger_tarifas where codigo LIKE '%ASI_PAS%');
	ELSE
		SET MONTO_FEE=(select valor_base from vtiger_tarifas where codigo LIKE '%SEL_BOL%');
	END IF;
    /*END IF;*/
    SET @MONTO_FEE= MONTO_FEE;
END |
DELIMITER ;