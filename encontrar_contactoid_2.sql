DROP PROCEDURE IF EXISTS `encontrar_contactoid`;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `encontrar_contactoid`(
	IN firma VARCHAR (255)
)
BEGIN
/*
	FUNCION DESACTIVADA. NO ENVIA EL VALOR CORRECTO
*/
	SET @contacto_id=0;
	SET @contacto_id = (SELECT DISTINCT usercontactoid FROM vtiger_terminales AS t INNER JOIN vtiger_contactdetails AS d ON t.usercontactoid=d.contactid WHERE firma LIKE CONCAT('%',firma,'%') LIMIT 1);
/*	
	IF ISNULL(@contid) THEN
 		SET @contid=0;
 	END IF;
*/	
END |
DELIMITER ;