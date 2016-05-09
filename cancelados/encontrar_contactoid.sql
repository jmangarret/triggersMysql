DROP PROCEDURE IF EXISTS `encontrar_contactoid`;
DELIMITER |		
CREATE DEFINER=`root`@`localhost` PROCEDURE `encontrar_contactoid`(
	IN firma VARCHAR (255)
)
BEGIN
	SET @contid = (SELECT contactid FROM vtiger_contactdetails WHERE  firmas_satelite LIKE CONCAT('%',firma,'%'));
	
	IF isnull(@contid) THEN

	SET @contid = (SELECT usercontactoid FROM vtiger_terminales WHERE  firma LIKE CONCAT('%',firma,'%'));

	END IF;
END |
DELIMITER ;