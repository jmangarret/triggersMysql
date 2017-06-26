DROP PROCEDURE IF EXISTS setTotalBoletos;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `setTotalBoletos`(
	IN _modulo VARCHAR(250), 
	IN _crmid INT 
	)
BEGIN 
DECLARE _idloc INT;
DECLARE _cursor_loc CURSOR FOR
SELECT localizadoresid FROM vtiger_localizadores WHERE registrodeventasid=_crmid;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET @end_row = TRUE;
OPEN _cursor_loc;
loop1: LOOP
FETCH _cursor_loc INTO _idloc;
IF @end_row THEN
	LEAVE loop1;
END IF;	
IF _modulo="RegistroDeVentas" THEN			
	UPDATE 	vtiger_boletos
	SET 	totalboletos=amount+fee+extra_fee
	WHERE  	localizadorid=_idloc 
			AND localizadorid NOT IN (SELECT crmid FROM vtiger_crmentity WHERE deleted=1 AND setype="Localizadores");
END IF;		
END LOOP loop1;
CLOSE _cursor_loc;

IF _modulo="Localizadores" THEN			
	UPDATE 	vtiger_boletos
	SET 	totalboletos=amount+fee+extra_fee
	WHERE  	localizadorid=_crmid 
			AND localizadorid NOT IN (SELECT crmid FROM vtiger_crmentity WHERE deleted=1 AND setype="Localizadores");
END IF;	

END |
DELIMITER ;