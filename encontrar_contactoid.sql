DROP PROCEDURE IF EXISTS encontrar_contactoid;
DELIMITER |		
CREATE DEFINER=`root`@`localhost`Procedure `encontrar_contactoid`(
IN firma VARCHAR (255))
BEGIN

set @contid = (SELECT contactid FROM vtiger_contactdetails WHERE  firmas_satelite like concat('%',firma,'%'));

END |
DELIMITER ;