DROP PROCEDURE IF EXISTS `updateBoletos`;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateBoletos`()
BEGIN 
	DECLARE _idboleto INT;
	DECLARE _idloc INT;
	DECLARE _status VARCHAR(100);
	DECLARE _tipodevuelo VARCHAR(100);
	DECLARE _itinerario VARCHAR(100);

	DECLARE _cursor_boletos CURSOR FOR
	SELECT boletosid,localizadorid,status,tipodevuelo,itinerario FROM vtiger_boletos;
	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET @end_row = TRUE;
	OPEN _cursor_boletos;
	loop1: LOOP
	FETCH _cursor_boletos INTO _idboleto, _idloc,_status,_tipodevuelo,_itinerario;
	IF @end_row THEN
		LEAVE loop1;
	END IF;	
	SET @feeBoleto=0;
	IF (_idloc>15871) THEN		
			CALL valFeeBoleto(_idloc);
			IF (@feeBoleto>0) THEN				
				CALL getFeeBoleto(_idloc,_status,_tipodevuelo,_itinerario);
				UPDATE vtiger_boletos SET fee=@MONTO_FEE WHERE boletosid=_idboleto;			
			ELSE
				UPDATE vtiger_boletos SET fee=0 WHERE boletosid=_idboleto;
			END IF;						
	END IF;

	END LOOP loop1;
	CLOSE _cursor_boletos;

END |
DELIMITER ;
