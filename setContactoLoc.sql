/*LLamado desde procedure setCrmEntityRel*/
DROP PROCEDURE IF EXISTS setContactoLoc;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `setContactoLoc`(
	IN _idloc INT, 
	IN _idrel INT
	)
BEGIN 
DECLARE contactoLoc INT; 
DECLARE contactoVta INT; 

SET contactoLoc=(SELECT contactoid FROM vtiger_localizadores WHERE localizadoresid=_idloc);

IF (contactoLoc<1 OR contactoLoc IS NULL) THEN	
	SET contactoVta=(SELECT contacto FROM vtiger_registrodeventas WHERE registrodeventasid=_idrel);

	UPDATE vtiger_localizadores SET contactoid=contactoVta WHERE localizadoresid=_idloc;
END IF;


END |
DELIMITER ;