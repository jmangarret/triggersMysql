DROP PROCEDURE IF EXISTS getFeeBoleto;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `getFeeBoleto`(
	IN _locid INT(11), 
	IN _status VARCHAR(50), 
	IN _tipodevuelo VARCHAR(50), 
	IN _itinerario VARCHAR(250),
	IN _fechaemision DATE
	)
BEGIN 
	DECLARE MONTO_FEE DOUBLE(25,2) DEFAULT 0;
	DECLARE CLIENTE VARCHAR(100);
	DECLARE AEROLINEA VARCHAR(100);
	/*DECLARE FECHAEMISION DATE;*/
	SET sql_safe_updates=0;
	SET CLIENTE=(SELECT acc.account_type
		FROM vtiger_account AS acc 
		INNER JOIN vtiger_contactdetails 	AS con ON acc.accountid=con.accountid 
		INNER JOIN vtiger_localizadores 	AS loc ON loc.contactoid=con.contactid 
		WHERE loc.localizadoresid=_locid);
	SET AEROLINEA=(SELECT airline FROM vtiger_localizadores WHERE localizadoresid=_locid);	
	/*SE COMENTA SET FECHA_EMISION, PARA OBTENER FECHA DE EMISION POR PARAMETRO DESDE TRIGGER BEFORE - NUEVA VARIABLE _fechaemision*/
	/*SET FECHAEMISION=(SELECT CAST(fecha_emision AS DATE) FROM vtiger_boletos WHERE localizadorid=_locid LIMIT 1);*/
	CALL valFeeBoleto(_locid);
	IF (@feeBoleto>0) THEN	
		/*FEE DE AGENCIA A COBRAR POR EMISION CLIENTE FINAL*/
		/*CUANDO ES SATELITE SE COBRA POR EL MODULO DE TIPO DE COMISIONES SATELITES TIPO CARGOS*/ 
		IF (_status = 'Emitido') THEN
			IF (_tipodevuelo = 'Nacional') THEN
				IF (length(_itinerario) > 7) THEN
					/*SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%EMI_NAC_IDV%');*/
					SET MONTO_FEE=(SELECT valor FROM vtiger_tarifas_historico AS H 
									INNER JOIN vtiger_tarifas AS T ON H.tarifasid=T.tarifasid  
									WHERE codigo LIKE '%EMI_NAC_IDV%' AND H.fecha<= _fechaemision ORDER BY fecha DESC LIMIT 1);					
				ELSE
					/*SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%EMI_NAC_IDA%');*/
					SET MONTO_FEE=(SELECT valor FROM vtiger_tarifas_historico AS H 
									INNER JOIN vtiger_tarifas AS T ON H.tarifasid=T.tarifasid  
									WHERE codigo LIKE '%EMI_NAC_IDA%' AND H.fecha<= _fechaemision ORDER BY fecha DESC LIMIT 1);					
				END IF;
			ELSE
				/*SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%EMI_INT%');*/
				SET MONTO_FEE=(SELECT valor FROM vtiger_tarifas_historico AS H 
									INNER JOIN vtiger_tarifas AS T ON H.tarifasid=T.tarifasid  
									 WHERE codigo LIKE '%EMI_INT%' AND H.fecha<= _fechaemision ORDER BY fecha DESC LIMIT 1);				
			END IF;
		END IF;
		/*FEE DE AGENCIA A COBRAR POR RE-EMISION*/ 
		IF (_status = 'Reemitido') THEN
			IF (_tipodevuelo = 'Nacional') THEN
				/*SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo  LIKE	'%REE_NAC_PGE%');*/
				SET MONTO_FEE=(SELECT valor FROM vtiger_tarifas_historico AS H 
									INNER JOIN vtiger_tarifas AS T ON H.tarifasid=T.tarifasid  
									 WHERE codigo LIKE '%REE_NAC_PGE%' AND H.fecha<= _fechaemision ORDER BY fecha DESC LIMIT 1);				
				IF (CLIENTE ='Satelite') THEN
					/*SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%REE_NAC_SAT%');*/
					SET MONTO_FEE=(SELECT valor FROM vtiger_tarifas_historico AS H 
									INNER JOIN vtiger_tarifas AS T ON H.tarifasid=T.tarifasid  
									 WHERE codigo LIKE '%REE_NAC_SAT%' AND H.fecha<= _fechaemision ORDER BY fecha DESC LIMIT 1);					
				END IF;
				IF (CLIENTE ='Freelance Plus') THEN
					/*SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%REE_NAC_PLUS%');*/
					SET MONTO_FEE=(SELECT valor FROM vtiger_tarifas_historico AS H 
									INNER JOIN vtiger_tarifas AS T ON H.tarifasid=T.tarifasid  
									 WHERE codigo LIKE '%REE_NAC_PLUS%' AND H.fecha<= _fechaemision ORDER BY fecha DESC LIMIT 1);					
				END IF;
			ELSE
				/*SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%REE_INT_PGE%');*/
				SET MONTO_FEE=(SELECT valor FROM vtiger_tarifas_historico AS H 
									INNER JOIN vtiger_tarifas AS T ON H.tarifasid=T.tarifasid  
									 WHERE codigo LIKE '%REE_INT_PGE%' AND H.fecha<= _fechaemision ORDER BY fecha DESC LIMIT 1);				
				IF (CLIENTE = 'Satelite') THEN
					/*SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%REE_INT_SAT%');*/
					SET MONTO_FEE=(SELECT valor FROM vtiger_tarifas_historico AS H 
									INNER JOIN vtiger_tarifas AS T ON H.tarifasid=T.tarifasid  
									 WHERE codigo LIKE '%REE_INT_SAT%' AND H.fecha<= _fechaemision ORDER BY fecha DESC LIMIT 1);					
				END IF;				
				IF (CLIENTE ='Freelance Plus') THEN
					/*SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%REE_INT_PLUS%');*/
					SET MONTO_FEE=(SELECT valor FROM vtiger_tarifas_historico AS H 
									INNER JOIN vtiger_tarifas AS T ON H.tarifasid=T.tarifasid  
									 WHERE codigo LIKE '%REE_INT_PLUS%' AND H.fecha<= _fechaemision ORDER BY fecha DESC LIMIT 1);					
				END IF;
			END IF;
		END IF;
		/*FEE DE AGENCIA A COBRAR POR RE-EMBOLSOS*/ 
		IF (_status = 'Reembolsos') THEN
			/*SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%REM_INT_PGE%');*/
			SET MONTO_FEE=(SELECT valor FROM vtiger_tarifas_historico AS H 
									INNER JOIN vtiger_tarifas AS T ON H.tarifasid=T.tarifasid  
									 WHERE codigo LIKE '%REM_INT_PGE%' AND H.fecha<= _fechaemision ORDER BY fecha DESC LIMIT 1);			
			IF (CLIENTE ='Satelite') THEN
				/*SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%REM_INT_SAT%');*/
				SET MONTO_FEE=(SELECT valor FROM vtiger_tarifas_historico AS H 
								INNER JOIN vtiger_tarifas AS T ON H.tarifasid=T.tarifasid  
								 WHERE codigo LIKE '%REM_INT_SAT%' AND H.fecha<= _fechaemision ORDER BY fecha DESC LIMIT 1);

			END IF;
		END IF;
		/*FEE DE AGENCIA A COBRAR POR ANULACIONES*/ 
		IF (_status = 'Anulado') THEN
			IF (_tipodevuelo = 'Nacional') THEN
				/*SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%ANU_NAC%');*/
				SET MONTO_FEE=(SELECT valor FROM vtiger_tarifas_historico AS H 
								INNER JOIN vtiger_tarifas AS T ON H.tarifasid=T.tarifasid  
								 WHERE codigo LIKE '%ANU_NAC%' AND H.fecha<= _fechaemision ORDER BY fecha DESC LIMIT 1);				
				/*AEROLINEAS DEL BSP 9V-AVIOR R7-ASERCA S3-SANTABARBARA QL-LASER AG-ARUBA AIRLINES*/
				IF (AEROLINEA LIKE '9V%' OR AEROLINEA LIKE 'R7%' OR AEROLINEA LIKE 'S3%' OR AEROLINEA LIKE 'QL%' OR AEROLINEA LIKE 'AG%') THEN
					/*SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%ANU_BSP_PGE%');*/
					SET MONTO_FEE=(SELECT valor FROM vtiger_tarifas_historico AS H 
									INNER JOIN vtiger_tarifas AS T ON H.tarifasid=T.tarifasid  
									 WHERE codigo LIKE '%ANU_BSP_PGE%' AND H.fecha<= _fechaemision ORDER BY fecha DESC LIMIT 1);					
				END IF;
				/*AEROLINEA AW-VENEZOLANA AIRLINES*/
				IF (AEROLINEA LIKE 'AW%') THEN
					/*SET MONTO_FEE=3740;*/
					SET MONTO_FEE=(SELECT valor FROM vtiger_tarifas_historico AS H 
									INNER JOIN vtiger_tarifas AS T ON H.tarifasid=T.tarifasid  
									 WHERE codigo LIKE '%ANU_AER_VEN%' AND H.fecha<= _fechaemision ORDER BY fecha DESC LIMIT 1);																				
				END IF;
				/*FIN */
				IF (CLIENTE ='Satelite') THEN
					/*SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%ANU_SAT%');*/
					SET MONTO_FEE=(SELECT valor FROM vtiger_tarifas_historico AS H 
									INNER JOIN vtiger_tarifas AS T ON H.tarifasid=T.tarifasid  
									 WHERE codigo LIKE '%ANU_SAT%' AND H.fecha<= _fechaemision ORDER BY fecha DESC LIMIT 1);										
				END IF;
				IF (CLIENTE ='Freelance Plus') THEN
					/*SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%ANU_FREE_PLUS%');*/
					SET MONTO_FEE=(SELECT valor FROM vtiger_tarifas_historico AS H 
									INNER JOIN vtiger_tarifas AS T ON H.tarifasid=T.tarifasid  
									 WHERE codigo LIKE '%ANU_FREE_PLUS%' AND H.fecha<= _fechaemision ORDER BY fecha DESC LIMIT 1);										
				END IF;
				/*AEROLINEAS DEL BSP 9V-AVIOR R7-ASERCA S3-SANTABARBARA QL-LASER AG-ARUBA AIRLINES*/
				IF (AEROLINEA LIKE '9V%' OR AEROLINEA LIKE 'R7%' OR AEROLINEA LIKE 'S3%' OR AEROLINEA LIKE 'QL%' OR AEROLINEA LIKE 'AG%') THEN
					/*SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%ANU_BSP_PGE%');*/
					SET MONTO_FEE=(SELECT valor FROM vtiger_tarifas_historico AS H 
									INNER JOIN vtiger_tarifas AS T ON H.tarifasid=T.tarifasid  
									 WHERE codigo LIKE '%ANU_BSP_PGE%' AND H.fecha<= _fechaemision ORDER BY fecha DESC LIMIT 1);										
				END IF;
				/*AEROLINEA AW-VENEZOLANA AIRLINES*/
				IF (AEROLINEA LIKE 'AW%') THEN	
					/*SET MONTO_FEE=3740;*/
					SET MONTO_FEE=(SELECT valor FROM vtiger_tarifas_historico AS H 
									INNER JOIN vtiger_tarifas AS T ON H.tarifasid=T.tarifasid  
									 WHERE codigo LIKE '%ANU_AER_VEN%' AND H.fecha<= _fechaemision ORDER BY fecha DESC LIMIT 1);																				
				END IF;
			ELSE
				/*SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%ANU_INT_PGE%');*/
				SET MONTO_FEE=(SELECT valor FROM vtiger_tarifas_historico AS H 
								INNER JOIN vtiger_tarifas AS T ON H.tarifasid=T.tarifasid  
								WHERE codigo LIKE '%ANU_INT_PGE%' AND H.fecha<= _fechaemision ORDER BY fecha DESC LIMIT 1);									
				/*AEROLINEAS DEL BSP 9V-AVIOR R7-ASERCA S3-SANTABARBARA QL-LASER AG-ARUBA AIRLINES*/
				IF (AEROLINEA LIKE '9V%' OR AEROLINEA LIKE 'R7%' OR AEROLINEA LIKE 'S3%' OR AEROLINEA LIKE 'QL%' OR AEROLINEA LIKE 'AG%') THEN
					/*SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%ANU_BSP_PGE%');*/
					SET MONTO_FEE=(SELECT valor FROM vtiger_tarifas_historico AS H 
									INNER JOIN vtiger_tarifas AS T ON H.tarifasid=T.tarifasid  
									 WHERE codigo LIKE '%ANU_BSP_PGE%' AND H.fecha<= _fechaemision ORDER BY fecha DESC LIMIT 1);										
				END IF;
				/*AEROLINEA AW-VENEZOLANA AIRLINES*/
				IF (AEROLINEA LIKE 'AW%') THEN
					/*SET MONTO_FEE=3740;*/
					SET MONTO_FEE=(SELECT valor FROM vtiger_tarifas_historico AS H 
									INNER JOIN vtiger_tarifas AS T ON H.tarifasid=T.tarifasid  
									 WHERE codigo LIKE '%ANU_AER_VEN%' AND H.fecha<= _fechaemision ORDER BY fecha DESC LIMIT 1);															
				END IF;
				/*FIN */
				IF (CLIENTE ='Satelite') THEN
					/*SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%ANU_SAT%');*/
					SET MONTO_FEE=(SELECT valor FROM vtiger_tarifas_historico AS H 
									INNER JOIN vtiger_tarifas AS T ON H.tarifasid=T.tarifasid  
									 WHERE codigo LIKE '%ANU_SAT%' AND H.fecha<= _fechaemision ORDER BY fecha DESC LIMIT 1);										
				END IF;
				IF (CLIENTE ='Freelance Plus') THEN
					/*SET MONTO_FEE=(SELECT valor_base FROM vtiger_tarifas WHERE codigo LIKE '%ANU_FREE_PLUS%');*/
					SET MONTO_FEE=(SELECT valor FROM vtiger_tarifas_historico AS H 
									INNER JOIN vtiger_tarifas AS T ON H.tarifasid=T.tarifasid  
									 WHERE codigo LIKE '%ANU_FREE_PLUS%' AND H.fecha<= _fechaemision ORDER BY fecha DESC LIMIT 1);										
				END IF;
			END IF;
			/*ANULACIONES SATELITES DESPUES DEL 1ER DIA DE LA EMISION - AEROLINEAS: S3 SANTAB, EQ TAME, R7 ASERCA, 9V AVIOR*/
			IF (CLIENTE ='Satelite' AND CURRENT_DATE()>_fechaemision AND (AEROLINEA LIKE '9V%' OR AEROLINEA LIKE 'R7%' OR AEROLINEA LIKE 'S3%' OR AEROLINEA LIKE 'EQ%')) THEN
				/*SET MONTO_FEE=11500;*/
				SET MONTO_FEE=(SELECT valor FROM vtiger_tarifas_historico AS H 
								INNER JOIN vtiger_tarifas AS T ON H.tarifasid=T.tarifasid  
								 WHERE codigo LIKE '%ANU_SAT_DES%' AND H.fecha<= _fechaemision ORDER BY fecha DESC LIMIT 1);														
			END IF;
			/*FIN */
		END IF;
	END IF;

    SET @MONTO_FEE= MONTO_FEE;
END |
DELIMITER ;