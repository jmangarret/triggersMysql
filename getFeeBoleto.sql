DROP PROCEDURE IF EXISTS getFeeBoleto;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `getFeeBoleto`(
	IN _locid INT(11), 
	IN _status VARCHAR(50), 
	IN _tipodevuelo VARCHAR(50), 
	IN _itinerario VARCHAR(250)
	)
BEGIN 
	DECLARE MONTO_FEE DOUBLE(8,2) DEFAULT 0;
	DECLARE CLIENTE VARCHAR(100);
	DECLARE AEROLINEA VARCHAR(100);
	SET sql_safe_updates=0;
	SET CLIENTE=(SELECT acc.account_type
		FROM vtiger_account AS acc 
		INNER JOIN vtiger_contactdetails 	AS con ON acc.accountid=con.accountid 
		INNER JOIN vtiger_localizadores 	AS loc ON loc.contactoid=con.contactid 
		WHERE loc.localizadoresid=_locid);
	SET AEROLINEA=(SELECT airline FROM vtiger_localizadores WHERE localizadoresid=_locid);
	CALL valFeeBoleto(_locid);
	IF (@feeBoleto>0) THEN	
		/*FEE DE AGENCIA A COBRAR POR EMISION CLIENTE FINAL*/
		/*CUANDO ES SATELITE SE COBRA POR EL MODULO DE TIPO DE COMISIONES SATELITES TIPO CARGOS*/ 
		IF (_status = 'Emitido') THEN
			IF (_tipodevuelo = 'Nacional') THEN
				IF (length(_itinerario) > 7) THEN
					SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%EMI_NAC_IDV%');
				ELSE
					SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%EMI_NAC_IDA%');
				END IF;
			ELSE
				SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%EMI_INT%');
			END IF;
		END IF;
		/*FEE DE AGENCIA A COBRAR POR RE-EMISION*/ 
		IF (_status = 'Reemitido') THEN
			IF (_tipodevuelo = 'Nacional') THEN
				SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo  LIKE	'%REE_NAC_PGE%');
				IF (CLIENTE ='Satelite') THEN
					SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%REE_NAC_SAT%');
				END IF;
			ELSE
				SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%REE_INT_PGE%');
				IF (CLIENTE = 'Satelite') THEN
					SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%REE_INT_SAT%');
				END IF;				
			END IF;
		END IF;
		/*FEE DE AGENCIA A COBRAR POR RE-EMBOLSOS*/ 
		IF (_status = 'Reembolsos') THEN
			SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%REM_INT_PGE%');
			IF (CLIENTE ='Satelite') THEN
				SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%REM_INT_SAT%');
			END IF;
		END IF;
		/*FEE DE AGENCIA A COBRAR POR ANULACIONES*/ 
		IF (_status = 'Anulado') THEN
			IF (_tipodevuelo = 'Nacional') THEN
				SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%ANU_NAC%');
				/*AEROLINEAS DEL BSP 9V-AVIOR R7-ASERCA S3-SANTABARBARA QL-LASER AG-ARUBA AIRLINES*/
				IF (AEROLINEA LIKE '9V%' OR AEROLINEA LIKE 'R7%' OR AEROLINEA LIKE 'S3%' OR AEROLINEA LIKE 'QL%' OR AEROLINEA LIKE 'AG%') THEN
					SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%ANU_BSP_PGE%');
				END IF;
				/*AEROLINEA AW-VENEZOLANA AIRLINES*/
				IF (AEROLINEA LIKE 'AW%') THEN
					SET MONTO_FEE=2240;
				END IF;
				/*FIN */
				IF (CLIENTE ='Satelite') THEN
					SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%ANU_SAT%');
				END IF;
			ELSE
				SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%ANU_INT_PGE%');
				/*AEROLINEAS DEL BSP 9V-AVIOR R7-ASERCA S3-SANTABARBARA QL-LASER AG-ARUBA AIRLINES*/
				IF (AEROLINEA LIKE '9V%' OR AEROLINEA LIKE 'R7%' OR AEROLINEA LIKE 'S3%' OR AEROLINEA LIKE 'QL%' OR AEROLINEA LIKE 'AG%') THEN
					SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%ANU_BSP_PGE%');
				END IF;
				/*AEROLINEA AW-VENEZOLANA AIRLINES*/
				IF (AEROLINEA LIKE 'AW%') THEN
					SET MONTO_FEE=2240;
				END IF;
				/*FIN */
				IF (CLIENTE ='Satelite') THEN
					SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%ANU_SAT%');
				END IF;
			END IF;
		END IF;
	END IF;

    SET @MONTO_FEE= MONTO_FEE;
END |
DELIMITER ;