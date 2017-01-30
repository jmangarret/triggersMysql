/********* ACCION MIGRAD A CRM HANDLER LOCALIZADORES */

/*TRIGGER AL ACTUALIZAR LOCALIZADOR*/

/*
DROP TRIGGER IF EXISTS crm_localizadores_update;
DELIMITER |
CREATE TRIGGER crm_localizadores_update AFTER UPDATE ON vtiger_localizadores
FOR EACH ROW BEGIN	

	CALL valExonerarFee(NEW.localizadoresid);

END|
DELIMITER ;

*/

/*STORE PROCEDURE PARA EXONERAR FEE A TODOS LOS BOLETOS DEL MISMO LOCALIZADOR*/

/*
DROP PROCEDURE IF EXISTS `valExonerarFee`;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `valExonerarFee`(IN _locid VARCHAR(11))
BEGIN 
	DECLARE _idboleto INT;	
	DECLARE _cursor_boletos 
	CURSOR FOR SELECT boletosid FROM vtiger_boletos WHERE localizadorid=CONVERT(_locid, SIGNED INTEGER);	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET @end_row = TRUE;
	
	OPEN _cursor_boletos;
	loop1: LOOP

	FETCH _cursor_boletos INTO _idboleto;
		IF @end_row THEN
			LEAVE loop1;
		END IF;	

		UPDATE vtiger_boletos SET fee=0 WHERE boletosid=_idboleto;	
	
	END LOOP loop1;
	CLOSE _cursor_boletos;

END |
DELIMITER ;

*/