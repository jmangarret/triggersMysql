DROP PROCEDURE IF EXISTS `setVtigerLocalizadorescf`;
DELIMITER |
CREATE DEFINER=`root`@`localhost` PROCEDURE `setVtigerLocalizadorescf`(
 IN localizadoresid INT
 )
BEGIN 
INSERT INTO vtiger_localizadorescf (localizadoresid) VALUES (localizadoresid);
END |
DELIMITER ;